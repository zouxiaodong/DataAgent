# Dark Glassmorphism Rebrand Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform DataAgent frontend from light "清爽现代" to "玻璃拟态深色沉浸式" (Dark Glassmorphism Immersive) with borderless layout, dark glass cards, and glowing accents.

**Design Spec:** `docs/superpowers/specs/2026-05-20-ui-rebrand-glassmorphism-design.md` (v3 Approved)

**Architecture:** CSS, template, and import changes only — no service/logic layer changes. No new npm dependencies.

**Tech Stack:** Vue 3 Composition API, Element Plus 2.x, CSS custom properties, ECharts, highlight.js

**Constraints:**
- WCAG AA — all text/bg contrast ≥ 4.5:1
- Respect `prefers-reduced-motion` — disable glow animations
- Firefox fallback for `backdrop-filter`
- App is permanently dark (no `prefers-color-scheme` toggle)

---

### Task 1: Rewrite `global.css` — Dark Variables, EP Overrides, Cleanup

**Files:**
- Modify: `data-agent-frontend/src/styles/global.css`

- [ ] **Step 1: Replace `:root` CSS variables (lines 18-134)**

Replace the entire `:root { ... }` block with the dark glassmorphism variable system:

```css
:root {
  /* Background layers */
  --bg-primary: #0f172a;
  --bg-secondary: #1e293b;
  --bg-tertiary: #334155;
  --bg-layout: #020617;

  /* Glass materials */
  --bg-glass: rgba(30, 41, 59, 0.85);
  --bg-glass-hover: rgba(51, 65, 85, 0.9);
  --border-glass: rgba(148, 163, 184, 0.15);
  --border-glass-hover: rgba(148, 163, 184, 0.3);
  --shadow-glass: 0 8px 32px rgba(0, 0, 0, 0.4);
  --backdrop-blur: blur(12px);

  /* Accent colors — lightened for WCAG AA on dark */
  --accent-color: #60a5fa;
  --accent-hover: #3b82f6;
  --accent-light: rgba(96, 165, 250, 0.15);
  --accent-glow: rgba(96, 165, 250, 0.4);
  --highlight-color: #fbbf24;
  --highlight-hover: #f59e0b;

  /* Semantic colors */
  --success-color: #34d399;
  --success-light: rgba(52, 211, 153, 0.15);
  --warning-color: #fbbf24;
  --warning-light: rgba(251, 191, 36, 0.15);
  --error-color: #f87171;
  --error-light: rgba(248, 113, 113, 0.15);
  --info-color: #60a5fa;
  --info-light: rgba(96, 165, 250, 0.15);

  /* Text colors — light on dark */
  --text-primary: #f1f5f9;
  --text-secondary: #cbd5e1;
  --text-tertiary: #94a3b8;
  --text-disabled: #64748b;

  /* Gradient background */
  --gradient-bg: linear-gradient(135deg, #020617 0%, #0f172a 30%, #1e1b4b 60%, #0f172a 100%);

  /* Glow effects */
  --glow-sm: 0 0 0 1px rgba(96, 165, 250, 0.2);
  --glow-md: 0 0 0 1px rgba(96, 165, 250, 0.3), 0 0 12px rgba(96, 165, 250, 0.15);
  --glow-lg: 0 0 0 2px rgba(96, 165, 250, 0.4), 0 0 24px rgba(96, 165, 250, 0.2);

  /* Font system (keep existing) */
  --font-family:
    -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Hiragino Sans GB',
    'Microsoft YaHei', 'Helvetica Neue', Helvetica, Arial, sans-serif;
  --font-family-mono:
    'SF Mono', Monaco, Inconsolata, 'Roboto Mono', 'Source Code Pro', Menlo, Consolas,
    'Ubuntu Mono', monospace;

  /* Font sizes (keep existing) */
  --font-size-xs: 12px;
  --font-size-sm: 14px;
  --font-size-base: 16px;
  --font-size-lg: 18px;
  --font-size-xl: 20px;
  --font-size-2xl: 24px;
  --font-size-3xl: 30px;
  --font-size-4xl: 36px;

  /* Font weights (keep existing) */
  --font-weight-light: 300;
  --font-weight-normal: 400;
  --font-weight-medium: 500;
  --font-weight-semibold: 600;
  --font-weight-bold: 700;

  /* Spacing (keep existing) */
  --space-xs: 4px;
  --space-sm: 8px;
  --space-base: 12px;
  --space-md: 16px;
  --space-lg: 20px;
  --space-xl: 24px;
  --space-2xl: 32px;
  --space-3xl: 48px;
  --space-4xl: 64px;

  /* Radius (keep existing) */
  --radius-xs: 4px;
  --radius-sm: 8px;
  --radius-base: 10px;
  --radius-md: 12px;
  --radius-lg: 16px;
  --radius-xl: 20px;
  --radius-2xl: 24px;
  --radius-pill: 999px;
  --radius-full: 50%;
  --radius: 10px;

  /* Shadows — dark theme */
  --shadow-xs: 0 1px 2px rgba(0, 0, 0, 0.2);
  --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.3), 0 1px 2px rgba(0, 0, 0, 0.2);
  --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.3), 0 2px 4px rgba(0, 0, 0, 0.2);
  --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.4), 0 4px 6px rgba(0, 0, 0, 0.3);
  --shadow-xl: 0 20px 25px rgba(0, 0, 0, 0.5), 0 8px 10px rgba(0, 0, 0, 0.3);

  /* Transitions (keep existing) */
  --transition-fast: 0.15s cubic-bezier(0.4, 0, 0.2, 1);
  --transition-base: 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  --transition-slow: 0.5s cubic-bezier(0.4, 0, 0.2, 1);

  /* Z-index (keep existing) */
  --z-dropdown: 1000;
  --z-sticky: 1020;
  --z-fixed: 1030;
  --z-modal-backdrop: 1040;
  --z-modal: 1050;
  --z-popover: 1060;
  --z-tooltip: 1070;
}
```

