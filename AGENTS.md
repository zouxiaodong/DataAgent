# PROJECT KNOWLEDGE BASE

**Generated:** 2026-05-20
**Branch:** main

## OVERVIEW
DataAgent - Enterprise intelligent data analysis agent built on Spring AI Alibaba Graph. Text-to-SQL, Python deep analysis, multi-dimensional chart reports, and intelligent report generation.

**Stack**: Spring Boot 3.4.8+ / Java 17+ / Spring AI Alibaba / Vue 3 + Vite / ECharts / MySQL + H2

## STRUCTURE
```
├── data-agent-management/    # Spring Boot backend (port 8065)
├── data-agent-frontend/      # Vue 3 frontend (port 3000)
├── docs/                     # Documentation (10+ files)
├── docker-file/              # Docker Compose for datasource services
├── CI/                       # Build tooling (makefiles, linters)
├── .github/workflows/        # CI/CD (7 workflows)
├── pom.xml                   #  Maven parent POM
├── Makefile                  # Convenience build commands
└── img/                      # Project images/logos
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Backend entry | `data-agent-management/.../DataAgentApplication.java` | @SpringBootApplication |
| Graph orchestration | `.../service/graph/GraphServiceImpl.java` | SSE streaming via StateGraph |
| Workflow nodes | `.../workflow/node/` | 16 node classes (IntentRecognition → ReportGenerator) |
| Dispatchers | `.../workflow/dispatcher/` | 11 dispatcher classes |
| REST controllers | `.../controller/` | 15 controllers |
| Services | `.../service/` | 18 service subpackages |
| DB connectors | `.../connector/` | Multi-DB support (MySQL, PG, Oracle, H2, Hive, etc.) |
| Python executor | `.../service/code/` | Docker/Local/AI-sim Python execution |
| LLM abstraction | `.../service/llm/` | Stream/block modes, OpenAI-compatible |
| Model registry | `.../service/aimodelconfig/AiModelRegistry.java` | Dynamic hot-swapping |
| Vector store | `.../service/vectorstore/` | RAG with hybrid retrieval |
| MCP server | `.../service/mcp/` | NL2SQL + listAgents tools |
| Frontend entry | `data-agent-frontend/src/main.js` | Vue 3 app bootstrap |
| Frontend views | `data-agent-frontend/src/views/` | 6 page views (AgentList, AgentRun, etc.) |
| Frontend services | `data-agent-frontend/src/services/` | 15 API service modules |
| Frontend components | `data-agent-frontend/src/components/` | agent config + run components |
| Charts | `.../components/run/charts/` | ECharts (Bar, Line, Pie, Base, Factory) |
| Routes | `data-agent-frontend/src/router/` | Vue Router config |
| DB schema | `data-agent-management/src/main/resources/sql/schema.sql` | MySQL schema |

## CONVENTIONS
- **Backend**: Standard Spring Boot layered architecture (controller → service → mapper → entity)
- **Workflow**: StateGraph pattern with Node + Dispatcher separation
- **Frontend**: Vue 3 Composition API (`<script setup>`)
- **Database**: JPA entities + MyBatis mappers for persistence
- **Config prefix**: `spring.ai.alibaba.data-agent`
- **Profiles**: `application.yml` (MySQL/prod), `application-h2.yml` (H2/dev)
- **Code style**: Spring Java Format + Checkstyle
- **API**: RESTful JSON; SSE for streaming graph responses

## ANTI-PATTERNS
- No `@SuppressWarnings` or `@Deprecated` annotations found
- No type suppression patterns observed
- Avoid direct field injection; use constructor injection

## COMMANDS
```bash
# Backend
make build                       # Build (skip tests)
make test                        # Run tests
cd data-agent-management && ./mvnw spring-boot:run -Dspring-boot.run.profiles=h2  # Dev server

# Frontend
cd data-agent-frontend && npm install && npm run dev   # Dev server
cd data-agent-frontend && npm run build                # Production build

# DB
mysql -u  -p < data-agent-management/src/main/resources/sql/schema.sql  # MySQL setup
```

## NOTES
- 631 total files, ~77K lines of code (453 Java, 156 Java test, 24 Vue, 24 TS)
- 16 workflow nodes, 11 dispatchers operating on StateGraph
- Supports multi-turn conversation via `MultiTurnContextManager`
- Human-in-the-loop: workflow pauses at HumanFeedbackNode, resumes with threadId
- Observability via Langfuse (disabled by default)
