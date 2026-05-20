# UI Rebrand Design Spec — 玻璃拟态深色沉浸式

**Date**: 2026-05-20
**Status**: Approved (v3 — final)
**Scope**: Full frontend rebrand — layout, style, color, all pages + sub-components

## Design Decisions

| Dimension | Choice |
|---|---|
| Overall Style | Dark Glassmorphism — dark background + semi-transparent dark glass cards + glowing accents |
| Layout Mode | Borderless Immersive — no traditional navbar, each page independently designed |
| Homepage | Agent Showcase — large card grid, app-store-like layout |
| Run Page | Left History + Right Chat — session history sidebar (280px) + conversation area |
| Color Scheme | Dark background + semi-transparent dark glass cards + glowing accent colors |

## Architecture

### 1. Global Design System (`global.css`)

```css
:root {
  --bg-primary: #0f172a;
  --bg-secondary: #1e293b;
  --bg-tertiary: #334155;
  --bg-layout: #020617;

  --bg-glass: rgba(30, 41, 59, 0.85);
  --bg-glass-hover: rgba(51, 65, 85, 0.9);
  --border-glass: rgba(148, 163, 184, 0.15);
  --border-glass-hover: rgba(148, 163, 184, 0.3);
  --shadow-glass: 0 8px 32px rgba(0, 0, 0, 0.4);
  --backdrop-blur: blur(12px);

  --accent-color: #60a5fa;
  --accent-hover: #3b82f6;
  --accent-light: rgba(96, 165, 250, 0.15);
  --accent-glow: rgba(96, 165, 250, 0.4);
  --highlight-color: #fbbf24;
  --highlight-hover: #f59e0b;

  --success-color: #34d399;
  --success-light: rgba(52, 211, 153, 0.15);
  --warning-color: #fbbf24;
  --warning-light: rgba(251, 191, 36, 0.15);
  --error-color: #f87171;
  --error-light: rgba(248, 113, 113, 0.15);
  --info-color: #60a5fa;
  --info-light: rgba(96, 165, 250, 0.15);

  --text-primary: #f1f5f9;
  --text-secondary: #cbd5e1;
  --text-tertiary: #94a3b8;
  --text-disabled: #64748b;

  --gradient-bg: linear-gradient(135deg, #020617 0%, #0f172a 30%, #1e1b4b 60%, #0f172a 100%);

  --glow-sm: 0 0 0 1px rgba(96, 165, 250, 0.2);
  --glow-md: 0 0 0 1px rgba(96, 165, 250, 0.3), 0 0 12px rgba(96, 165, 250, 0.15);
  --glow-lg: 0 0 0 2px rgba(96, 165, 250, 0.4), 0 0 24px rgba(96, 165, 250, 0.2);

  --font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', sans-serif;
  --radius-sm: 8px; --radius-md: 12px; --radius-lg: 16px; --radius-xl: 20px; --radius-pill: 999px;
  --transition-base: 0.2s ease;
}

@supports not ((backdrop-filter: blur(12px)) or (-webkit-backdrop-filter: blur(12px))) {
  :root { --bg-glass: rgba(30, 41, 59, 0.95); --bg-glass-hover: rgba(51, 65, 85, 0.95); }
}
```

### 2. Element Plus Dark Overrides

**No external import** — manually override critical EP variables in `global.css`:

```css
:root {
  --el-bg-color: var(--bg-glass);
  --el-bg-color-page: var(--bg-primary);
  --el-bg-color-overlay: var(--bg-secondary);
  --el-text-color-primary: var(--text-primary);
  --el-text-color-regular: var(--text-secondary);
  --el-text-color-placeholder: var(--text-tertiary);
  --el-text-color-disabled: var(--text-disabled);
  --el-border-color: var(--border-glass);
  --el-border-color-light: var(--border-glass);
  --el-border-color-lighter: rgba(148, 163, 184, 0.08);
  --el-border-color-extra-light: rgba(148, 163, 184, 0.05);
  --el-fill-color: var(--bg-glass);
  --el-fill-color-light: rgba(30, 41, 59, 0.5);
  --el-fill-color-lighter: rgba(30, 41, 59, 0.3);
  --el-fill-color-blank: transparent;
  --el-fill-color-extra-light: rgba(30, 41, 59, 0.2);
  --el-mask-color: rgba(0, 0, 0, 0.5);
  --el-mask-color-extra-light: rgba(0, 0, 0, 0.3);
  --el-box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
  --el-box-shadow-light: 0 4px 16px rgba(0, 0, 0, 0.3);
  --el-disabled-bg-color: var(--bg-tertiary);
  --el-disabled-border-color: var(--border-glass);
}
```

### 3. Layout Structure

**No global navbar.** Each page is self-contained.

- **Homepage** (`/agents`): Full-page card grid with `--gradient-bg`
- **Run Page** (`/agent/:id/run`): Left sidebar (`width: 280px`) + right chat
- **Create/Edit** (`/agent/create`, `/agent/:id`): Centered glass card, `max-width: 800px`
- **Config** (`/model-config`): Full-width glass table

### 4. Pages to Redesign