- [ ] **Step 2: Add `@supports` fallback for Firefox `backdrop-filter`**

Add immediately after `:root` block:

```css
@supports not ((backdrop-filter: blur(12px)) or (-webkit-backdrop-filter: blur(12px))) {
  :root {
    --bg-glass: rgba(30, 41, 59, 0.95);
    --bg-glass-hover: rgba(51, 65, 85, 0.95);
  }
}
```

- [ ] **Step 3: Add Element Plus dark variable overrides**

Add after the `@supports` block:

```css
/* Element Plus Dark Overrides */
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

- [ ] **Step 4: Update scrollbar colors (lines 160-179)**

Replace scrollbar rules:

```css
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}

::-webkit-scrollbar-track {
  background: var(--bg-layout);
  border-radius: var(--radius-sm);
}

::-webkit-scrollbar-thumb {
  background: var(--bg-tertiary);
  border-radius: var(--radius-sm);
  transition: background-color var(--transition-base);
}

::-webkit-scrollbar-thumb:hover {
  background: var(--text-disabled);
}
```

- [ ] **Step 5: Remove duplicate `.btn` block (lines 182-200)**

Delete the first `.btn` block (lines 182-200). Keep the second one (lines 495+) but update it for dark theme.

- [ ] **Step 6: Update `.btn` styles for dark theme**

In the second `.btn` block (starting ~line 495), update:
- `.btn:focus` → `box-shadow: var(--glow-sm);`
- `.btn-secondary` → `background: var(--bg-glass); color: var(--text-secondary); border-color: var(--border-glass);`
- `.btn-success` → `color: #fff;` (not `var(--bg-primary)`)
- `.btn-warning` → `color: #fff;`
- `.btn-danger` → `color: #fff;`
- `.btn-outline` → `color: var(--accent-color); border-color: var(--accent-color);`
- `.btn-outline:hover` → `background: var(--accent-color); color: #fff;`
- `.btn-text` → `color: var(--accent-color);`
- `.btn-text:hover` → `background: var(--accent-light);`

- [ ] **Step 7: Update `.form-control` styles for dark theme**

- `.form-control` → `background-color: var(--bg-glass); border-color: var(--border-glass); color: var(--text-primary);`
- `.form-control:focus` → `border-color: var(--accent-color); box-shadow: var(--glow-sm);`
- `.form-control:disabled` → `background-color: var(--bg-tertiary); color: var(--text-disabled);`

- [ ] **Step 8: Update `.card` styles for dark glass**

Replace `.card` rules:

```css
.card {
  background: var(--bg-glass);
  backdrop-filter: var(--backdrop-blur);
  -webkit-backdrop-filter: var(--backdrop-blur);
  border: 1px solid var(--border-glass);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-glass);
  overflow: hidden;
  transition: all var(--transition-base);
}

.card:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-4px);
  border-color: var(--border-glass-hover);
}
```

- [ ] **Step 9: Update `.card-header`, `.card-body`, `.card-footer`**

- `.card-header` → `background: rgba(15, 23, 42, 0.5); border-bottom: 1px solid var(--border-glass);`
- `.card-title` → `color: var(--text-primary);`
- `.card-subtitle` → `color: var(--text-secondary);`
- `.card-text` → `color: var(--text-secondary);`
- `.card-footer` → `background: rgba(15, 23, 42, 0.3); border-top: 1px solid var(--border-glass);`

- [ ] **Step 10: Update `.badge` and `.status-badge` styles**

- `.badge-primary` → `background: var(--accent-light); color: var(--accent-color);`
- `.badge-secondary` → `background: var(--bg-tertiary); color: var(--text-secondary);`
- `.status-badge.active` / `.status-badge.published` → `background: var(--success-light); color: var(--success-color); border-color: rgba(52, 211, 153, 0.2);`
- `.status-badge.draft` → `background: var(--warning-light); color: var(--warning-color);`
- `.status-badge.inactive` → `background: var(--error-light); color: var(--error-color);`
- `.status-badge.offline` → `background: var(--bg-tertiary); color: var(--text-tertiary); border-color: var(--border-glass);`

- [ ] **Step 11: Update `.table` styles**

- `.table` → `background: var(--bg-glass);`
- `.table th` → `background: rgba(15, 23, 42, 0.5); color: var(--text-primary); border-bottom: 1px solid var(--border-glass);`
- `.table td` → `color: var(--text-secondary); border-bottom: 1px solid var(--border-glass);`
- `.table tbody tr:hover` → `background: var(--bg-glass-hover);`

- [ ] **Step 12: Update `.message-toast` styles**

