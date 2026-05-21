<!--
 * Copyright 2025 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
-->

<template>
  <div class="markdown-container">
    <div class="markdown-content" ref="markdown-agent-container" @click="hdlClick" />
  </div>
</template>

<script lang="ts">
  import MarkdownIt from 'markdown-it';
  import MarkdownItContainer from 'markdown-it-container';
  import MarkdownPluginEcharts from './markdown-plugin-echarts.ts';
  import MarkdownPluginHighlight from './markdown-plugin-highlight.ts';

  import * as echarts from 'echarts';
  import { EXTENDED_COLORS } from '../charts/BaseChart';
  import { defineComponent } from 'vue';

  // 防抖函数
  function debounce<T extends (...args: any[]) => any>(
    func: T,
    wait: number,
  ): (...args: Parameters<T>) => void {
    let timeout: NodeJS.Timeout | null = null;
    return function executedFunction(...args: Parameters<T>) {
      const later = () => {
        if (timeout) {
          clearTimeout(timeout);
        }
        func(...args);
      };
      if (timeout) {
        clearTimeout(timeout);
      }
      timeout = setTimeout(later, wait);
    };
  }

  const DEFAULT_OPTIONS_LINK_ATTRIBUTES = {
    attrs: {
      target: '_blank',
      rel: 'noopener',
    },
  };

  // 定义组件选项类型
  interface Options {
    markdownIt?: {
      linkify?: boolean;
      [key: string]: any;
    };
    linkAttributes?: {
      attrs: {
        target: string;
        rel: string;
      };
    };
  }

  export default defineComponent({
    name: 'MarkdownAgentContainer',
    props: {
      content: {
        type: String,
        default: '',
      },
      options: {
        type: Object as () => Options,
        default() {
          return {
            markdownIt: {
              linkify: true,
            },
            linkAttributes: DEFAULT_OPTIONS_LINK_ATTRIBUTES,
          };
        },
      },
    },
    emits: ['render-complete'],
    data() {
      const optMarkdownIt = this.options.markdownIt;

      const md = new MarkdownIt(optMarkdownIt)
        .use(MarkdownPluginHighlight)
        .use(MarkdownPluginEcharts)
        .use(MarkdownItContainer);
      return {
        md,
        showViewer: false,
        index: 0,
        urlList: [] as string[],
        renderECharts: () => {}, // 初始化 renderECharts 方法
      };
    },
    created() {
      // 创建防抖版本的ECharts渲染函数
      this.renderECharts = debounce(() => {
        // render echarts - 只有当内容完整时才渲染
        const echartsElements = document.querySelectorAll('.md-echarts');
        echartsElements.forEach(element => {
          try {
            const content = element.textContent;
            if (!content || content.trim() === '') {
              return;
            }
            // 再次验证JSON结构是否完整
            const hasValidJson =
              /\{[\s\S]*\}/.test(content) &&
              content.match(/\{/g)?.length === content.match(/\}/g)?.length;
            if (hasValidJson) {
              const options = JSON.parse(content);
              if (!options.color) {
                options.color = EXTENDED_COLORS;
              }
              const existingChart = echarts.getInstanceByDom(element);
              if (existingChart) {
                // 复用已存在的图表实例，避免重复初始化导致的内存泄漏
                existingChart.setOption(options, true);
              } else {
                const chart = echarts.init(element);
                chart.setOption(options);
              }
            } else {
              // 如果JSON不完整，不做任何处理，保持原始状态
              console.log(
                'ECharts configuration is incomplete, skipping rendering',
                element.textContent,
              );
            }
          } catch (e) {
            // 只在控制台记录错误，不影响用户界面
            console.error('ECharts rendering error:', e);
            // 不替换元素，保持原始内容，等待完整数据
          }
        });
      }, 500); // 500毫秒内不重复检查
    },

    watch: {
      content: {
        immediate: true,
        handler(val: string) {
          this.$nextTick(() => {
            const container = this.$refs['markdown-agent-container'] as HTMLElement;
            if (container) {
              container.innerHTML = this.md.render(val);
              // 调用防抖后的ECharts渲染函数
              this.renderECharts();
              const list: string[] = [];
              this.urlList = list;
              // emit event
              this.$emit('render-complete');
            }
          });
        },
      },
    },
    methods: {
      use(plugin: any, options?: any) {
        this.md.use(plugin, options);
      },
      get() {
        return this.md;
      },
    },
  });
</script>

