# SERVICE LAYER: service/

18 service subpackages implementing the core business logic behind the StateGraph workflow.

## SERVICE INDEX

| Package | Key Classes | Purpose |
|---------|-------------|---------|
| `graph/` | GraphService, GraphServiceImpl | StateGraph orchestration with SSE streaming |
| `llm/` | LlmService | LLM stream/block abstraction, ChatClient wrapping |
| `aimodelconfig/` | AiModelRegistry | Runtime model hot-swapping (chat + embedding) |
| `vectorstore/` | AgentVectorStoreService | Hybrid vector retrieval with multiple strategies |
| `code/` | CodePoolExecutorService, CodePoolExecutorServiceFactory | Python execution (Docker/Local/AI-sim modes) |
| `mcp/` | McpServerService | MCP protocol server (NL2SQL + listAgents tools) |
| `chat/` | MultiTurnContextManager | Conversation history management |
| `agent/` | AgentService | Agent CRUD, API key lifecycle |
| `datasource/` | Datasource handlers | Multi-DB connection management |
| `knowledge/` | KnowledgeService | Business + agent knowledge CRUD |
| `nl2sql/` | Nl2SqlService | Text-to-SQL generation |
| `schema/` | SchemaService | Database schema recall |
| `semantic/` | SemanticService | SQL semantic consistency checking |
| `prompt/` | PromptService | Custom prompt template management |
| `business/` | BusinessService | Business metadata management |
| `file/` | FileStorageService | File upload (local/OSS) |
| `hybrid/` | Hybrid retrieval | Multi-strategy retrieval with fusion |
| `langfuse/` | LangfuseService | Observability integration |

## CONVENTIONS
- Interface + Impl pattern (e.g., GraphService / GraphServiceImpl)
- Services injectable via constructor injection
- Service methods throw typed exceptions from `exception/` package
- Code executor: factory pattern for Docker/Local/AI-sim strategies
- Datasource: handler chain pattern for different DB types
- Hybrid retrieval: strategy + factory + fusion pattern

## DEPENDENCY FLOW
```
Controller → GraphService (orchestrator)
  → LlmService (LLM calls)
  → AgentVectorStoreService (RAG)
  → CodePoolExecutorService (Python)
  → Datasource handlers (SQL execution)
  → McpServerService (external tools)
  → LangfuseService (tracing)
```

## NOTES
- Most complex package: `graph/` (StateGraph orchestration with SSE streaming)
- Most extensible: `code/impls/` (add new Python executor implementations)
- Most configurable: `aimodelconfig/` (dynamic model switching at runtime)
