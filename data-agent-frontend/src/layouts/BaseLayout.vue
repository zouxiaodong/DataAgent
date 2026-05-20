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
  <div class="base-layout">
    <!-- 现代化头部导航 -->
    <header class="page-header">
      <div class="header-content">
        <div class="brand-section">
          <div class="brand-logo">
            <i class="bi bi-robot"></i>
            <span class="brand-text">宁西高速智能问数</span>
          </div>
          <nav class="header-nav">
            <div class="nav-item" :class="{ active: isAgentPage() }" @click="goToAgentList">
              <i class="bi bi-grid-3x3-gap"></i>
              <span>智能体列表</span>
            </div>
            <div class="nav-item" :class="{ active: isModelConfigPage() }" @click="goToModelConfig">
              <i class="bi bi-gear"></i>
              <span>模型配置</span>
            </div>
          </nav>
        </div>
      </div>
    </header>

    <!-- 页面内容区域 -->
    <main class="page-content">
      <slot></slot>
    </main>
  </div>
</template>

<script>
  import { useRouter } from 'vue-router';

  export default {
    name: 'BaseLayout',
    setup() {
      const router = useRouter();

      // 导航方法
      const goToAgentList = () => {
        router.push('/agents');
      };

      const goToModelConfig = () => {
        router.push('/model-config');
      };

      const isAgentPage = () => {
        return (
          router.currentRoute.value.name === 'AgentList' ||
          router.currentRoute.value.name === 'AgentDetail' ||
          router.currentRoute.value.name === 'AgentCreate' ||
          router.currentRoute.value.name === 'AgentRun'
        );
      };

      const isModelConfigPage = () => {
        return router.currentRoute.value.name === 'ModelConfig';
      };

      return {
        goToAgentList,
        goToModelConfig,
        isAgentPage,
        isModelConfigPage,
      };
    },
  };
</script>

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
