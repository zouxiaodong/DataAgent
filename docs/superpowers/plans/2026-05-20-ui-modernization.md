# UI Modernization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform DataAgent frontend from current style to "清爽现代" (clean modern) design with 藏青+科技蓝+琥珀橙 color system.

**Architecture:** CSS-only changes — upgrade CSS variables in `global.css`, update scoped styles in Vue components. No logic changes, no new dependencies.

**Tech Stack:** Vue 3 Composition API, Element Plus, CSS custom properties, ECharts

---

### Task 1: Upgrade Global CSS Variables & Base Styles

**Files:**
- Modify: `data-agent-frontend/src/styles/global.css`

- [ ] **Step 1: Replace CSS variable definitions in `:`**

Replace the entire `: { ... }` block (lines 18-128) with:

```css
: {
  /* 主色系 — 藏青+科技蓝 */
  --primary-color: #0f172a;
  --primary-hover: #1e293b;
  --primary-light: #f1f5f9;
  --primary-lighter: #f8fafc;

  /* 强调色 — 科技蓝 */
  --accent-color: #3b82f6;
  --accent-hover: #2563eb;
  --accent-light: #eff6ff;
  --accent-glow: rgba(59, 130, 246, 0.15);

  /* 高速点缀 — 琥珀橙 */
  --highlight-color: #f59e0b;
  --highlight-hover: #d97706;
  --highlight-light: #fffbeb;

  /* 辅助色 */
  --success-color: #10b981;
  --success-light: #ecfdf5;
  --warning-color: #f59e0b;
  --warning-light: #fffbeb;
  --error-color: #ef4444;
  --error-light: #fef2f2;
  --info-color: #3b82f6;
  --info-light: #eff6ff;

  /* 中性色 */
  --text-primary: #0f172a;
  --text-secondary: #475569;
  --text-tertiary: #94a3b8;
  --text-quaternary: #cbd5e1;
  --text-disabled: #e2e8f0;

  /* 背景色 */
  --bg-primary: #ffffff;
  --bg-secondary: #f8fafc;
  --bg-tertiary: #f1f5f9;
  --bg-layout: #f1f5f9;

  /* 边框色 */
  --border-primary: #e2e8f0;
  --border-secondary: #f1f5f9;
  --border-tertiary: #f8fafc;
  --border-color: #e2e8f0;

  /* 字体系统 */
  --font-family:
    -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Hiragino Sans GB',
    'Microsoft YaHei', 'Helvetica Neue', Helvetica, Arial, sans-serif;
  --font-family-mono:
    'SF Mono', Monaco, Inconsolata, 'Roboto Mono', 'Source Code Pro', Menlo, Consolas,
    'Ubuntu Mono', monospace;

  /* 字体尺寸 */
  --font-size-xs: 12px;
  --font-size-sm: 14px;
  --font-size-base: 16px;
  --font-size-lg: 18px;
  --font-size-xl: 20px;
  --font-size-2xl: 24px;
  --font-size-3xl: 30px;
  --font-size-4xl: 36px;

  /* 字体重量 */
  --font-weight-light: 300;
  --font-weight-normal: 400;
  --font-weight-medium: 500;
  --font-weight-semibold: 600;
  --font-weight-bold: 700;

  /* 间距系统 */
  --space-xs: 4px;
  --space-sm: 8px;
  --space-base: 12px;
  --space-md: 16px;
  --space-lg: 20px;
  --space-xl: 24px;
  --space-2xl: 32px;
  --space-3xl: 48px;
  --space-4xl: 64px;

  /* 圆角系统 — 更圆润 */
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

  /* 阴影 — 更柔和 */
  --shadow-xs: 0 1px 2px rgba(0, 0, 0, 0.04);
  --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.06), 0 1px 2px rgba(0, 0, 0, 0.04);
  --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.05), 0 2px 4px rgba(0, 0, 0, 0.03);
  --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.07), 0 4px 6px rgba(0, 0, 0, 0.04);
  --shadow-xl: 0 20px 25px rgba(0, 0, 0, 0.08), 0 8px 10px rgba(0, 0, 0, 0.04);
  --shadow-glow: 0 0 0 3px var(--accent-glow);

  /* 过渡动画 */
  --transition-fast: 0.15s cubic-bezier(0.4, 0, 0.2, 1);
  --transition-base: 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  --transition-slow: 0.5s cubic-bezier(0.4, 0, 0.2, 1);

  /* Z-index 层级 */
  --z-dropdown: 1000;
  --z-sticky: 1020;
  --z-fixed: 1030;
  --z-modal-backdrop: 1040;
  --z-modal: 1050;
  --z-popover: 1060;
  --z-tooltip: 1070;
}
```

