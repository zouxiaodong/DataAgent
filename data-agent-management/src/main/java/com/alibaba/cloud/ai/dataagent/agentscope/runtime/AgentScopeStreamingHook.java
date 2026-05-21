/*
 * Copyright 2024-2026 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.alibaba.cloud.ai.dataagent.agentscope.runtime;

import com.alibaba.cloud.ai.dataagent.agentscope.vo.AgentResponse;
import com.alibaba.cloud.ai.dataagent.enums.TextType;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.agentscope.core.hook.ActingChunkEvent;
import io.agentscope.core.hook.Hook;
import io.agentscope.core.hook.HookEvent;
import io.agentscope.core.hook.PostActingEvent;
import io.agentscope.core.hook.PreActingEvent;
import io.agentscope.core.hook.ReasoningChunkEvent;
import io.agentscope.core.message.ContentBlock;
import io.agentscope.core.message.TextBlock;
import io.agentscope.core.message.ToolResultBlock;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import reactor.core.publisher.Mono;

/**
 * Hook that streams AgentScope events to the frontend with proper TextType classification.
 * <p>
 * TextType mappings:
 * <ul>
 *   <li>planner-reasoning text → MARK_DOWN (enables report rendering and download)</li>
 *   <li>datasource.* tool results with rows/columns → RESULT_SET (enables chart/table rendering)</li>
 *   <li>tool status messages → TEXT</li>
 * </ul>
 */
public class AgentScopeStreamingHook implements Hook {

	private static final Logger log = LoggerFactory.getLogger(AgentScopeStreamingHook.class);

	private static final String PLANNER_REASONING_NODE = "planner-reasoning";

	private static final ObjectMapper objectMapper = new ObjectMapper();

	private final String agentId;

	private final String threadId;

	private final AgentRuntimeEventPublisher eventPublisher;

	public AgentScopeStreamingHook(String agentId, String threadId, AgentRuntimeEventPublisher eventPublisher) {
		this.agentId = agentId;
		this.threadId = threadId;
		this.eventPublisher = eventPublisher;
	}

	@Override
	public <T extends HookEvent> Mono<T> onEvent(T event) {
		if (event instanceof ReasoningChunkEvent reasoningChunkEvent) {
			String text = reasoningChunkEvent.getIncrementalChunk().getTextContent();
			if (text != null && !text.isBlank()) {
				emit(PLANNER_REASONING_NODE, text, TextType.MARK_DOWN);
			}
		}
		else if (event instanceof PreActingEvent preActingEvent) {
			emit(resolveToolNodeName(preActingEvent.getToolUse().getName()),
					"Calling tool: " + preActingEvent.getToolUse().getName(), TextType.TEXT);
		}
		else if (event instanceof ActingChunkEvent actingChunkEvent) {
			String text = extractToolResultText(actingChunkEvent.getChunk());
			if (text != null && !text.isBlank()) {
				emit(resolveToolNodeName(actingChunkEvent.getToolUse().getName()), text, TextType.TEXT);
			}
		}
		else if (event instanceof PostActingEvent postActingEvent) {
			handlePostActing(postActingEvent);
		}
		return Mono.just(event);
	}

	private void handlePostActing(PostActingEvent event) {
		String toolName = event.getToolUse().getName();
		String nodeName = resolveToolNodeName(toolName);
		String textResult = extractToolResultText(event.getToolResult());

		if (isDatasourceTool(toolName)) {
			String resultDataJson = convertDatasourceResultToResultData(textResult);
			if (resultDataJson != null) {
				emit(nodeName, resultDataJson, TextType.RESULT_SET);
				return;
			}
		}

		emit(nodeName, textResult, TextType.TEXT);
	}

	private boolean isDatasourceTool(String toolName) {
		return toolName != null && toolName.startsWith("datasource.");
	}

	/**
	 * Converts a DatasourceExplorerResult JSON string into the frontend-expected
	 * {@code ResultData} format with {@code resultSet} and {@code displayStyle}.
	 * <p>
	 * Input: {@code {"rows":[{...}], "columns":[{"name":"col1"},...]}}
	 * Output: {@code {"resultSet":{"column":["col1"],"data":[...]},"displayStyle":{"type":"table",...}}}
	 */
	private String convertDatasourceResultToResultData(String jsonResult) {
		try {
			JsonNode root = objectMapper.readTree(jsonResult);

			JsonNode rowsNode = root.get("rows");
			JsonNode columnsNode = root.get("columns");

			if (rowsNode == null || !rowsNode.isArray() || rowsNode.isEmpty()) {
				return null;
			}
			if (columnsNode == null || !columnsNode.isArray()) {
				return null;
			}

			List<String> columnNames = new ArrayList<>();
			for (JsonNode col : columnsNode) {
				JsonNode nameNode = col.get("name");
				if (nameNode != null && !nameNode.isNull()) {
					columnNames.add(nameNode.asText());
				}
			}

			if (columnNames.isEmpty()) {
				return null;
			}

			List<Map<String, String>> data = new ArrayList<>();
			for (JsonNode row : rowsNode) {
				Map<String, String> rowMap = new LinkedHashMap<>();
				for (String col : columnNames) {
					JsonNode val = row.get(col);
					rowMap.put(col, val != null && !val.isNull() ? val.asText() : "");
				}
				data.add(rowMap);
			}

			Map<String, Object> resultData = new LinkedHashMap<>();
			Map<String, Object> resultSet = new LinkedHashMap<>();
			resultSet.put("column", columnNames);
			resultSet.put("data", data);

			Map<String, Object> displayStyle = new LinkedHashMap<>();
			displayStyle.put("type", "table");
			displayStyle.put("title", "查询结果");
			displayStyle.put("x", "");
			displayStyle.put("y", new ArrayList<>());

			resultData.put("resultSet", resultSet);
			resultData.put("displayStyle", displayStyle);

			return objectMapper.writeValueAsString(resultData);
		}
		catch (Exception e) {
			log.warn("Failed to convert datasource result to ResultData format: {}", e.getMessage());
			return null;
		}
	}

	private void emit(String nodeName, String text, TextType textType) {
		if (text == null || text.isBlank()) {
			return;
		}
		eventPublisher.publish(AgentResponse.builder()
			.agentId(agentId)
			.threadId(threadId)
			.nodeName(nodeName)
			.textType(textType)
			.text(text)
			.build());
	}

	private String resolveToolNodeName(String toolName) {
		return toolName == null || toolName.isBlank() ? "AgentScopeTool" : "tool:" + toolName;
	}

	private String extractToolResultText(ToolResultBlock toolResultBlock) {
		if (toolResultBlock == null) {
			return "";
		}
		List<ContentBlock> output = toolResultBlock.getOutput();
		if (output == null || output.isEmpty()) {
			return "";
		}
		return output.stream()
			.filter(TextBlock.class::isInstance)
			.map(TextBlock.class::cast)
			.map(TextBlock::getText)
			.filter(text -> text != null && !text.isBlank())
			.collect(Collectors.joining(System.lineSeparator()));
	}

}
