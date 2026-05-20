# UI Modernization Design Spec — DataAgent "清爽现代"

**Date**: 2026-05-20
**Project**: DataAgent (宁西高速智能总数)
**Scope**: Full frontend UI modernization — all pages and components

---

## 1. Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Visual Style | 清爽现代 (Vercel/Linear) | Clean, airy, professional |
| Color System | 藏青+科技蓝+琥珀橙 | Aligns with "宁西高速" brand identity |
| Approach | CSS variable upgrade | Low risk, no new deps, leverages existing 1300+ line system |
| Scope | Full transformation (20+ files) | Consistent style across entire app |

---

## 2. Color System

### New CSS Variables (replace in `global.css`)

```css
: {
  /* 主色系 — 藏青+科技蓝 */
  --primary-color: #0f172a;       /* 藏青 — 导航/标题/重要文字 */
  --primary-hover: #1e293b;
  --primary-light: #f1f5f9;
  --primary-lighter: #f8fafc;

  /* 强调色 — 科技蓝 */
  --accent-color: #3b82f6;        /* 按钮/链接/高亮 */
  --accent-hover: #2563eb;
  --accent-light: #eff6ff;
  --accent-glow: rgba(59, 130, 246, 0.15);

  /* 高速点缀 — 琥珀橙 */
  --highlight-color: #f59e0b;     /* CTA/强调/高速元素 */
  --highlight-hover: #d97706;
  --highlight-light: #fffbeb;

  /* 辅助色 */
  --success-color: #10b981;       /* 翠绿 */
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
  --bg-secondary: #f8fafc;        /* 极浅灰蓝 */
  --bg-tertiary: #f1f5f9;
  --bg-layout: #f1f5f9;

  /* 边框色 */
  --border-primary: #e2e8f0;
  --border-secondary: #f1f5f9;
  --border-tertiary: #f8fafc;

  /* 圆角 — 更圆润 */
  --radius-xs: 4px;
  --radius-sm: 8px;
  --radius-base: 10px;
  --radius-md: 12px;
  --radius-lg: 16px;
  --radius-xl: 20px;
  --radius-2xl: 24px;
  --radius-pill: 999px;

  /* 阴影 — 更柔和 */
  --shadow-xs: 0 1px 2px rgba(0, 0, 0, 0.04);
  --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.06), 0 1px 2px rgba(0, 0, 0, 0.04);
  --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.05), 0 2px 4px rgba(0, 0, 0, 0.03);
  --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.07), 0 4px 6px rgba(0, 0, 0, 0.04);
  --shadow-xl: 0 20px 25px rgba(0, 0, 0, 0.08), 0 8px 10px rgba(0, 0, 0, 0.04);
  --shadow-glow: 0 0 0 3px var(--accent-glow);
}
```

### Dark Mode Updates

```css
@media (prefers-color-scheme: dark) {
  : {
    --text-primary: #f8fafc;
    --text-secondary: #cbd5e1;
    --text-tertiary: #94a3b8;
    --bg-primary: #1e293b;
    --bg-secondary: #0f172a;
    --bg-tertiary: #334155;
    --bg-layout: #020617;
    --border-primary: #334155;
    --border-secondary: #1e293b;
  }
}
```

---

## 3. Component Design

### 3.1 Navigation Bar (BaseLayout.vue)

- **Background**: `rgba(255, 255, 255, 0.8)` + `backdrop-filter: blur(12px)`
- **Height**: `64px`
- **Border**: `1px solid var(--border-secondary)` bottom only
- **Brand text**: `font-weight: 700`, `letter-spacing: -0.02em`, `color: var(--primary-color)`
- **Nav items**: Pill-shaped hover (`border-radius: var(--radius-pill)`), `color: var(--text-secondary)` → `color: var(--accent-color)` on active
- **Shadow**: `var(--shadow-xs)` only on scroll

### 3.2 Agent Cards (AgentList.vue)

- **Card**: `border-radius: var(--radius-xl)`, `border: 1px solid var(--border-primary)`, `background: var(--bg-primary)`
- **Hover**: `transform: translateY(-4px)`, `box-shadow: var(--shadow-lg)`, `border-color: var(--accent-color)`
- **Header area**: Icon circle (40px) with gradient background (`--accent-color` → `--highlight-color`)
- **Title**: `font-weight: 700`, `font-size: 16px`, `color: var(--primary-color)`
- **Description**: `color: var(--text-secondary)`, `line-height: 1.6`, 2-line clamp
- **Meta row**: ID + date + status badge in flex row with `gap: 12px`
- **Status badge**: Pill shape (`border-radius: var(--radius-pill)`), dot indicator before text
- **Grid gap**: `24px` (was `16px`)
- **Actions row**: "查看"/"编辑"/"运行" buttons as icon+text, hover fills with accent light