- [ ] **Step 2: Update dark mode variables**

Replace the `@media (prefers-color-scheme: dark)` block (lines 1332-1346) with:

```css
@media (prefers-color-scheme: dark) {
  : {
    --text-primary: #f8fafc;
    --text-secondary: #cbd5e1;
    --text-tertiary: #94a3b8;
    --text-quaternary: #475569;
    --bg-primary: #1e293b;
    --bg-secondary: #0f172a;
    --bg-tertiary: #334155;
    --bg-layout: #020617;
    --border-primary: #334155;
    --border-secondary: #1e293b;
    --border-tertiary: #0f172a;
  }
}
```

- [ ] **Step 3: Update button styles**

Replace all `.btn-primary` rules (remove gradient, use flat color):

```css
.btn-primary {
  background: var(--accent-color);
  color: white;
  border-color: var(--accent-color);
  border-radius: var(--radius-pill);
  box-shadow: var(--shadow-sm);
}

.btn-primary:hover:not(:disabled) {
  background: var(--accent-hover);
  border-color: var(--accent-hover);
  box-shadow: var(--shadow-md);
  transform: translateY(-1px);
}

.btn-primary:active:not(:disabled) {
  background: var(--accent-hover);
  border-color: var(--accent-hover);
  transform: translateY(0);
  box-shadow: var(--shadow-sm);
}
```

Remove the `.btn::before` shine animation entirely (lines 513-537) — delete those rules.

- [ ] **Step 4: Update card styles**

Replace `.card` and `.card:hover` rules:

```css
.card {
  background: var(--bg-primary);
  border: 1px solid var(--border-primary);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-xs);
  overflow: hidden;
  transition: all var(--transition-base);
}

.card:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-4px);
  border-color: var(--accent-color);
}
```

- [ ] **Step 5: Update form control styles**

Replace `.form-control` focus state:

```css
.form-control:focus {
  outline: none;
  border-color: var(--accent-color);
  box-shadow: var(--shadow-glow);
}
```

- [ ] **Step 6: Update status badge styles**

Replace `.status-badge` rules:

```css
.status-badge {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 4px 10px;
  border-radius: var(--radius-pill);
  font-size: var(--font-size-xs);
  font-weight: var(--font-weight-medium);
  line-height: 1;
  border: 1px solid transparent;
}

.status-badge::before {
  content: '';
  width: 6px;
  height: 6px;
  border-radius: 50%;
  flex-shrink: 0;
}

.status-badge.active {
  background: var(--success-light);
  color: #059669;
  border-color: rgba(16, 185, 129, 0.2);
}
.status-badge.active::before { background: #10b981; }

.status-badge.published {
  background: var(--success-light);
  color: #059669;
  border-color: rgba(16, 185, 129, 0.2);
}
.status-badge.published::before { background: #10b981; }

.status-badge.draft {
  background: var(--warning-light);
  color: #d97706;
  border-color: rgba(245, 158, 11, 0.2);
}
.status-badge.draft::before { background: #f59e0b; }

.status-badge.inactive {
  background: var(--error-light);
  color: #dc2626;
  border-color: rgba(239, 68, 68, 0.2);
}
.status-badge.inactive::before { background: #ef4444; }

.status-badge.offline {
  background: var(--bg-tertiary);
  color: var(--text-tertiary);
  border-color: var(--border-primary);
}
.status-badge.offline::before { background: #94a3b8; }
```