- `.message-toast.success` → `background: var(--success-light); border-color: rgba(52, 211, 153, 0.2); color: var(--success-color);`
- `.message-toast.warning` → `background: var(--warning-light); border-color: rgba(251, 191, 36, 0.2); color: var(--warning-color);`
- `.message-toast.error` → `background: var(--error-light); border-color: rgba(248, 113, 113, 0.2); color: var(--error-color);`
- `.message-toast.info` → `background: var(--info-light); border-color: rgba(96, 165, 250, 0.2); color: var(--info-color);`

- [ ] **Step 13: Update `.spinner`**

- `.spinner` → `border-color: var(--bg-tertiary); border-top-color: var(--accent-color);`

- [ ] **Step 14: Update `.tooltip` styles**

- `.tooltip::before` → `background: var(--bg-secondary); color: var(--text-primary); border: 1px solid var(--border-glass);`
- `.tooltip::after` → `border-top-color: var(--bg-secondary);`

- [ ] **Step 15: Remove `@media (prefers-color-scheme: dark)` block (lines 1324-1338)**

Delete entirely — app is permanently dark now.

- [ ] **Step 16: Fix `.html-rendered-content` for dark theme (lines 1436-1548)**

Replace the entire `.html-rendered-content` block with CSS variable-based dark styles:

```css
/* HTML rendered content — dark theme */
.html-rendered-content {
  background: var(--bg-glass) !important;
  border: 1px solid var(--border-glass) !important;
  border-radius: 8px !important;
  padding: 16px !important;
  margin: 8px 0 !important;
  max-width: 100% !important;
  overflow-x: auto !important;
  box-sizing: border-box !important;
  font-family:
    -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif !important;
  font-size: 14px !important;
  line-height: 1.6 !important;
  white-space: normal !important;
  word-wrap: normal !important;
  overflow-wrap: normal !important;
  word-break: normal !important;
  hyphens: none !important;
  color: var(--text-primary) !important;
}

.html-rendered-content * {
  max-width: 100% !important;
  box-sizing: border-box !important;
}

.html-rendered-content table {
  width: 100% !important;
  border-collapse: collapse !important;
  margin: 8px 0 !important;
}

.html-rendered-content th,
.html-rendered-content td {
  border: 1px solid var(--border-glass) !important;
  padding: 8px 12px !important;
  text-align: left !important;
  color: var(--text-primary) !important;
  font-family: inherit !important;
  font-size: 14px !important;
  line-height: 1.6 !important;
}

.html-rendered-content th {
  background-color: rgba(15, 23, 42, 0.5) !important;
  font-weight: 600 !important;
  color: var(--text-primary) !important;
}

.html-rendered-content h1,
.html-rendered-content h2,
.html-rendered-content h3,
.html-rendered-content h4,
.html-rendered-content h5,
.html-rendered-content h6 {
  margin: 16px 0 8px 0 !important;
  color: var(--text-primary) !important;
  font-weight: 600 !important;
  font-family: inherit !important;
}

.html-rendered-content h1 { font-size: 24px !important; margin: 24px 0 16px 0 !important; }
.html-rendered-content h2 { font-size: 20px !important; margin: 20px 0 12px 0 !important; }
.html-rendered-content h3 { font-size: 18px !important; margin: 16px 0 8px 0 !important; }

.html-rendered-content p {
  margin: 8px 0 !important;
  line-height: 1.6 !important;
  color: var(--text-secondary) !important;
  font-family: inherit !important;
  font-size: 14px !important;
}

.html-rendered-content ul,
.html-rendered-content ol {
  margin: 8px 0 !important;
  padding-left: 20px !important;
}

.html-rendered-content li {
  margin: 4px 0 !important;
  color: var(--text-secondary) !important;
  font-family: inherit !important;
  font-size: 14px !important;
  line-height: 1.6 !important;
}

.html-rendered-content pre {
  background: rgba(15, 23, 42, 0.5) !important;
  padding: 12px !important;
  border-radius: 4px !important;
  overflow-x: auto !important;
  margin: 8px 0 !important;
  white-space: pre-wrap !important;
  border: 1px solid var(--border-glass) !important;
}

.html-rendered-content code {
  background: rgba(15, 23, 42, 0.5) !important;
  padding: 2px 4px !important;
  border-radius: 3px !important;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace !important;
  font-size: 12px !important;
  color: var(--accent-color) !important;
}
```

- [ ] **Step 17: Update `.agent-response-*` styles for dark theme (lines 1340-1422)**

Replace conversation node styles:

```css
.agent-responses-container {
  display: flex;
  flex-direction: column;
  width: 100%;
  max-width: 100%;
  gap: 0.75rem;
  box-sizing: border-box;
}

.agent-response-block {
  display: block !important;
  width: 100% !important;
  max-width: 100% !important;
  border: 1px solid var(--border-glass) !important;
  border-radius: 8px;
  overflow: hidden;
  background: var(--bg-glass);
  box-sizing: border-box;
}

.agent-response-title {
  background: rgba(15, 23, 42, 0.5);
  padding: 8px 12px;
  font-weight: 600;
  font-size: 14px;
  color: var(--text-secondary);
  border-bottom: 1px solid var(--border-glass);
  display: flex;
  align-items: center;
  justify-content: flex-start;
  gap: 6px;
}

.agent-response-title i {
  font-size: 14px;
  color: var(--text-tertiary);
  flex-shrink: 0;
  margin-right: 2px;
}

.agent-response-content {
  padding: 12px;
  background: transparent;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 13px;
  line-height: 1.5;
  max-width: 100%;
  overflow-x: auto;
  box-sizing: border-box;
  white-space: pre-wrap;
  word-wrap: break-word;
  overflow-wrap: break-word;
  word-break: break-all;
  hyphens: auto;
  color: var(--text-primary);
}

.agent-response-content pre {
  margin: 0;
  padding: 12px;
  background: rgba(15, 23, 42, 0.5);
  border-radius: 4px;
  overflow-x: auto;
  border: 1px solid var(--border-glass);
  max-width: 100%;
  word-wrap: break-word;
  white-space: pre-wrap;
  box-sizing: border-box;
  color: var(--text-primary);
}

.agent-response-content code {
  background: rgba(15, 23, 42, 0.5);
  padding: 2px 4px;
  border-radius: 3px;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 12px;
  color: var(--accent-color);
}

.agent-response-content .language-sql {
  color: var(--accent-color);
}

.agent-response-content .language-json {
  color: var(--accent-color);
  white-space: pre-wrap !important;
  word-break: break-all;
  overflow-wrap: break-word;
}
```