### 3.3 Filter Tabs (AgentList.vue)

- **Layout**: Horizontal scroll on mobile, flex row on desktop
- **Tab style**: Pill buttons, `padding: 8px 16px`, `border-radius: var(--radius-pill)`
- **Active tab**: `background: var(--primary-color)`, `color: white`
- **Inactive tab**: `background: transparent`, `color: var(--text-secondary)`, hover `background: var(--bg-tertiary)`
- **Count badge**: Small circle with number, `background: var(--bg-tertiary)` → `rgba(255,255,255,0.2)` on active

### 3.4 Search Box (AgentList.vue)

- **Container**: `border-radius: var(--radius-lg)`, `border: 1px solid var(--border-primary)`
- **Focus**: `border-color: var(--accent-color)`, `box-shadow: var(--shadow-glow)`
- **Icon**: Search icon in left padding area, `color: var(--text-tertiary)`
- **Height**: `44px`
- **Placeholder**: `color: var(--text-quaternary)`

### 3.5 Buttons (global.css)

- **Primary**: `background: var(--accent-color)`, `border-radius: var(--radius-pill)`, `padding: 10px 24px`
  - Hover: `background: var(--accent-hover)`, `box-shadow: var(--shadow-md)`
  - Remove gradient, use flat color for modern feel
- **Secondary**: `background: var(--bg-primary)`, `border: 1px solid var(--border-primary)`, `border-radius: var(--radius-pill)`
  - Hover: `background: var(--bg-tertiary)`, `border-color: var(--text-tertiary)`
- **Text/Link**: `color: var(--accent-color)`, no underline, hover underline
- **Icon buttons**: `width: 36px`, `height: 36px`, `border-radius: var(--radius-base)`, hover `background: var(--bg-tertiary)`
- **Remove**: `::before` shine/glow animation (feels dated)

### 3.6 Forms (global.css)

- **Input**: `border-radius: var(--radius-base)`, `border: 1px solid var(--border-primary)`, `padding: 10px 14px`
- **Focus**: `border-color: var(--accent-color)`, `box-shadow: var(--shadow-glow)`, `outline: none`
- **Label**: `font-weight: 600`, `color: var(--text-primary)`, `font-size: 14px`
- **Required indicator**: Red asterisk `color: var(--error-color)`
- **Textarea**: Same as input + `resize: vertical`, `min-height: 80px`
- **Select**: Custom chevron arrow, same border/focus as input

### 3.7 Run Page (AgentRun.vue)

#### Chat Area
- **User bubble**: `background: linear-gradient(135deg, var(--accent-color), var(--accent-hover))`, `color: white`, `border-radius: 20px 20px 4px 20px`, `max-width: 70%`
- **AI bubble**: `background: var(--bg-primary)`, `border: 1px solid var(--border-primary)`, `border-radius: 20px 20px 20px 4px`, `box-shadow: var(--shadow-xs)`
- **Message spacing**: `gap: 16px` between messages
- **Avatar**: 32px circle, user = accent color, AI = gradient icon

#### Input Area
- **Container**: Fixed bottom, `background: rgba(255,255,255,0.9)`, `backdrop-filter: blur(12px)`, `border-top: 1px solid var(--border-secondary)`
- **Input field**: `border-radius: var(--radius-xl)`, `border: 1px solid var(--border-primary)`, `padding: 14px 20px`, `font-size: 15px`
- **Send button**: Circular, `width: 44px`, `height: 44px`, `border-radius: 50%`, `background: var(--accent-color)`
  - Hover: `background: var(--accent-hover)`, `transform: scale(1.05)`
- **Placeholder**: "输入你的问题..."

#### Preset Questions
- **Layout**: Horizontal scroll on mobile, wrap on desktop
- **Pill buttons**: `border-radius: var(--radius-pill)`, `border: 1px solid var(--border-primary)`, `padding: 8px 16px`
- **Hover**: `background: var(--accent-light)`, `border-color: var(--accent-color)`, `color: var(--accent-color)`
- **Icon**: Small sparkle/question icon before text

### 3.8 Tables (global.css)

- **Header**: `background: var(--bg-secondary)`, `font-weight: 600`, `color: var(--text-primary)`
- **Rows**: `border-bottom: 1px solid var(--border-secondary)`, hover `background: var(--bg-tertiary)`
- **Border radius**: Wrap in container with `border-radius: var(--radius-lg)`, `overflow: hidden`
- **Cell padding**: `14px 16px`