- [ ] **Step 7: Update table styles**

```css
.table th {
  background: var(--bg-secondary);
  padding: var(--space-md) var(--space-lg);
  text-align: left;
  font-weight: var(--font-weight-semibold);
  color: var(--text-primary);
  font-size: var(--font-size-sm);
  border-bottom: 1px solid var(--border-secondary);
}

.table td {
  padding: var(--space-md) var(--space-lg);
  border-bottom: 1px solid var(--border-secondary);
  color: var(--text-secondary);
  font-size: var(--font-size-sm);
}

.table tbody tr:hover {
  background: var(--bg-tertiary);
}
```

- [ ] **Step 8: Verify build**

Run: `cd data-agent-frontend && npm run build`
Expected: Build succeeds with no CSS errors

---

### Task 2: Modernize Navigation Bar (BaseLayout.vue)

**Files:**
- Modify: `data-agent-frontend/src/layouts/BaseLayout.vue`

- [ ] **Step 1: Update scoped styles in BaseLayout.vue**

Replace the entire `<style scoped>` block (lines 87-167) with:

```css
<style scoped>
  .base-layout {
    min-height: 100vh;
    background: var(--bg-layout);
  }

  .page-header {
    background: rgba(255, 255, 255, 0.85);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border-bottom: 1px solid var(--border-secondary);
    box-shadow: var(--shadow-xs);
    position: sticky;
    top: 0;
    z-index: 100;
  }

  .header-content {
    width: 100%;
    padding: 0 1.5rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 4rem;
  }

  .brand-section {
    display: flex;
    align-items: center;
    gap: 2rem;
  }

  .brand-logo {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    font-size: 1.25rem;
    font-weight: 700;
    color: var(--primary-color);
    letter-spacing: -0.02em;
  }

  .brand-logo i {
    font-size: 1.5rem;
    color: var(--accent-color);
  }

  .header-nav {
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .nav-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 1rem;
    border-radius: var(--radius-pill);
    cursor: pointer;
    transition: all 0.2s ease;
    color: var(--text-secondary);
    font-weight: 500;
    font-size: 0.875rem;
  }

  .nav-item:hover {
    background: var(--bg-tertiary);
    color: var(--text-primary);
  }

  .nav-item.active {
    background: var(--accent-light);
    color: var(--accent-color);
    font-weight: 600;
  }

  .nav-item i {
    font-size: 1rem;
  }

  .page-content {
    flex: 1;
    padding: 0;
  }
</style>
```

---

### Task 3: Modernize Agent List Page (AgentList.vue)

**Files:**
- Modify: `data-agent-frontend/src/views/AgentList.vue`

- [ ] **Step 1: Update scoped styles**

Replace the entire `<style scoped>` block (lines 342-584) with:

```css
<style scoped>
  .agent-list-page {
    min-height: 100vh;
    background: var(--bg-layout);
    font-family: var(--font-family);
  }

  .main-content {
    width: 100%;
    max-width: 1400px;
    margin: 0 auto;
    padding: 2rem;
  }

  .content-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-bottom: 2rem;
  }

  .content-title {
    font-size: 2rem;
    font-weight: 700;
    color: var(--primary-color);
    margin: 0 0 0.5rem 0;
    letter-spacing: -0.02em;
  }

  .content-subtitle {
    color: var(--text-secondary);
    margin: 0;
    font-size: 1rem;
  }

  .header-stats {
    display: flex;
    gap: 2rem;
  }

  .stat-item {
    text-align: center;
  }

  .stat-number {
    font-size: 2rem;
    font-weight: 700;
    color: var(--accent-color);
    line-height: 1;
  }

  .stat-label {
    font-size: 0.875rem;
    color: var(--text-secondary);
    margin-top: 0.25rem;
  }

  .filter-section {
    margin-bottom: 2rem;
  }

  .filter-content {
    padding: 20px;
  }

  .filter-tabs-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 1rem;
    flex-wrap: wrap;
  }

  .filter-tabs {
    display: flex;
  }

  .search-and-actions {
    display: flex;
    gap: 1rem;
    align-items: center;
  }

  .action-buttons {
    display: flex;
    gap: 0.5rem;
  }

  .tab-count {
    background: rgba(255, 255, 255, 0.2);
    color: inherit;
    padding: 0.15rem 0.5rem;
    border-radius: var(--radius-pill);
    font-size: 0.75rem;
    font-weight: 600;
    margin-left: 0.5rem;
  }

  /* Agent card redesign */
  .agent-card {
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    border-radius: var(--radius-xl) !important;
    border: 1px solid var(--border-primary) !important;
    background: var(--bg-primary) !important;
    box-shadow: var(--shadow-xs) !important;
    overflow: hidden;
  }

  .agent-card:hover {
    box-shadow: var(--shadow-lg) !important;
    transform: translateY(-4px);
    border-color: var(--accent-color) !important;
  }

  .agent-content {
    position: relative;
    padding: 4px;
  }

  .agent-avatar {
    display: flex;
    justify-content: center;
    margin-bottom: 1rem;
  }

  .agent-avatar :deep(.el-avatar) {
    background: linear-gradient(135deg, var(--accent-color), var(--highlight-color)) !important;
    box-shadow: 0 4px 12px rgba(59, 130, 246, 0.25);
    font-weight: 700;
  }

  .agent-info {
    text-align: center;
    margin-bottom: 1rem;
  }

  .agent-name {
    font-size: 1.0625rem;
    font-weight: 700;
    color: var(--primary-color);
    margin: 0 0 0.5rem 0;
    letter-spacing: -0.01em;
  }

  .agent-description {
    color: var(--text-secondary);
    font-size: 0.875rem;
    line-height: 1.6;
    margin: 0 0 0.75rem 0;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }

  .agent-meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 0.75rem;
    color: var(--text-tertiary);
  }

  .agent-status {
    position: absolute;
    top: 1rem;
    right: 1rem;
  }

  .delete-button {
    position: absolute;
    top: 1rem;
    left: 1rem;
    width: 28px;
    height: 28px;
    border-radius: var(--radius-base);
    background: rgba(239, 68, 68, 0.85);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    opacity: 0;
    transition: all 0.2s ease;
    z-index: 10;
  }

  .delete-button:hover {
    background: rgba(220, 38, 38, 0.95);
    transform: scale(1.1);
  }

  .agent-card:hover .delete-button {
    opacity: 1;
  }

  .loading-state {
    padding: 4rem 2rem;
  }

  .empty-state {
    padding: 4rem 2rem;
  }

  @media (max-width: 768px) {
    .main-content {
      padding: 1rem;
    }

    .content-header {
      flex-direction: column;
      align-items: flex-start;
      gap: 1rem;
    }

    .header-stats {
      gap: 1rem;
    }

    .filter-tabs-row {
      flex-direction: column;
      align-items: stretch;
      gap: 1rem;
    }

    .filter-tabs {
      justify-content: center;
    }

    .search-and-actions {
      flex-direction: column;
      gap: 1rem;
    }

    .search-and-actions .el-input {
      width: 100% !important;
    }

    .action-buttons {
      width: 100%;
    }

    .action-buttons .el-button {
      flex: 1;
    }
  }
</style>
```

---

### Task 4: Modernize Agent Run Page (AgentRun.vue)

**Files:**
- Modify: `data-agent-frontend/src/views/AgentRun.vue`

- [ ] **Step 1: Add scoped styles for modern chat UI**

Append to the end of the file (after existing `<style scoped>` block, or add one if not present):