- [ ] **Step 18: Add `prefers-reduced-motion` glow disable**

Update the existing `@media (prefers-reduced-motion: reduce)` block to also disable glow animations:

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }

  .btn::before {
    display: none;
  }

  /* Disable glow animations */
  .glass-card,
  .glass-panel,
  [class*="glow"] {
    box-shadow: none !important;
  }
}
```

- [ ] **Step 19: Add `.glass-card` utility class**

Add at the end of the file:

```css
/* Glass card utility */
.glass-card {
  background: var(--bg-glass);
  backdrop-filter: var(--backdrop-blur);
  -webkit-backdrop-filter: var(--backdrop-blur);
  border: 1px solid var(--border-glass);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-glass);
  transition: all var(--transition-base);
}

.glass-card:hover {
  background: var(--bg-glass-hover);
  border-color: var(--border-glass-hover);
  box-shadow: var(--shadow-lg);
  transform: translateY(-2px);
}

/* Gradient background utility */
.gradient-bg {
  background: var(--gradient-bg);
  min-height: 100vh;
}
```

---

### Task 2: Update `main.js` — Remove Old EP Import, Verify EP Overrides

**Files:**
- Modify: `data-agent-frontend/src/main.js`

- [ ] **Step 1: Read `main.js` and check for Element Plus CSS import**

If there's an import like `import 'element-plus/dist/index.css'` or `import 'element-plus/theme-chalk/src/index.scss'`, keep it — the EP variable overrides in `global.css` will cascade over it.

- [ ] **Step 2: Ensure `global.css` is imported AFTER Element Plus CSS**

Verify the import order:
```js
import 'element-plus/dist/index.css'  // if present
import './styles/global.css'           // must come after EP to override variables
```

---

### Task 3: Simplify `BaseLayout.vue` — Remove Navbar

**Files:**
- Modify: `data-agent-frontend/src/layouts/BaseLayout.vue`

- [ ] **Step 1: Read current `BaseLayout.vue`**

Read the file to understand current structure.

- [ ] **Step 2: Replace template with minimal wrapper**

Replace the template with:

```vue
<template>
  <div class="page-wrapper">
    <slot />
  </div>
</template>
```

- [ ] **Step 3: Replace scoped styles**

```vue
<style scoped>
.page-wrapper {
  min-height: 100vh;
  background: var(--bg-layout);
}
</style>
```

- [ ] **Step 4: Remove navbar-related imports from `<script setup>`**

Remove any imports for navbar components, icons, router navigation logic that are no longer needed.

---

### Task 4: Redesign `AgentList.vue` — Borderless Card Grid

**Files:**
- Modify: `data-agent-frontend/src/views/AgentList.vue`

- [ ] **Step 1: Read current `AgentList.vue`**

Read the full file to understand template structure and scoped styles.

- [ ] **Step 2: Update template — remove BaseLayout wrapper if present, add gradient-bg**

The page should be self-contained:
- Outer wrapper: `<div class="agent-list-page gradient-bg">`
- Content area: full-page card grid with glass cards
- Search/filter: glass panel at top
- Agent cards: glass cards with hover glow

- [ ] **Step 3: Replace scoped styles for dark glass**

Key changes:
- `.agent-list-page` → `min-height: 100vh; background: var(--gradient-bg);`
- `.main-content` → `max-width: 1400px; margin: 0 auto; padding: 2rem;`
- `.content-title` → `color: var(--text-primary);`
- `.content-subtitle` → `color: var(--text-secondary);`
- `.agent-card` → `background: var(--bg-glass); backdrop-filter: var(--backdrop-blur); border: 1px solid var(--border-glass); border-radius: var(--radius-xl); box-shadow: var(--shadow-glass);`
- `.agent-card:hover` → `border-color: var(--accent-color); box-shadow: var(--glow-md); transform: translateY(-4px);`
- `.agent-name` → `color: var(--text-primary);`
- `.agent-description` → `color: var(--text-secondary);`
- `.agent-meta` → `color: var(--text-tertiary);`
- Filter section → glass panel styling
- Delete button → `background: rgba(248, 113, 113, 0.85);`

- [ ] **Step 4: Update Element Plus component overrides in scoped styles**

```css
:deep(.el-card) {
  background: transparent !important;
  border: none !important;
  box-shadow: none !important;
}