### 3.9 Status Badges (global.css)

- **Shape**: Pill with dot indicator
- **Active/Published**: `background: var(--success-light)`, `color: #059669`, dot `#10b981`
- **Draft**: `background: var(--warning-light)`, `color: #d97706`, dot `#f59e0b`
- **Offline**: `background: var(--bg-tertiary)`, `color: var(--text-tertiary)`, dot `#94a3b8`
- **Format**: `⬤ 已发布` (dot + text)

### 3.10 Loading States

- **Spinner**: `border: 2px solid var(--border-secondary)`, `border-top-color: var(--accent-color)`
- **Skeleton**: `background: linear-gradient(90deg, var(--bg-tertiary) 25%, var(--bg-secondary) 50%, var(--bg-tertiary) 75%)`, `background-size: 200% 100%`, animation shimmer
- **Page loader**: Centered spinner with "加载中..." text

### 3.11 Transitions & Animations

- **Page transitions**: `fade + slide-up`, `0.3s ease-out`
- **Card entrance**: Staggered `fade-in-up`, `0.4s ease-out`, `delay: index * 0.05s`
- **Button press**: `transform: scale(0.98)`, `0.1s`
- **Modal**: `fade + scale`, `0.2s ease-out`

---

## 4. File Changes

### Core Files (CSS)
| File | Changes |
|------|---------|
| `src/styles/global.css` | Replace color system, update buttons/forms/cards/tables/badges |
| `src/App.vue` | Minor layout adjustments if needed |

### Layout
| File | Changes |
|------|---------|
| `src/layouts/BaseLayout.vue` | Navbar glass effect, brand styling, nav item pills |

### Views
| File | Changes |
|------|---------|
| `src/views/AgentList.vue` | Card redesign, filter tabs, search box, grid layout |
| `src/views/AgentRun.vue` | Chat bubbles, input area, preset questions |
| `src/views/AgentDetail.vue` | Detail card styling, action buttons |
| `src/views/AgentCreate.vue` | Form styling, step indicators |
| `src/views/ModelConfig.vue` | Table/list styling |
| `src/views/NotFound.vue` | 404 page styling |

### Components — Agent Config
| File | Changes |
|------|---------|
| `src/components/agent/DataSourceConfig.vue` | Form inputs, table, buttons |
| `src/components/agent/BaseSetting.vue` | Form styling |
| `src/components/agent/SemanticsConfig.vue` | Form styling |
| `src/components/agent/PromptConfig.vue` | Textarea styling |
| `src/components/agent/BusinessKnowledgeConfig.vue` | Form styling |
| `src/components/agent/AgentKnowledgeConfig.vue` | Form styling |
| `src/components/agent/PresetsConfig.vue` | List/card styling |
| `src/components/agent/BatchImportDialog.vue` | Modal, form styling |
| `src/components/agent/AccessApi.vue` | Code block, form styling |

### Components — Run
| File | Changes |
|------|---------|
| `src/components/run/ChatSessionSidebar.vue` | Sidebar styling, list items |
| `src/components/run/PresetQuestions.vue` | Pill buttons |
| `src/components/run/ResultSetDisplay.vue` | Table/card styling |
| `src/components/run/ReportHtmlView.vue` | Report container styling |
| `src/components/run/ChartComponent.vue` | Chart container styling |
| `src/components/run/HumanFeedback.vue` | Dialog styling |
| `src/components/run/markdown/MarkdownAgentContainer.vue` | Markdown content styling |

---

## 5. Error Handling

- **Form validation**: Red border + error text below field, `color: var(--error-color)`
- **API errors**: Toast notification top-right, `background: var(--error-light)`, `border: 1px solid rgba(239,68,68,0.2)`
- **Empty states**: Centered icon + text, `color: var(--text-tertiary)`, `font-size: 14px`
- **Loading errors**: Retry button with icon, `color: var(--accent-color)`

---

## 6. Testing Strategy

1. **Visual regression**: Screenshot home page, run page, agent detail before/after
2. **Responsive**: Test at 1920px, 1440px, 768px, 375px breakpoints
3. **Dark mode**: Toggle `prefers-color-scheme: dark` in dev tools
4. **Interaction**: Verify all hover/active/focus states work
5. **Build**: `npm run build` must succeed with no CSS errors

---

## 7. Rollback Plan

- Current `global.css` is backed up before changes
- All changes are CSS-only (no logic changes)
- If issues arise: `git checkout -- data-agent-frontend/src/`