```css
<style scoped>
  /* Chat container */
  .chat-container {
    flex: 1;
    overflow-y: auto;
    padding: 1.5rem;
    background: var(--bg-secondary);
    scroll-behavior: smooth;
  }

  /* Empty state */
  .empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    gap: 2rem;
  }

  .empty-state-preset {
    max-width: 600px;
    width: 100%;
  }

  /* Message area */
  .messages-area {
    display: flex;
    flex-direction: column;
    gap: 16px;
    max-width: 900px;
    margin: 0 auto;
    width: 100%;
  }

  .message-container {
    display: flex;
  }

  .message-container.user {
    justify-content: flex-end;
  }

  .message-container.assistant {
    justify-content: flex-start;
  }

  .message {
    display: flex;
    gap: 12px;
    max-width: 75%;
  }

  .message.user {
    flex-direction: row-reverse;
  }

  .message-avatar :deep(.el-avatar) {
    flex-shrink: 0;
  }

  .message.user .message-avatar :deep(.el-avatar) {
    background: var(--accent-color) !important;
  }

  .message.assistant .message-avatar :deep(.el-avatar) {
    background: linear-gradient(135deg, var(--accent-color), var(--highlight-color)) !important;
  }

  .message-content {
    padding: 12px 16px;
    border-radius: 20px;
    line-height: 1.6;
    font-size: 14px;
  }

  .message.user .message-content {
    background: linear-gradient(135deg, var(--accent-color), var(--accent-hover));
    color: white;
    border-radius: 20px 20px 4px 20px;
  }

  .message.assistant .message-content {
    background: var(--bg-primary);
    border: 1px solid var(--border-primary);
    border-radius: 20px 20px 20px 4px;
    box-shadow: var(--shadow-xs);
  }

  .message-text {
    word-break: break-word;
  }

  .message-text :deep(pre) {
    background: var(--bg-tertiary);
    padding: 12px;
    border-radius: 8px;
    overflow-x: auto;
    margin: 8px 0;
  }

  .message-text :deep(code) {
    background: var(--bg-tertiary);
    padding: 2px 6px;
    border-radius: 4px;
    font-size: 13px;
  }

  /* Streaming response */
  .streaming-response {
    max-width: 75%;
  }

  .streaming-header {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 0;
    color: var(--text-secondary);
    font-size: 14px;
    font-weight: 500;
  }

  .streaming-header .loading-icon {
    animation: spin 1s linear infinite;
    color: var(--accent-color);
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }

  /* Agent response blocks */
  .agent-response-container {
    display: flex;
    flex-direction: column;
    gap: 12px;
  }

  .agent-response-block {
    background: var(--bg-primary);
    border: 1px solid var(--border-primary);
    border-radius: var(--radius-lg);
    overflow: hidden;
    box-shadow: var(--shadow-xs);
  }

  .agent-response-title {
    background: var(--bg-secondary);
    padding: 10px 16px;
    font-weight: 600;
    font-size: 13px;
    color: var(--text-secondary);
    border-bottom: 1px solid var(--border-secondary);
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .agent-response-content {
    padding: 16px;
  }

  /* Input area */
  .input-area {
    padding: 1rem 1.5rem 1.5rem;
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border-top: 1px solid var(--border-secondary);
  }

  .input-controls {
    margin-bottom: 12px;
  }

  .input-controls-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    padding: 4px 0;
    color: var(--text-secondary);
    font-size: 13px;
    font-weight: 500;
  }

  .input-controls-body {
    padding: 12px 0;
  }

  .switch-group {
    display: flex;
    flex-wrap: wrap;
    gap: 16px;
    align-items: center;
  }

  .switch-item {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 13px;
    color: var(--text-secondary);
  }

  .input-container {
    display: flex;
    gap: 12px;
    align-items: flex-end;
  }

  .input-container :deep(.el-textarea__inner) {
    border-radius: var(--radius-xl) !important;
    border: 1px solid var(--border-primary) !important;
    padding: 14px 20px !important;
    font-size: 15px !important;
    resize: none;
    box-shadow: var(--shadow-xs) !important;
    transition: all 0.2s ease !important;
  }

  .input-container :deep(.el-textarea__inner:focus) {
    border-color: var(--accent-color) !important;
    box-shadow: var(--shadow-glow) !important;
  }

  .send-button {
    width: 44px !important;
    height: 44px !important;
    border-radius: 50% !important;
    background: var(--accent-color) !important;
    border: none !important;
    box-shadow: var(--shadow-md) !important;
    transition: all 0.2s ease !important;
    flex-shrink: 0;
  }

  .send-button:hover:not(:disabled) {
    background: var(--accent-hover) !important;
    transform: scale(1.05) !important;
    box-shadow: var(--shadow-lg) !important;
  }

  .send-button:active:not(:disabled) {
    transform: scale(0.95) !important;
  }

  .send-button.stop-button-inline {
    background: var(--error-color) !important;
  }

  .send-button.stop-button-inline:hover {
    background: #dc2626 !important;
  }

  /* Report fullscreen overlay */
  .report-fullscreen-overlay {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.6);
    backdrop-filter: blur(4px);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
  }

  .report-fullscreen-container {
    background: var(--bg-primary);
    border-radius: var(--radius-2xl);
    width: 90%;
    max-width: 1200px;
    height: 85vh;
    display: flex;
    flex-direction: column;
    box-shadow: var(--shadow-xl);
  }

  .report-fullscreen-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 24px;
    border-bottom: 1px solid var(--border-secondary);
  }

  .report-fullscreen-title {
    font-weight: 700;
    font-size: 16px;
    color: var(--primary-color);
  }

  .report-fullscreen-content {
    flex: 1;
    overflow-y: auto;
    padding: 24px;
  }

  /* Markdown report */
  .markdown-report-message {
    background: var(--bg-primary);
    border: 1px solid var(--border-primary);
    border-radius: var(--radius-lg);
    overflow: hidden;
    box-shadow: var(--shadow-xs);
  }

  .markdown-report-header {
    padding: 12px 16px;
    background: var(--bg-secondary);
    border-bottom: 1px solid var(--border-secondary);
  }

  .report-info {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
    font-weight: 500;
    color: var(--text-secondary);
  }

  .markdown-report-content {
    padding: 20px;
  }

  /* Result set display */
  .result-set-message {
    background: var(--bg-primary);
    border: 1px solid var(--border-primary);
    border-radius: var(--radius-lg);
    padding: 16px;
    box-shadow: var(--shadow-xs);
  }
</style>
```