:deep(.el-input__wrapper) {
  background: var(--bg-glass) !important;
  border-color: var(--border-glass) !important;
  box-shadow: none !important;
}

:deep(.el-input__inner) {
  color: var(--text-primary) !important;
}

:deep(.el-button--primary) {
  background: var(--accent-color) !important;
  border-color: var(--accent-color) !important;
}

:deep(.el-tabs__item) {
  color: var(--text-secondary) !important;
}

:deep(.el-tabs__item.is-active) {
  color: var(--accent-color) !important;
}

:deep(.el-tabs__active-bar) {
  background-color: var(--accent-color) !important;
}
```

---

### Task 5: Redesign `AgentRun.vue` — Left History + Right Chat

**Files:**
- Modify: `data-agent-frontend/src/views/AgentRun.vue`

- [ ] **Step 1: Read current `AgentRun.vue`**

This is the largest file. Read it in sections to understand:
- Template structure (lines 1-400)
- Script logic (lines 400-1700)
- Scoped styles (lines 1700+)
- Inline styles in template (L39, L1707, L373)

- [ ] **Step 2: Fix inline template styles**

- Line ~39: Remove `style="background-color: white"` from container
- Line ~1707: Change `.input-area` inline `rgba(255,255,255,0.9)` → use CSS class with `var(--bg-glass)`
- Line ~373: Change `highlight.js/styles/github.css` → `highlight.js/styles/github-dark.css`

- [ ] **Step 3: Update layout structure**

New layout:
- Left sidebar: `width: 280px`, glass panel, session history
- Right chat area: flex-1, glass message bubbles
- Input area: bottom, glass panel with blur

- [ ] **Step 4: Replace/add scoped styles for dark chat UI**

Key styles:
- `.chat-container` → `background: transparent;`
- `.messages-area` → `max-width: 900px; margin: 0 auto;`
- User message bubble → `background: var(--accent-color); color: #fff; border-radius: 20px 20px 4px 20px;`
- Assistant message bubble → `background: var(--bg-glass); backdrop-filter: var(--backdrop-blur); border: 1px solid var(--border-glass); border-radius: 20px 20px 20px 4px;`
- `.input-area` → `background: var(--bg-glass); backdrop-filter: var(--backdrop-blur); border-top: 1px solid var(--border-glass);`
- `.send-button` → `background: var(--accent-color); border-radius: 50%;`
- `.send-button:hover` → `background: var(--accent-hover); box-shadow: var(--glow-md);`
- `.agent-response-block` → `background: var(--bg-glass); border: 1px solid var(--border-glass);`

- [ ] **Step 5: Update `generateNodeHtml()` inline styles**

Find the `generateNodeHtml()` function in the script section. Update any hardcoded light colors (white backgrounds, dark text) to use CSS class names that will inherit from the dark theme. Replace inline `style="background: white"` with class-based styling.

- [ ] **Step 6: Update sidebar styles (if ChatSessionSidebar is inline)**

If the sidebar is part of AgentRun.vue (not a separate component), add:
- Sidebar → `width: 280px; background: var(--bg-glass); backdrop-filter: var(--backdrop-blur); border-right: 1px solid var(--border-glass);`
- Session items → `border-radius: var(--radius-base);` hover `background: var(--bg-glass-hover);`
- Active session → `background: var(--accent-light); color: var(--accent-color);`

---

### Task 6: Redesign `AgentDetail.vue` — Glass Panels

**Files:**
- Modify: `data-agent-frontend/src/views/AgentDetail.vue`

- [ ] **Step 1: Read current `AgentDetail.vue`**

Read the full file to understand the el-container/el-header/el-aside/el-main layout.

- [ ] **Step 2: Fix inline template styles**

- Line ~21: Remove `style="background-color: white"` from el-header
- Line ~68: Remove `style="background-color: white"` from el-aside
- Line ~124: Remove `style="background-color: white"` from el-main

- [ ] **Step 3: Update scoped styles for dark glass**

- Page wrapper → `background: var(--gradient-bg); min-height: 100vh;`
- el-header → `background: var(--bg-glass); backdrop-filter: var(--backdrop-blur); border-bottom: 1px solid var(--border-glass);`
- el-aside → `background: var(--bg-glass); backdrop-filter: var(--backdrop-blur); border-right: 1px solid var(--border-glass);`
- el-main → `background: transparent;`
- el-menu → `background: transparent !important; border: none !important;`
- el-menu-item → `color: var(--text-secondary) !important;` hover `background: var(--bg-glass-hover) !important; color: var(--text-primary) !important;`
- el-menu-item.is-active → `background: var(--accent-light) !important; color: var(--accent-color) !important; border-radius: var(--radius-base);`
- Content cards → glass card styling
- Title → `color: var(--text-primary);`
- Description → `color: var(--text-secondary);`

- [ ] **Step 4: Update Element Plus overrides in scoped styles**

```css
:deep(.el-tabs__item) { color: var(--text-secondary) !important; }
:deep(.el-tabs__item.is-active) { color: var(--accent-color) !important; }
:deep(.el-tabs__active-bar) { background-color: var(--accent-color) !important; }
:deep(.el-descriptions__label) { color: var(--text-secondary) !important; }
:deep(.el-descriptions__content) { color: var(--text-primary) !important; }
:deep(.el-button--primary) { background: var(--accent-color) !important; border-color: var(--accent-color) !important; }
```

---

