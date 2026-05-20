# BACKEND: data-agent-management

**Stack**: Spring Boot 3.4.8+ / Java 17+ / Spring AI Alibaba Graph / MyBatis / JPA / MySQL + H2 / Maven

## PACKAGES

```
com.alibaba.cloud.ai.dataagent/
├── DataAgentApplication.java   # Entry point
├── config/                     # Spring config (5 files: WebConfig, MCP, OpenAPI, OTEL, DataAgentConfig)
├── controller/                 # REST endpoints (15 files)
├── service/                    # Business logic (18 subpackages)
├── workflow/                   # StateGraph orchestration
│   ├── node/                   # 16 workflow nodes
│   └── dispatcher/             # 11 node dispatchers
├── connector/                  # DB connectivity (MySQL, PG, Oracle, H2, Hive, SQLServer, Dameng)
├── mapper/                     # MyBatis data access
├── entity/                     # JPA entities
├── dto/                        # Data transfer objects
├── bo/                         # Business objects
├── vo/                         # View objects
├── enums/                      # Enumerations (10 files)
├── constant/                   # Constants
├── exception/                  # Exception hierarchy
├── util/                       # Utilities
├── converter/                  # Type converters
├── splitter/                   # Text splitter strategies
├── strategy/                   # Strategy pattern implementations
├── event/                      # Application events
├── properties/                 # @ConfigurationProperties
├── annotation/                 # Custom annotations
├── aop/                        # AOP aspects
└── prompt/                     # LLM prompt templates
```

## WORKFLOW (StateGraph)
16 nodes chained: IntentRecognition → EvidenceRecall → QueryEnhance → SchemaRecall + TableRelation → FeasibilityAssessment → Planner → [HumanFeedback] → PlanExecutor (iterates SQL/Python steps) → ReportGenerator

11 dispatchers handle node-specific orchestration logic.

## KEY SERVICES
| Service | Path | Role |
|---------|------|------|
| GraphServiceImpl | `service/graph/` | Main StateGraph orchestration via SSE |
| LlmService | `service/llm/` | LLM stream/block abstraction |
| AiModelRegistry | `service/aimodelconfig/` | Runtime model hot-swapping |
| AgentVectorStoreService | `service/vectorstore/` | Hybrid vector retrieval |
| CodePoolExecutorService | `service/code/` | Python execution (Docker/Local/AI-sim) |
| McpServerService | `service/mcp/` | MCP protocol server |
| LangfuseService | `service/langfuse/` | Observability |
| MultiTurnContextManager | `service/chat/` | Conversation history |

## CONVENTIONS
- Standard layered architecture: Controller → Service → Mapper/Repository
- Constructor injection (no field injection)
- State graph: Node (logic) + Dispatcher (orchestration) separation
- Config prefix: `spring.ai.alibaba.data-agent.*`
- Profiles: `application.yml` (MySQL/prod), `application-h2.yml` (H2/dev)
- Test pattern: JUnit 5 + Mockito + Testcontainers (mysql:8.0)
- Mockito extensions configured in test resources

## CONTROLLERS
| Controller | Path prefix | Purpose |
|------------|-------------|---------|
| GraphController | `/api/graph/` | SSE streaming analysis |
| AgentController | `/api/agent/` | Agent CRUD + API keys |
| ModelConfigController | `/api/model-config/` | LLM/Embedding config |
| PromptConfigController | `/api/prompt-config/` | Custom prompt templates |
| ChatController | `/api/chat/` | Chat interactions |
| DatasourceController | `/api/datasource/` | Data source management |
| + 9 more controllers | | |

## NOTES
- 453 production Java files, 156 test Java files
- OpenAI-compatible API for all LLM/embedding models
- Default vector store: SimpleVectorStore (in-memory). Extensible via spring-ai-starter-vector-store-*
- Native MCP protocol support (auto-discovery via spring-ai-starter-mcp-server-webflux)