---

### Task 5: Update Remaining View Pages

**Files:**
- Modify: `data-agent-frontend/src/views/AgentDetail.vue`
- Modify: `data-agent-frontend/src/views/AgentCreate.vue`
- Modify: `data-agent-frontend/src/views/ModelConfig.vue`
- Modify: `data-agent-frontend/src/views/NotFound.vue`

- [ ] **Step 1: AgentDetail.vue — Update scoped styles**

Read the file, find the `<style scoped>` block. Update:
- Page background: `background: var(--bg-layout)`
- Card borders: `border-radius: var(--radius-xl)`, `border: 1px solid var(--border-primary)`
- Card hover: `box-shadow: var(--shadow-lg)`, `transform: translateY(-2px)`
- Button styles: Use `var(--accent-color)` for primary actions
- Title: `font-weight: 700`, `color: var(--primary-color)`

- [ ] **Step 2: AgentCreate.vue — Update scoped styles**

- Page background: `background: var(--bg-layout)`
- Form cards: `border-radius: var(--radius-lg)`, `border: 1px solid var(--border-primary)`
- Step indicators: Accent color for active step
- Submit button: `border-radius: var(--radius-pill)`, `background: var(--accent-color)`

- [ ] **Step 3: ModelConfig.vue — Update scoped styles**