### Task 7: Redesign `AgentCreate.vue` — Centered Glass Form

**Files:**
- Modify: `data-agent-frontend/src/views/AgentCreate.vue`

- [ ] **Step 1: Read current `AgentCreate.vue`**

- [ ] **Step 2: Update scoped styles**

- Page wrapper → `background: var(--gradient-bg); min-height: 100vh;`
- Form container → `max-width: 800px; margin: 0 auto; padding: 2rem;`
- Form card → `background: var(--bg-glass); backdrop-filter: var(--backdrop-blur); border: 1px solid var(--border-glass); border-radius: var(--radius-xl); box-shadow: var(--shadow-glass);`
- Title → `color: var(--text-primary);`
- Step indicators → accent color for active step
- Submit button → `border-radius: var(--radius-pill); background: var(--accent-color);`

- [ ] **Step 3: Update Element Plus overrides**

```css
:deep(.el-form-item__label) { color: var(--text-primary) !important; }
:deep(.el-input__wrapper) { background: var(--bg-glass) !important; border-color: var(--border-glass) !important; }
:deep(.el-input__inner) { color: var(--text-primary) !important; }
:deep(.el-textarea__inner) { background: var(--bg-glass) !important; border-color: var(--border-glass) !important; color: var(--text-primary) !important; }
:deep(.el-steps) { --el-step-icon-background-color: var(--bg-glass); }
:deep(.el-step.is-process .el-step__icon) { background: var(--accent-color) !important; border-color: var(--accent-color) !important; }
```

---

### Task 8: Redesign `ModelConfig.vue` — Glass Table

**Files:**
- Modify: `data-agent-frontend/src/views/ModelConfig.vue`

- [ ] **Step 1: Read current `ModelConfig.vue`**

- [ ] **Step 2: Update scoped styles**

- Page wrapper → `background: var(--gradient-bg); min-height: 100vh;`
- Content area → `max-width: 1200px; margin: 0 auto; padding: 2rem;`
- Title → `color: var(--text-primary);`
- Table wrapper → `background: var(--bg-glass); backdrop-filter: var(--backdrop-blur); border: 1px solid var(--border-glass); border-radius: var(--radius-xl); overflow: hidden;`
- Table header row → `background: rgba(15, 23, 42, 0.5);`
- Table cells → `color: var(--text-primary); border-color: var(--border-glass);`

- [ ] **Step 3: Update Element Plus table overrides**

```css
:deep(.el-table) { background: transparent !important; --el-table-border-color: var(--border-glass) !important; }
:deep(.el-table th) { background: rgba(15, 23, 42, 0.5) !important; color: var(--text-primary) !important; }
:deep(.el-table td) { color: var(--text-secondary) !important; border-color: var(--border-glass) !important; }
:deep(.el-table--enable-row-hover .el-table__body tr:hover > td) { background: var(--bg-glass-hover) !important; }
:deep(.el-table__empty-text) { color: var(--text-tertiary) !important; }
```

---

### Task 9: Redesign `NotFound.vue` — Dark 404

**Files:**
- Modify: `data-agent-frontend/src/views/NotFound.vue`

- [ ] **Step 1: Read current `NotFound.vue`**

- [ ] **Step 2: Update template and styles**

Replace with dark-themed 404:

```vue
<template>
  <div class="not-found-page gradient-bg">
    <div class="not-found-content">
      <div class="not-found-icon">
        <el-icon :size="80" color="var(--text-tertiary)">
          <WarningFilled />
        </el-icon>
      </div>
      <h1 class="not-found-title">404</h1>
      <p class="not-found-text">页面未找到</p>
      <p class="not-found-desc">抱歉，您访问的页面不存在或已被移除</p>
      <el-button type="primary" size="large" @click="goHome" class="glass-btn">
        返回首页
      </el-button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { WarningFilled } from '@element-plus/icons-vue'

const router = useRouter()
const goHome = () => router.push('/agents')
</script>

<style scoped>
.not-found-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}

.not-found-content {
  text-align: center;
  padding: 2rem;
}

.not-found-icon {
  margin-bottom: 1rem;
  opacity: 0.5;
}

.not-found-title {
  font-size: 6rem;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0;
  line-height: 1;
  letter-spacing: -0.04em;
}

.not-found-text {
  font-size: 1.5rem;
  font-weight: 600;
  color: var(--text-primary);
  margin: 1rem 0 0.5rem;
}

.not-found-desc {
  font-size: 1rem;
  color: var(--text-secondary);
  margin: 0 0 2rem;
}

.glass-btn {
  background: var(--accent-color) !important;
  border-color: var(--accent-color) !important;
  border-radius: var(--radius-pill) !important;
  padding: 12px 32px !important;
}

.glass-btn:hover {
  background: var(--accent-hover) !important;
  box-shadow: var(--glow-md) !important;
}
</style>
```

---

### Task 10: Update Sub-Components — Agent Config (9 files)

**Files:**
- Modify: `data-agent-frontend/src/components/agent/DataSourceConfig.vue`
- Modify: `data-agent-frontend/src/components/agent/BaseSetting.vue`
- Modify: `data-agent-frontend/src/components/agent/SemanticsConfig.vue`
- Modify: `data-agent-frontend/src/components/agent/PromptConfig.vue`
- Modify: `data-agent-frontend/src/components/agent/BusinessKnowledgeConfig.vue`
- Modify: `data-agent-frontend/src/components/agent/AgentKnowledgeConfig.vue`
- Modify: `data-agent-frontend/src/components/agent/PresetsConfig.vue`
- Modify: `data-agent-frontend/src/components/agent/BatchImportDialog.vue`
- Modify: `data-agent-frontend/src/components/agent/AccessApi.vue`