| Page | Change |
|---|---|
| `AgentList.vue` | Remove BaseLayout wrapper, full-page card grid, `--gradient-bg` |
| `AgentRun.vue` | Remove BaseLayout, left sidebar (280px) + right chat |
| `AgentCreate.vue` | Remove BaseLayout, centered glass card form |
| `AgentDetail.vue` | Remove BaseLayout, keep el-menu + content layout, restyle as glass |
| `ModelConfig.vue` | Remove BaseLayout, full-width glass table |
| `BaseLayout.vue` | Simplify to `<div class="page-wrapper"><slot /></div>` |
| `NotFound.vue` | Adapt to dark theme |

### 5. Template Changes Required

| File | Line | Change |
|---|---|---|
| `AgentRun.vue` | 39 | `style="background-color: white"` → remove (inherit from parent) |
| `AgentRun.vue` | 1707 | `rgba(255,255,255,0.9)` on `.input-area` → `var(--bg-glass)` |
| `AgentDetail.vue` | 21 | `style="background-color: white"` on el-header → remove |
| `AgentDetail.vue` | 68 | `style="background-color: white"` on el-aside → remove |
| `AgentDetail.vue` | 124 | `style="background-color: white"` on el-main → remove |
| `AgentRun.vue` | 373 | `highlight.js/styles/github.css` → `highlight.js/styles/github-dark.css` |

### 6. v-html Content Strategy

`.html-rendered-content` (global.css L1436-1548) has 14 `!important` light-color overrides. **Resolution:**

1. Replace all `!important` hardcoded colors with CSS variables in `global.css`
2. For `generateNodeHtml()` inline styles (AgentRun.vue L1024), update the JS to use CSS variable-friendly class names instead of inline colors
3. Add a `.dark-report` wrapper class that inverts colors via CSS `filter` as fallback:
```css
.html-rendered-content { filter: invert(0.9) hue-rotate(180deg); }
.html-rendered-content img,
.html-rendered-content .echarts-container { filter: invert(1) hue-rotate(-180deg); }
```

### 7. ECharts Dark Theme

Update `ChartFactory.ts` default colors:

```ts
const darkTheme = {
  backgroundColor: 'transparent',
  textStyle: { color: '#cbd5e1' },
  title: { textStyle: { color: '#f1f5f9' } },
  legend: { textStyle: { color: '#cbd5e1' } },
  xAxis: { axisLine: { lineStyle: { color: '#334155' } }, axisLabel: { color: '#94a3b8' } },
  yAxis: { axisLine: { lineStyle: { color: '#334155' } }, axisLabel: { color: '#94a3b8' } },
  tooltip: { backgroundColor: 'rgba(30, 41, 59, 0.9)', borderColor: '#334155', textStyle: { color: '#f1f5f9' } },
  color: ['#60a5fa', '#fbbf24', '#34d399', '#f87171', '#a78bfa', '#fb923c'],
};
```

### 8. Sub-Components by Effort

| Effort | Components |
|---|---|
| **Low** (inherit global vars) | `BaseSetting.vue`, `AccessApi.vue`, `PresetsConfig.vue`, `SemanticsConfig.vue` |
| **Medium** (EP overrides) | `DataSourceConfig.vue`, `PromptConfig.vue`, `BusinessKnowledgeConfig.vue`, `AgentKnowledgeConfig.vue`, `ChatSessionSidebar.vue` |
| **High** (custom dark) | `HumanFeedback.vue`, `PresetQuestions.vue`, `ResultSetDisplay.vue`, `ReportHtmlView.vue`, `MarkdownAgentContainer.vue` |
| **Critical** (ECharts) | `ChartFactory.ts`, `ChartComponent.vue` |

### 9. Conflicts to Resolve

| Conflict | Resolution |
|---|---|
| `prefers-color-scheme: dark` media query (L1324-1338) | **Remove** — app is permanently dark |
| `--primary-color` used as text color in 7 files | Replace with `var(--text-primary)` |
| Dead `.btn` block (L182-200) | **Remove** |
| Scrollbar colors | Update to `--bg-tertiary` thumb, `--bg-layout` track |
| `<meta name="theme-color">` | Update to `#0f172a` in `index.html` |
| `.btn-success/.btn-warning/.btn-danger` text color | Change from `color: var(--bg-primary)` to `color: #fff` |

### 10. Implementation Order

1. Update `global.css` — variables, EP overrides, remove old dark media query, fix scrollbars, remove dead `.btn` block
2. Update `main.js` — remove old EP CSS import, add EP variable overrides
3. Simplify `BaseLayout.vue` — remove navbar
4. Update all 6 view pages — remove BaseLayout wrapper, apply new styles
5. Fix inline template styles (AgentRun.vue, AgentDetail.vue)
6. Update all 17 sub-components
7. Update ECharts colors in `ChartFactory.ts`
8. Fix `.html-rendered-content` and `generateNodeHtml()`
9. Switch highlight.js to `github-dark` theme
10. Update `index.html` meta theme-color

### 11. Constraints

- CSS, template, and import changes only — no service layer changes
- No new npm dependencies
- WCAG AA — all text/bg ≥ 4.5:1
- Respect `prefers-reduced-motion` — disable glow animations
- Firefox fallback for `backdrop-filter`