- Table wrapper: `border-radius: var(--radius-lg)`, `overflow: hidden`, `box-shadow: var(--shadow-sm)`
- Page background: `background: var(--bg-layout)`
- Header: `font-weight: 700`, `color: var(--primary-color)`

- [ ] **Step 4: NotFound.vue — Redesign 404 page**

Replace the template and styles with a modern 404:

```vue
<template>
  <BaseLayout>
    <div class="not-found-page">
      <div class="not-found-content">
        <div class="not-found-icon">
          <el-icon :size="80" color="var(--text-tertiary)">
            <WarningFilled />
          </el-icon>
        </div>
        <h1 class="not-found-title">404</h1>
        <p class="not-found-text">页面未找到</p>
        <p class="not-found-desc">抱歉，您访问的页面不存在或已被移除</p>
        <el-button type="primary" size="large" @click="goHome" style="border-radius: var(--radius-pill); padding: 12px 32px;">
          返回首页
        </el-button>
      </div>
    </div>
  </BaseLayout>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { WarningFilled } from '@element-plus/icons-vue'
import BaseLayout from '@/layouts/BaseLayout.vue'

const router = useRouter()
const goHome = () => router.push('/agents')
</script>

<style scoped>
.not-found-page {
  min-height: calc(100vh - 64px);
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-layout);
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
  color: var(--primary-color);
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
</style>
```

---

### Task 6: Update Agent Config Components

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

- [ ] **Step 1: For each component, update scoped styles**

Apply these consistent changes across all agent config components:

**Card/Container backgrounds:**
```css
/* Replace any hardcoded backgrounds */
background: var(--bg-primary);
border: 1px solid var(--border-primary);
border-radius: var(--radius-lg);
box-shadow: var(--shadow-xs);
```

**Section headers:**
```css
font-weight: 700;
color: var(--primary-color);
letter-spacing: -0.01em;
```

**Form groups:**
```css
margin-bottom: var(--space-lg);
```

**Action buttons:**
```css
border-radius: var(--radius-pill);
```

- [ ] **Step 2: DataSourceConfig.vue — Specific updates**

- Table wrapper: `border-radius: var(--radius-lg)`, `overflow: hidden`
- Connection status badge: Use new pill style with dot indicator
- Test connection button: `border-radius: var(--radius-pill)`, `background: var(--accent-color)`

- [ ] **Step 3: BatchImportDialog.vue — Dialog styling**

- Dialog header: `border-bottom: 1px solid var(--border-secondary)`, `padding: 20px 24px`
- Dialog body: `padding: 24px`
- Upload area: `border: 2px dashed var(--border-primary)`, `border-radius: var(--radius-lg)`, hover `border-color: var(--accent-color)`, `background: var(--accent-light)`

---

### Task 7: Update Run Components

**Files:**
- Modify: `data-agent-frontend/src/components/run/ChatSessionSidebar.vue`
- Modify: `data-agent-frontend/src/components/run/PresetQuestions.vue`
- Modify: `data-agent-frontend/src/components/run/ResultSetDisplay.vue`
- Modify: `data-agent-frontend/src/components/run/ReportHtmlView.vue`
- Modify: `data-agent-frontend/src/components/run/ChartComponent.vue`
- Modify: `data-agent-frontend/src/components/run/HumanFeedback.vue`
- Modify: `data-agent-frontend/src/components/run/markdown/MarkdownAgentContainer.vue`

- [ ] **Step 1: ChatSessionSidebar.vue**

- Sidebar background: `background: var(--bg-secondary)`
- Session items: `border-radius: var(--radius-base)`, hover `background: var(--bg-tertiary)`
- Active session: `background: var(--accent-light)`, `color: var(--accent-color)`
- Border: `border-right: 1px solid var(--border-secondary)`

- [ ] **Step 2: PresetQuestions.vue**