- [ ] **Step 1: Apply consistent dark glass updates across all 9 components**

For EACH component:
1. Read the file
2. Find `<style scoped>` block
3. Update backgrounds: `var(--bg-glass)` instead of `white`/`#fff`
4. Update borders: `var(--border-glass)` instead of `#e2e8f0`
5. Update text: `var(--text-primary)` / `var(--text-secondary)` instead of `#333`/`#666`
6. Update hover states: `var(--bg-glass-hover)` / `var(--border-glass-hover)`
7. Update button colors: `var(--accent-color)` for primary actions

- [ ] **Step 2: DataSourceConfig.vue — Specific updates**

- Table wrapper → glass styling
- Connection status badge → `color: var(--success-color);`
- Test connection button → `background: var(--accent-color); border-radius: var(--radius-pill);`
- Form labels → `color: var(--text-primary);`

- [ ] **Step 3: BatchImportDialog.vue — Dialog styling**

- Dialog header → `border-bottom: 1px solid var(--border-glass);`
- Upload area → `border: 2px dashed var(--border-glass); border-radius: var(--radius-lg);` hover `border-color: var(--accent-color); background: var(--accent-light);`

- [ ] **Step 4: AccessApi.vue — API key management**

- API key list items → glass cards
- Copy button → `color: var(--accent-color);`
- Create button → `background: var(--accent-color); border-radius: var(--radius-pill);`

---

### Task 11: Update Sub-Components — Run (7 files)

**Files:**
- Modify: `data-agent-frontend/src/components/run/ChatSessionSidebar.vue`
- Modify: `data-agent-frontend/src/components/run/PresetQuestions.vue`
- Modify: `data-agent-frontend/src/components/run/ResultSetDisplay.vue`
- Modify: `data-agent-frontend/src/components/run/ReportHtmlView.vue`
- Modify: `data-agent-frontend/src/components/run/ChartComponent.vue`
- Modify: `data-agent-frontend/src/components/run/HumanFeedback.vue`
- Modify: `data-agent-frontend/src/components/run/markdown/MarkdownAgentContainer.vue`

- [ ] **Step 1: ChatSessionSidebar.vue**

- Sidebar → `background: var(--bg-glass); backdrop-filter: var(--backdrop-blur); border-right: 1px solid var(--border-glass);`
- Session items → `border-radius: var(--radius-base);` hover `background: var(--bg-glass-hover);`
- Active session → `background: var(--accent-light); color: var(--accent-color);`
- New chat button → `background: var(--accent-color); border-radius: var(--radius-pill);`
- Search input → `background: var(--bg-glass); border-color: var(--border-glass);`

- [ ] **Step 2: PresetQuestions.vue**

- Question buttons → `background: var(--bg-glass); border: 1px solid var(--border-glass); border-radius: var(--radius-pill); color: var(--text-secondary);`
- Hover → `background: var(--accent-light); border-color: var(--accent-color); color: var(--accent-color);`

- [ ] **Step 3: ResultSetDisplay.vue**

- Table container → `background: var(--bg-glass); border: 1px solid var(--border-glass); border-radius: var(--radius-lg); overflow: hidden;`
- Table header → `background: rgba(15, 23, 42, 0.5); color: var(--text-primary);`
- Pagination buttons → `border-radius: var(--radius-pill);`

- [ ] **Step 4: ReportHtmlView.vue**

- Report container → glass styling
- Fullscreen overlay → `background: rgba(0, 0, 0, 0.8); backdrop-filter: blur(8px);`
- Fullscreen container → `background: var(--bg-primary); border: 1px solid var(--border-glass);`

- [ ] **Step 5: HumanFeedback.vue**

- Feedback container → `background: var(--bg-glass); border: 1px solid var(--border-glass); border-radius: var(--radius-lg);`
- Textarea → `background: var(--bg-glass); border-color: var(--border-glass); color: var(--text-primary);`
- Submit button → `background: var(--accent-color); border-radius: var(--radius-pill);`

- [ ] **Step 6: MarkdownAgentContainer.vue**

- Markdown container → `background: var(--bg-glass); border: 1px solid var(--border-glass); border-radius: var(--radius-lg);`
- Code blocks → already handled by highlight.js dark theme
- Text → `color: var(--text-primary);`

- [ ] **Step 7: ChartComponent.vue**

- Chart container → `background: var(--bg-glass); border: 1px solid var(--border-glass); border-radius: var(--radius-lg);`
- Chart title → `color: var(--text-primary);`

---

### Task 12: Update ECharts Dark Theme

**Files:**
- Modify: `data-agent-frontend/src/components/run/charts/ChartFactory.ts`

- [ ] **Step 1: Read current `ChartFactory.ts`**

- [ ] **Step 2: Update default chart colors for dark theme**

