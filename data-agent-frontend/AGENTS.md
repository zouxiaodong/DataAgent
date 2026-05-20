# FRONTEND: data-agent-frontend

**Stack**: Vue 3 / Vite / Vue Router / Axios / ECharts / marked + highlight.js

## STRUCTURE
```
src/
├── main.js                    # Vue app entry point
├── App.vue                    #  component
├── views/                     # Page-level components (6 files)
│   ├── AgentList.vue
│   ├── AgentCreate.vue
│   ├── AgentDetail.vue
│   ├── AgentRun.vue
│   ├── ModelConfig.vue
│   └── NotFound.vue
├── components/                # Reusable components
│   ├── agent/                 # Agent config components (9 files)
│   └── run/                   # Run session components (8 files)
│       ├── charts/            # ECharts wrappers (Bar, Line, Pie, Base, Factory)
│       └── markdown/          # Markdown renderer with ECharts plugin
├── services/                  # API service layer (15 files)
├── router/                    # Vue Router config (index.js + routes.js)
├── layouts/                   # Layout components
│   └── BaseLayout.vue
└── styles/                    # Global styles
    └── global.css
```

## KEY FILES
| File | Purpose |
|------|---------|
| `views/AgentRun.vue` | Main analysis run interface |
| `views/AgentList.vue` | Agent management list |
| `views/AgentCreate.vue` | Agent creation wizard |
| `services/graph.ts` | SSE graph streaming client |
| `services/sessionStateManager.ts` | Multi-turn session state |
| `services/chat.ts` | Chat API bindings |
| `services/agent.ts` | Agent CRUD API bindings |
| `components/run/charts/ChartFactory.ts` | ECharts factory pattern |
| `components/run/markdown/markdown-plugin-echarts.ts` | ECharts in markdown |
| `components/agent/*.vue` | Agent config panels (datasource, knowledge, prompts, etc.) |

## CONVENTIONS
- Composition API with `<script setup>` syntax
- Scoped CSS in Vue SFCs
- Axios for HTTP, SSE via EventSource
- ECharts for chart rendering (Bar, Line, Pie)
- Markdown rendered via `marked` with custom ECharts plugin
- Router: Hash mode with lazy-loaded routes

## SERVICES LAYER
15 API service modules in `src/services/`, each wrapping a backend API:
`agent.ts`, `chat.ts`, `graph.ts`, `datasource.ts`, `modelConfig.ts`, `fileUpload.ts`, `agentKnowledge.ts`, `businessKnowledge.ts`, `semanticModel.ts`, `presetQuestion.ts`, `resultSet.ts`, `sessionStateManager.ts`, `logicalRelation.ts`, `agentDatasource.ts`, `common.ts`

## NOTES
- Dev server: port 3000, proxies to backend at port 8065
- Type checking via `npm run type-check` (vue-tsc)
- Linting: ESLint with `.eslintrc.js`