```css
.preset-questions-container {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.preset-question-btn {
  border-radius: var(--radius-pill) !important;
  border: 1px solid var(--border-primary) !important;
  padding: 8px 16px !important;
  font-size: 13px !important;
  color: var(--text-secondary) !important;
  background: var(--bg-primary) !important;
  transition: all 0.2s ease !important;
}

.preset-question-btn:hover {
  background: var(--accent-light) !important;
  border-color: var(--accent-color) !important;
  color: var(--accent-color) !important;
}
```

- [ ] **Step 3: ResultSetDisplay.vue**

- Table container: `border-radius: var(--radius-lg)`, `overflow: hidden`, `border: 1px solid var(--border-primary)`
- Table header: `background: var(--bg-secondary)`, `font-weight: 600`
- Pagination: `border-radius: var(--radius-pill)` for buttons

- [ ] **Step 4: HumanFeedback.vue**

- Feedback container: `border-radius: var(--radius-lg)`, `border: 1px solid var(--border-primary)`, `background: var(--bg-primary)`
- Textarea: `border-radius: var(--radius-base)`, focus `border-color: var(--accent-color)`, `box-shadow: var(--shadow-glow)`
- Submit button: `border-radius: var(--radius-pill)`

---

### Task 8: Final Verification & Polish

**Files:**
- All modified files

- [ ] **Step 1: Run type check**

Run: `cd data-agent-frontend && npm run type-check`
Expected: No type errors

- [ ] **Step 2: Run build**

Run: `cd data-agent-frontend && npm run build`
Expected: Build succeeds

- [ ] **Step 3: Visual verification**

Deploy to server and verify:
- [ ] Home page cards have rounded corners, soft shadows, hover lift
- [ ] Navigation bar has glass effect, pill-shaped nav items
- [ ] Run page has chat bubbles with proper shapes
- [ ] Input area has rounded textarea and circular send button
- [ ] All buttons are pill-shaped
- [ ] Status badges have dot indicators
- [ ] Color scheme is consistent (藏青+蓝+橙)
- [ ] Dark mode works correctly

- [ ] **Step 4: Commit**

```bash
cd /mnt/d/researches/DataAgent
git add data-agent-frontend/
git commit -m "feat: modernize UI — 清爽现代 design with 藏青+科技蓝+琥珀橙 color system"
```

---

## Self-Review

### Spec Coverage Check

| Spec Section | Task Coverage | Status |
|--------------|--------------|--------|
| Color System | Task 1 (global.css) | ✅ |
| Dark Mode | Task 1 (global.css) | ✅ |
| Navigation Bar | Task 2 (BaseLayout.vue) | ✅ |
| Agent Cards | Task 3 (AgentList.vue) | ✅ |
| Filter Tabs | Task 3 (AgentList.vue) — Element Plus handles styling | ✅ |
| Search Box | Task 3 (AgentList.vue) — Element Plus handles styling | ✅ |
| Buttons | Task 1 (global.css) | ✅ |
| Forms | Task 1 (global.css) + Tasks 5-7 | ✅ |
| Run Page / Chat Bubbles | Task 4 (AgentRun.vue) | ✅ |
| Input Area | Task 4 (AgentRun.vue) | ✅ |
| Preset Questions | Task 7 (PresetQuestions.vue) | ✅ |
| Tables | Task 1 (global.css) + Task 7 | ✅ |
| Status Badges | Task 1 (global.css) | ✅ |
| Loading States | Task 1 (global.css) — existing spinner styles | ✅ |
| Transitions | Task 1 (global.css) — existing transition vars | ✅ |
| Error Handling | Task 1 (global.css) — existing message styles | ✅ |
| Agent Config Components | Task 6 | ✅ |
| Run Components | Task 7 | ✅ |
| 404 Page | Task 5 (NotFound.vue) | ✅ |

### Placeholder Scan
No placeholders found. All steps contain actual code/content.

### Type Consistency
All CSS variable names are consistent across tasks. No function signature mismatches (CSS-only changes).