<style scoped>
  .markdown-container {
    width: 100%;
    /* 确保样式优先级，防止被父容器样式覆盖 */
    line-height: 1.4 !important;
  }

  .markdown-content {
    font-size: 0.85em;
    line-height: 1.4 !important;
    color: var(--text-primary);
    word-wrap: break-word;
    white-space: normal;
    font-family: inherit;
  }

  .markdown-content :deep(h1),
  .markdown-content :deep(h2),
  .markdown-content :deep(h3),
  .markdown-content :deep(h4),
  .markdown-content :deep(h5),
  .markdown-content :deep(h6) {
    margin-top: 16px;
    margin-bottom: 10px;
    font-weight: 600;
    line-height: 1.2;
  }

  .markdown-content :deep(h1) {
    font-size: 2em;
    border-bottom: 1px solid var(--border-glass);
    padding-bottom: 0.3em;
  }

  .markdown-content :deep(h2) {
    font-size: 1.5em;
    border-bottom: 1px solid var(--border-glass);
    padding-bottom: 0.3em;
  }

  .markdown-content :deep(h3) {
    font-size: 1.25em;
  }

  .markdown-content :deep(h4) {
    font-size: 1em;
  }

  .markdown-content :deep(h5) {
    font-size: 0.875em;
  }

  .markdown-content :deep(h6) {
    font-size: 0.85em;
    color: var(--text-secondary);
  }

  .markdown-content :deep(p) {
    margin-top: 0 !important;
    margin-bottom: 8px !important;
    line-height: 1.4 !important;
  }

  .markdown-content :deep(ul),
  .markdown-content :deep(ol) {
    margin-top: 0 !important;
    margin-bottom: 8px !important;
    padding-left: 1.5em;
    line-height: 1.4 !important;
  }

  .markdown-content :deep(li) {
    margin-bottom: 0.15em !important;
    line-height: 1.4 !important;
  }

  .markdown-content :deep(li > p) {
    margin-top: 6px !important;
    margin-bottom: 6px !important;
    line-height: 1.4 !important;
  }

  .markdown-content :deep(.code-block-wrapper) {
    margin: 10px 0;
    border: 1px solid var(--border-glass);
    border-radius: var(--radius-md);
    overflow: hidden;
    background: rgba(15, 23, 42, 0.6);
  }

  .markdown-content :deep(.code-block-header) {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: rgba(15, 23, 42, 0.6);
    padding: 6px 10px;
    border-bottom: 1px solid var(--border-glass);
    font-size: 11px;
  }

  .markdown-content :deep(.code-language) {
    color: var(--text-secondary);
    font-weight: 600;
    font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
    font-size: 10px;
    text-transform: uppercase;
  }

  .markdown-content :deep(.code-copy-button) {
    background: transparent;
    border: 1px solid var(--border-glass);
    padding: 3px 10px;
    border-radius: var(--radius-sm);
    font-size: 10px;
    cursor: pointer;
    transition: all 0.2s;
    color: var(--text-primary);
  }

  .markdown-content :deep(.code-copy-button:hover) {
    background: var(--bg-glass-hover);
    border-color: var(--border-glass-hover);
  }

  .markdown-content :deep(.code-copy-button.copied) {
    background: #22c55e;
    border-color: #22c55e;
    color: white;
  }

  .markdown-content :deep(pre) {
    margin: 0;
    padding: 10px;
    overflow: auto;
    background: rgba(15, 23, 42, 0.6);
    font-size: 11px;
    line-height: 1.35;
  }

  .markdown-content :deep(pre code) {
    display: block;
    padding: 0;
    margin: 0;
    background: transparent;
    border: none;
    font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  }

  .markdown-content :deep(.inline-code),
  .markdown-content :deep(code:not(pre code)) {
    background: rgba(15, 23, 42, 0.6);
    border: 1px solid var(--border-glass);
    border-radius: 4px;
    padding: 2px 6px;
    font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
    font-size: 85%;
    color: #d946ef;
  }

  .markdown-content :deep(blockquote) {
    padding: 0 0.75em;
    color: var(--text-secondary);
    border-left: 0.25em solid var(--border-glass);
    margin: 0 0 10px 0;
  }

  .markdown-content :deep(blockquote > :first-child) {
    margin-top: 0;
  }

  .markdown-content :deep(blockquote > :last-child) {
    margin-bottom: 0;
  }

  .markdown-content :deep(table) {
    border-collapse: collapse;
    border-spacing: 0;
    width: 100%;
    margin: 10px 0;
    display: block;
    overflow-x: auto;
  }

  .markdown-content :deep(thead) {
    display: table-header-group;
  }

  .markdown-content :deep(tbody) {
    display: table-row-group;
  }

  .markdown-content :deep(tr) {
    display: table-row;
    border-top: 1px solid var(--border-glass);
  }

  .markdown-content :deep(tr:nth-child(2n)) {
    background-color: rgba(15, 23, 42, 0.4);
  }

  .markdown-content :deep(th),
  .markdown-content :deep(td) {
    display: table-cell;
    padding: 4px 10px;
    border: 1px solid var(--border-glass);
  }

  .markdown-content :deep(th) {
    font-weight: 600;
    background-color: rgba(15, 23, 42, 0.6);
  }

  .markdown-content :deep(a) {
    color: var(--accent-color);
    text-decoration: none;
  }

  .markdown-content :deep(a:hover) {
    text-decoration: underline;
  }

  .markdown-content :deep(hr) {
    height: 1px;
    padding: 0;
    margin: 16px 0;
    background-color: transparent;
    border: 0;
    border-top: 1px dashed var(--border-glass);
  }

  .markdown-content :deep(img) {
    max-width: 100%;
    height: auto;
    border-style: none;
    margin: 10px 0;
  }

  .markdown-content :deep(strong) {
    font-weight: 600;
  }

  .markdown-content :deep(em) {
    font-style: italic;
  }

  .markdown-content :deep(del) {
    text-decoration: line-through;
  }
</style>