```ts
const darkTheme = {
  backgroundColor: 'transparent',
  textStyle: { color: '#cbd5e1' },
  title: { textStyle: { color: '#f1f5f9' } },
  legend: { textStyle: { color: '#cbd5e1' } },
  xAxis: {
    axisLine: { lineStyle: { color: '#334155' } },
    axisLabel: { color: '#94a3b8' },
    splitLine: { lineStyle: { color: 'rgba(51, 65, 85, 0.3)' } }
  },
  yAxis: {
    axisLine: { lineStyle: { color: '#334155' } },
    axisLabel: { color: '#94a3b8' },
    splitLine: { lineStyle: { color: 'rgba(51, 65, 85, 0.3)' } }
  },
  tooltip: {
    backgroundColor: 'rgba(30, 41, 59, 0.95)',
    borderColor: '#334155',
    textStyle: { color: '#f1f5f9' }
  },
  color: ['#60a5fa', '#fbbf24', '#34d399', '#f87171', '#a78bfa', '#fb923c'],
};
```

- [ ] **Step 3: Update any hardcoded light colors in chart options**

Search for `'#fff'`, `'white'`, `'#000'`, `'#333'` in chart option generation and replace with dark-appropriate values.

---

### Task 13: Update `index.html` — Meta Theme & Highlight.js

**Files:**
- Modify: `data-agent-frontend/src/index.html`

- [ ] **Step 1: Update meta theme-color**

Change `<meta name="theme-color" content="#ffffff">` → `<meta name="theme-color" content="#0f172a">`

- [ ] **Step 2: Update highlight.js theme**

Change `<link rel="stylesheet" href=".../github.css">` → `<link rel="stylesheet" href=".../github-dark.css">`

- [ ] **Step 3: Update background color**

If there's an inline style on `<body>` or `<html>` with a light background, change to `#0f172a`.

---

### Task 14: Build Verification & Deployment

**Files:**
- All modified files

- [ ] **Step 1: Run frontend build**

```bash
cd data-agent-frontend && npm run build
```

Expected: Build succeeds with no CSS/JS errors.

- [ ] **Step 2: Run type check**

```bash
cd data-agent-frontend && npm run type-check
```

Expected: No type errors (or only pre-existing ones).

- [ ] **Step 3: Docker build and deploy**

```bash
cd docker-file && docker compose up -d --build frontend
```

- [ ] **Step 4: Visual verification**

Deploy to `192.168.10.221` and verify:
- [ ] Homepage: dark gradient background, glass cards, hover glow
- [ ] Run page: left sidebar (280px) + right chat, glass message bubbles
- [ ] Create/Edit page: centered glass form card
- [ ] Model config: glass table
- [ ] All text readable (WCAG AA contrast)
- [ ] Element Plus components dark-themed
- [ ] ECharts charts dark-themed
- [ ] Code blocks use github-dark theme
- [ ] No light-colored artifacts

---

## Self-Review

### Spec Coverage Check

| Spec Section | Task Coverage | Status |
|--------------|--------------|--------|
| Global CSS Variables | Task 1 (Step 1) | ✅ |
| Firefox `backdrop-filter` Fallback | Task 1 (Step 2) | ✅ |
| Element Plus Dark Overrides | Task 1 (Step 3) | ✅ |
| Scrollbar Colors | Task 1 (Step 4) | ✅ |
| Remove Dead `.btn` Block | Task 1 (Step 5) | ✅ |
| Button Dark Styles | Task 1 (Step 6) | ✅ |
| Form Control Dark | Task 1 (Step 7) | ✅ |
| Card Glass Styles | Task 1 (Step 8-9) | ✅ |
| Badge/Status Dark | Task 1 (Step 10) | ✅ |
| Table Dark | Task 1 (Step 11) | ✅ |
| Message Toast Dark | Task 1 (Step 12) | ✅ |
| Spinner/Tooltip Dark | Task 1 (Step 13-14) | ✅ |
| Remove `prefers-color-scheme` | Task 1 (Step 15) | ✅ |
| `.html-rendered-content` Dark | Task 1 (Step 16) | ✅ |
| `.agent-response-*` Dark | Task 1 (Step 17) | ✅ |
| `prefers-reduced-motion` Glow | Task 1 (Step 18) | ✅ |
| `.glass-card` Utility | Task 1 (Step 19) | ✅ |
| `main.js` Import Order | Task 2 | ✅ |
| `BaseLayout.vue` Simplify | Task 3 | ✅ |
| `AgentList.vue` Redesign | Task 4 | ✅ |
| `AgentRun.vue` Inline Styles | Task 5 (Step 2) | ✅ |
| `AgentRun.vue` Chat UI | Task 5 (Step 4) | ✅ |
| `AgentRun.vue` `generateNodeHtml()` | Task 5 (Step 5) | ✅ |
| `AgentDetail.vue` Inline Styles | Task 6 (Step 2) | ✅ |
| `AgentDetail.vue` Glass Panels | Task 6 (Step 3) | ✅ |
| `AgentCreate.vue` Glass Form | Task 7 | ✅ |
| `ModelConfig.vue` Glass Table | Task 8 | ✅ |
| `NotFound.vue` Dark 404 | Task 9 | ✅ |
| Agent Config Components (9) | Task 10 | ✅ |
| Run Components (7) | Task 11 | ✅ |
| ECharts Dark Theme | Task 12 | ✅ |
| `index.html` Meta & Highlight.js | Task 13 | ✅ |
| Build & Deploy | Task 14 | ✅ |

### Placeholder Scan
No placeholders found. All steps contain actual code/content or specific instructions.

### Type Consistency
All CSS variable names consistent with v3 spec. No function signature mismatches.
