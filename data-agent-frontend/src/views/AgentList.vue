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
  <BaseLayout>
    <div class="agent-list-page">
      <main class="main-content">
        <!-- Page Header -->
        <div class="page-header">
          <div class="header-left">
            <h1 class="page-title">智能体管理中心</h1>
            <p class="page-subtitle">创建和管理您的AI智能体，让数据分析更智能</p>
          </div>
          <el-button type="primary" :icon="Plus" @click="goToCreateAgent" size="large" class="create-btn">
            创建智能体
          </el-button>
        </div>

        <!-- Stats Row -->
        <div class="stats-row">
          <div class="stat-card" @click="setFilter('all')" :class="{ active: activeFilter === 'all' }">
            <div class="stat-value">{{ agents.length }}</div>
            <div class="stat-label">全部智能体</div>
          </div>
          <div class="stat-card" @click="setFilter('published')" :class="{ active: activeFilter === 'published' }">
            <div class="stat-value published">{{ publishedCount }}</div>
            <div class="stat-label">已发布</div>
          </div>
          <div class="stat-card" @click="setFilter('draft')" :class="{ active: activeFilter === 'draft' }">
            <div class="stat-value draft">{{ draftCount }}</div>
            <div class="stat-label">草稿</div>
          </div>
          <div class="stat-card" @click="setFilter('offline')" :class="{ active: activeFilter === 'offline' }">
            <div class="stat-value offline">{{ offlineCount }}</div>
            <div class="stat-label">已下线</div>
          </div>
        </div>

        <!-- Filter Bar -->
        <div class="filter-bar">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索智能体名称、ID或描述..."
            size="large"
            :prefix-icon="Search"
            clearable
            class="search-input"
          />
          <el-button :icon="Refresh" @click="loadAgents" size="large" circle class="refresh-btn" />
        </div>

        <!-- Agents Grid -->
        <div class="agents-grid" v-if="!loading">
          <div
            v-for="agent in filteredAgents"
            :key="agent.id"
            class="agent-card"
            @click="enterAgent(agent.id)"
          >
            <div class="card-inner">
              <!-- Delete Button -->
              <div class="delete-btn" @click.stop="handleDeleteAgent(agent)">
                <el-icon><Delete /></el-icon>
              </div>

              <!-- Status Tag -->
              <el-tag :type="getStatusTagType(agent.status)" size="small" class="status-tag">
                {{ getStatusText(agent.status) }}
              </el-tag>

              <!-- Avatar -->
              <div class="agent-avatar">
                <el-avatar :size="56" :src="agent.avatar">
                  {{ agent.name.charAt(0) }}
                </el-avatar>
              </div>

              <!-- Info -->
              <div class="agent-info">
                <h3 class="agent-name">{{ agent.name }}</h3>
                <p class="agent-description">{{ agent.description }}</p>
                <div class="agent-meta">
                  <span class="agent-id">ID: {{ agent.id }}</span>
                  <span class="agent-time">{{ formatTime(agent.updateTime) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="loading-state">
          <el-skeleton :rows="3" animated />
        </div>

        <!-- Empty State -->
        <div v-if="!loading && filteredAgents.length === 0" class="empty-state">
          <el-empty description="暂无智能体">
            <template #image>
              <el-icon size="60"><Grid /></el-icon>
            </template>
            <el-button type="primary" :icon="Plus" @click="goToCreateAgent">创建智能体</el-button>
          </el-empty>
        </div>
      </main>
    </div>
  </BaseLayout>
</template>

<script lang="ts">
  import { defineComponent, ref, computed, onMounted } from 'vue';
  import { useRouter } from 'vue-router';
  import { ElMessage, ElMessageBox } from 'element-plus';
  import {
    Grid,
    Delete,
    Search,
    Refresh,
    Plus,
  } from '@element-plus/icons-vue';
  import BaseLayout from '@/layouts/BaseLayout.vue';
  import agentService from '@/services/agent';
  import type { Agent } from '@/services/agent';

  export default defineComponent({
    name: 'AgentList',
    components: {
      BaseLayout,
      Grid,
      Delete,
    },
    setup() {
      const router = useRouter();
      const loading = ref(true);
      const activeFilter = ref('all');
      const searchKeyword = ref('');
      const agents = ref<Agent[]>([]);

      const publishedCount = computed(
        () => agents.value.filter((a: Agent) => a.status === 'published').length,
      );
      const draftCount = computed(
        () => agents.value.filter((a: Agent) => a.status === 'draft').length,
      );
      const offlineCount = computed(
        () => agents.value.filter((a: Agent) => a.status === 'offline').length,
      );

      const filteredAgents = computed(() => {
        let filtered = agents.value;
        if (activeFilter.value !== 'all') {
          filtered = filtered.filter((agent: Agent) => agent.status === activeFilter.value);
        }
        if (searchKeyword.value.trim()) {
          const keyword = searchKeyword.value.toLowerCase();
          filtered = filtered.filter(
            (agent: Agent) =>
              agent.name.toLowerCase().includes(keyword) ||
              agent.description.toLowerCase().includes(keyword) ||
              agent.id.toString().includes(keyword),
          );
        }
        return filtered;
      });

      const setFilter = (filter: string) => {
        activeFilter.value = filter;
      };

      const loadAgents = async () => {
        loading.value = true;
        try {
          const response = await agentService.list();
          agents.value = response || [];
        } catch (error) {
          ElMessage.error('获取智能体列表失败，请检查网络！');
          agents.value = [];
        } finally {
          loading.value = false;
        }
      };

      const enterAgent = (agentId: string) => {
        router.push(`/agent/${agentId}`);
      };

      const getStatusText = (status: string) => {
        const statusMap: Record<string, string> = {
          published: '已发布',
          draft: '草稿',
          offline: '已下线',
        };
        return statusMap[status] || status;
      };

      const getStatusTagType = (status: string) => {
        const typeMap: Record<string, 'success' | 'warning' | 'info'> = {
          published: 'success',
          draft: 'warning',
          offline: 'info',
        };
        return typeMap[status] || 'info';
      };

      const formatTime = (time: string) => {
        if (!time) return '';
        return time.replace(/\//g, '/');
      };

      const goToCreateAgent = () => {
        router.push('/agent/create');
      };

      const handleDeleteAgent = async (agent: Agent) => {
        try {
          await ElMessageBox.confirm(
            `确定要删除智能体 "${agent.name}" 吗？此操作不可恢复。`,
            '删除确认',
            {
              confirmButtonText: '确定删除',
              cancelButtonText: '取消',
              type: 'warning',
            },
          );
          const success = await agentService.delete(agent.id!);
          if (success) {
            ElMessage.success('智能体删除成功');
            agents.value = agents.value.filter((a: Agent) => a.id !== agent.id);
          } else {
            ElMessage.error('智能体删除失败');
          }
        } catch (error) {
          console.log('删除操作已取消');
        }
      };

      onMounted(() => {
        loadAgents();
      });

      return {
        loading,
        activeFilter,
        searchKeyword,
        agents,
        filteredAgents,
        publishedCount,
        draftCount,
        offlineCount,
        setFilter,
        loadAgents,
        enterAgent,
        getStatusText,
        getStatusTagType,
        formatTime,
        goToCreateAgent,
        handleDeleteAgent,
        Search,
        Refresh,
        Plus,
      };
    },
  });
</script>

<style scoped>
  .agent-list-page {
    min-height: 100vh;
    background: var(--gradient-bg);
    font-family: var(--font-family);
  }

  .main-content {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem;
  }

  /* Page Header */
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
  }

  .page-title {
    font-size: 1.75rem;
    font-weight: 700;
    color: var(--text-primary);
    margin: 0 0 0.25rem 0;
    letter-spacing: -0.02em;
  }

  .page-subtitle {
    color: var(--text-secondary);
    margin: 0;
    font-size: 0.9rem;
  }

  .create-btn {
    background: var(--accent-color) !important;
    border-color: var(--accent-color) !important;
    border-radius: var(--radius-pill) !important;
    padding: 0 1.5rem !important;
    font-weight: 600 !important;
    box-shadow: 0 4px 16px rgba(96, 165, 250, 0.3) !important;
    transition: all 0.3s ease !important;
  }

  .create-btn:hover {
    transform: translateY(-2px) !important;
    box-shadow: 0 6px 24px rgba(96, 165, 250, 0.4) !important;
  }

  /* Stats Row */
  .stats-row {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 1rem;
    margin-bottom: 1.5rem;
  }

  .stat-card {
    background: var(--bg-glass);
    backdrop-filter: var(--backdrop-blur);
    -webkit-backdrop-filter: var(--backdrop-blur);
    border: 1px solid var(--border-glass);
    border-radius: var(--radius-lg);
    padding: 1.25rem;
    text-align: center;
    cursor: pointer;
    transition: all 0.3s ease;
  }

  .stat-card:hover {
    background: var(--bg-glass-hover);
    border-color: var(--border-glass-hover);
    transform: translateY(-2px);
  }

  .stat-card.active {
    border-color: var(--accent-color);
    background: var(--accent-light);
  }

  .stat-value {
    font-size: 2rem;
    font-weight: 700;
    color: var(--text-primary);
    line-height: 1;
    margin-bottom: 0.5rem;
  }

  .stat-value.published { color: var(--success-color); }
  .stat-value.draft { color: #fbbf24; }
  .stat-value.offline { color: var(--text-tertiary); }

  .stat-label {
    font-size: 0.8rem;
    color: var(--text-secondary);
    font-weight: 500;
  }

  /* Filter Bar */
  .filter-bar {
    display: flex;
    gap: 0.75rem;
    margin-bottom: 2rem;
    align-items: center;
  }

  .search-input {
    flex: 1;
  }

  .search-input :deep(.el-input__wrapper) {
    background: var(--bg-glass) !important;
    border: 1px solid var(--border-glass) !important;
    backdrop-filter: var(--backdrop-blur) !important;
    box-shadow: none !important;
    border-radius: var(--radius-lg) !important;
  }

  .search-input :deep(.el-input__inner) {
    color: var(--text-primary) !important;
  }

  .refresh-btn {
    background: var(--bg-glass) !important;
    border: 1px solid var(--border-glass) !important;
    backdrop-filter: var(--backdrop-blur) !important;
    color: var(--text-secondary) !important;
    transition: all 0.3s ease !important;
  }

  .refresh-btn:hover {
    background: var(--bg-glass-hover) !important;
    border-color: var(--border-glass-hover) !important;
    color: var(--text-primary) !important;
  }

  /* Agents Grid */
  .agents-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1.25rem;
  }

  /* Agent Card */
  .agent-card {
    background: rgba(30, 41, 59, 0.95);
    backdrop-filter: var(--backdrop-blur);
    -webkit-backdrop-filter: var(--backdrop-blur);
    border: 1px solid rgba(148, 163, 184, 0.3);
    border-radius: var(--radius-xl);
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    overflow: hidden;
    position: relative;
  }

  .agent-card:hover {
    border-color: var(--accent-color);
    box-shadow: 0 8px 32px rgba(96, 165, 250, 0.15), 0 0 0 1px rgba(96, 165, 250, 0.2);
    transform: translateY(-4px);
  }

  .card-inner {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 1.5rem;
    position: relative;
  }

  /* Delete Button */
  .delete-btn {
    position: absolute;
    top: 0.75rem;
    left: 0.75rem;
    width: 28px;
    height: 28px;
    border-radius: var(--radius-base);
    background: rgba(248, 113, 113, 0.85);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    opacity: 0;
    transition: all 0.2s ease;
    z-index: 10;
    font-size: 14px;
  }

  .delete-btn:hover {
    background: rgba(239, 68, 68, 0.95);
    transform: scale(1.1);
  }

  .agent-card:hover .delete-btn {
    opacity: 1;
  }

  /* Status Tag */
  .status-tag {
    position: absolute;
    top: 0.75rem;
    right: 0.75rem;
    z-index: 10;
  }

  /* Avatar */
  .agent-avatar {
    margin-bottom: 1rem;
  }

  .agent-avatar :deep(.el-avatar) {
    background: linear-gradient(135deg, var(--accent-color), #a78bfa) !important;
    box-shadow: 0 4px 16px rgba(96, 165, 250, 0.3);
    font-weight: 700;
    font-size: 1.25rem !important;
  }

  /* Info */
  .agent-info {
    text-align: center;
    width: 100%;
  }

  .agent-name {
    font-size: 1.1rem;
    font-weight: 700;
    color: var(--text-primary);
    margin: 0 0 0.5rem 0;
    letter-spacing: -0.01em;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .agent-description {
    color: var(--text-secondary);
    font-size: 0.85rem;
    line-height: 1.5;
    margin: 0 0 0.75rem 0;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    min-height: 2.55rem;
  }

  .agent-meta {
    display: flex;
    justify-content: center;
    gap: 1rem;
    font-size: 0.75rem;
    color: var(--text-tertiary);
    padding-top: 0.75rem;
    border-top: 1px solid rgba(148, 163, 184, 0.1);
    width: 100%;
  }

  /* Loading / Empty */
  .loading-state {
    padding: 3rem 1rem;
  }

  .empty-state {
    padding: 4rem 1rem;
  }

  /* Responsive */
  @media (max-width: 1024px) {
    .agents-grid {
      grid-template-columns: repeat(2, 1fr);
    }
  }

  @media (max-width: 768px) {
    .main-content {
      padding: 1rem;
    }

    .page-header {
      flex-direction: column;
      align-items: flex-start;
      gap: 1rem;
    }

    .create-btn {
      width: 100%;
    }

    .stats-row {
      grid-template-columns: repeat(2, 1fr);
    }

    .agents-grid {
      grid-template-columns: 1fr;
    }

    .filter-bar {
      flex-direction: column;
    }

    .refresh-btn {
      align-self: flex-end;
    }
  }
</style>
