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
<!-- 提示词优化配置组件 -->
<template>
  <div class="prompt-optimization-config">
    <!-- 消息提示 -->
    <div v-if="message.show" class="message-toast" :class="message.type">
      <span>{{ message.text }}</span>
      <button class="message-close" @click="hideMessage">×</button>
    </div>
    <div class="config-header">
      <h3>增强式Prompt优化配置</h3>
      <p class="config-description">
        配置的Prompt仅用作效果优化，支持多个提示词配置，在原始模板基础上进行增强。示例配置：
      </p>
      <ul class="optimization-tips">
        <li>1. 查询的年销售额精确到小数点后两位。</li>
        <li>2. 报告格式第一章节请先总结年销售额</li>
      </ul>
    </div>

    <!-- 智能体Prompt -->
    <div class="agent-prompt-section">
      <h4>智能体Prompt</h4>
      <div class="prompt-display">
        {{
          agentPrompt || '你是一个销售数据分析专家，能够帮助用户分析销售趋势，客户行为和业务指标。'
        }}
      </div>
    </div>

    <!-- 优化配置列表 -->
    <div class="optimization-configs">
      <div class="config-list-header">
        <h4>优化配置列表</h4>
        <div class="header-actions">
          <button
            v-if="optimizationConfigs.length > 0"
            class="batch-action-btn"
            @click="showBatchActions = !showBatchActions"
          >
            <i class="icon-settings"></i>
            批量操作
          </button>
          <button class="add-config-btn" @click="showAddConfigDialog = true">
            <i class="icon-plus"></i>
            添加优化配置
          </button>
        </div>
      </div>

      <!-- 批量操作面板 -->
      <div v-if="showBatchActions" class="batch-actions-panel">
        <div class="batch-actions-content">
          <div class="batch-selection">
            <input
              type="checkbox"
              :checked="isAllSelected"
              :indeterminate="isIndeterminate"
              @change="toggleSelectAll"
              class="select-all-checkbox"
            />
            <span class="batch-info">
              {{ isAllSelected ? '已全选' : `已选择 ${selectedConfigs.length} 个配置` }}
            </span>
          </div>
          <div class="batch-buttons">
            <button
              class="batch-btn enable"
              @click="batchEnable"
              :disabled="selectedConfigs.length === 0"
            >
              批量启用
            </button>
            <button
              class="batch-btn disable"
              @click="batchDisable"
              :disabled="selectedConfigs.length === 0"
            >
              批量禁用
            </button>
            <button class="batch-btn cancel" @click="clearSelection">取消选择</button>
          </div>
        </div>
      </div>

      <div v-if="optimizationConfigs.length === 0" class="empty-state">
        <p>暂无优化配置，点击"添加优化配置"开始配置</p>
      </div>

      <div v-else class="config-list">
        <div
          v-for="config in optimizationConfigs"
          :key="config.id"
          class="config-item"
          :class="{ disabled: !config.enabled, selected: selectedConfigs.includes(config.id) }"
        >
          <div class="config-header">
            <div class="config-info">
              <input
                type="checkbox"
                :value="config.id"
                v-model="selectedConfigs"
                class="config-checkbox"
              />
              <span class="config-name">{{ config.name }}</span>
              <span class="config-priority" v-if="config.priority !== undefined">
                优先级: {{ config.priority }}
              </span>
            </div>
            <div class="config-actions">
              <button
                class="toggle-btn"
                :class="{ active: config.enabled }"
                @click="toggleConfig(config)"
              >
                {{ config.enabled ? '已启用' : '已禁用' }}
              </button>
              <button class="edit-btn" @click="editConfig(config)">编辑</button>
              <button class="priority-btn" @click="handleShowPriorityDialog(config)">优先级</button>
              <button class="delete-btn" @click="deleteConfig(config.id)">删除</button>
            </div>
          </div>
          <div class="config-content">
            <p class="config-description">{{ config.description }}</p>
            <div class="optimization-prompt">
              {{ config.optimizationPrompt }}
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 添加/编辑配置对话框 -->
    <div v-if="showAddConfigDialog || editingConfig" class="dialog-overlay" @click="closeDialog">
      <div class="dialog-content" @click.stop>
        <div class="dialog-header">
          <h3>{{ editingConfig ? '编辑优化配置' : '添加优化配置' }}</h3>
          <button class="close-btn" @click="closeDialog">×</button>
        </div>
        <form @submit.prevent="saveConfig" class="config-form">
          <div class="form-group">
            <label for="configName">配置名称</label>
            <input
              id="configName"
              v-model="formData.name"
              type="text"
              placeholder="请输入配置名称"
              required
            />
          </div>

          <div class="form-group">
            <label for="description">配置描述</label>
            <input
              id="description"
              v-model="formData.description"
              type="text"
              placeholder="请输入配置描述"
            />
          </div>

          <div class="form-group">
            <label for="optimizationPrompt">优化提示词内容</label>
            <textarea
              id="optimizationPrompt"
              v-model="formData.optimizationPrompt"
              rows="6"
              placeholder="请输入优化提示词内容，支持模板变量如 {user_requirements_and_plan}"
              required
            ></textarea>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="priority">优先级</label>
              <input
                id="priority"
                v-model.number="formData.priority"
                type="number"
                min="0"
                max="100"
                placeholder="0-100，数字越大优先级越高"
              />
            </div>
            <div class="form-group">
              <label for="displayOrder">显示顺序</label>
              <input
                id="displayOrder"
                v-model.number="formData.displayOrder"
                type="number"
                min="0"
                placeholder="显示顺序，数字越小越靠前"
              />
            </div>
          </div>

          <div class="form-actions">
            <button type="button" class="cancel-btn" @click="closeDialog">取消</button>
            <button type="submit" class="save-btn">保存配置</button>
          </div>
        </form>
      </div>
    </div>

    <!-- 优先级设置对话框 -->
    <div v-if="showPriorityDialog" class="dialog-overlay" @click="closePriorityDialog">
      <div class="dialog-content" @click.stop>
        <div class="dialog-header">
          <h3>设置优先级</h3>
          <button class="close-btn" @click="closePriorityDialog">×</button>
        </div>
        <form @submit.prevent="updatePriority" class="priority-form">
          <div class="form-group">
            <label for="priorityValue">优先级 (0-100)</label>
            <input
              id="priorityValue"
              v-model.number="priorityForm.priority"
              type="number"
              min="0"
              max="100"
              placeholder="数字越大优先级越高"
              required
            />
            <p class="form-hint">优先级越高，该配置在多个配置中的执行顺序越靠前</p>
          </div>
          <div class="form-group">
            <label for="displayOrderValue">显示顺序</label>
            <input
              id="displayOrderValue"
              v-model.number="priorityForm.displayOrder"
              type="number"
              min="0"
              placeholder="数字越小越靠前"
            />
            <p class="form-hint">控制配置在列表中的显示顺序</p>
          </div>
          <div class="form-actions">
            <button type="button" class="cancel-btn" @click="closePriorityDialog">取消</button>
            <button type="submit" class="save-btn">保存</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'AgentPromptConfig',
    props: {
      agentId: {
        type: [String, Number],
        required: true,
      },
      promptType: {
        type: String,
        default: 'report-generator',
      },
      agentPrompt: {
        type: String,
        default: '',
      },
    },
    data() {
      return {
        optimizationConfigs: [],
        showAddConfigDialog: false,
        editingConfig: null,
        showBatchActions: false,
        showPriorityDialog: false,
        selectedConfigs: [],
        editingPriorityConfig: null,
        formData: {
          name: '',
          description: '',
          optimizationPrompt: '',
          priority: 0,
          displayOrder: 0,
        },
        priorityForm: {
          priority: 0,
          displayOrder: 0,
        },
        loading: false,
        message: {
          show: false,
          text: '',
          type: 'success',
        },
      };
    },
    computed: {
      // 是否全选
      isAllSelected() {
        return (
          this.optimizationConfigs.length > 0 &&
          this.selectedConfigs.length === this.optimizationConfigs.length
        );
      },
      // 是否部分选择（半选状态）
      isIndeterminate() {
        return (
          this.selectedConfigs.length > 0 &&
          this.selectedConfigs.length < this.optimizationConfigs.length
        );
      },
    },
    mounted() {
      this.loadOptimizationConfigs();
    },
    methods: {
      async loadOptimizationConfigs() {
        try {
          this.loading = true;
          const query = this.agentId ? `?agentId=${this.agentId}` : '';
          const response = await fetch(
            `/api/prompt-config/list-by-type/${this.promptType}${query}`,
          );
          const result = await response.json();
          if (result.success) {
            this.optimizationConfigs = result.data || [];
            // 如果配置列表为空，自动关闭批量操作面板
            if (this.optimizationConfigs.length === 0) {
              this.showBatchActions = false;
              this.selectedConfigs = [];
            }
          }
        } catch (error) {
          console.error('加载优化配置失败:', error);
          this.showMessage('加载优化配置失败', 'error');
        } finally {
          this.loading = false;
        }
      },

      async saveConfig() {
        try {
          const configData = {
            ...this.formData,
            promptType: this.promptType,
            agentId: this.agentId ? Number(this.agentId) : null,
            enabled: true,
            creator: 'user',
            priority: this.formData.priority || 0,
            displayOrder: this.formData.displayOrder || 0,
          };

          if (this.editingConfig) {
            configData.id = this.editingConfig.id;
          }

          const response = await fetch('/api/prompt-config/save', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify(configData),
          });

          const result = await response.json();
          if (result.success) {
            this.showMessage(result.message || '保存成功', 'success');
            this.closeDialog();
            this.loadOptimizationConfigs();
          } else {
            this.showMessage(result.message || '保存失败', 'error');
          }
        } catch (error) {
          console.error('保存配置失败:', error);
          this.showMessage('保存配置失败', 'error');
        }
      },

      async toggleConfig(config) {
        try {
          const url = config.enabled
            ? `/api/prompt-config/${config.id}/disable`
            : `/api/prompt-config/${config.id}/enable`;

          const response = await fetch(url, { method: 'POST' });
          const result = await response.json();

          if (result.success) {
            this.showMessage(result.message, 'success');
            this.loadOptimizationConfigs();
          } else {
            this.showMessage(result.message, 'error');
          }
        } catch (error) {
          console.error('切换配置状态失败:', error);
          this.showMessage('操作失败', 'error');
        }
      },

      async deleteConfig(configId) {
        if (!confirm('确定要删除这个优化配置吗？')) {
          return;
        }

        try {
          const response = await fetch(`/api/prompt-config/${configId}`, {
            method: 'DELETE',
          });
          const result = await response.json();

          if (result.success) {
            this.showMessage(result.message, 'success');
            this.loadOptimizationConfigs();
            // 删除后从选中列表中移除
            this.selectedConfigs = this.selectedConfigs.filter(id => id !== configId);
          } else {
            this.showMessage(result.message, 'error');
          }
        } catch (error) {
          console.error('删除配置失败:', error);
          this.showMessage('删除配置失败', 'error');
        }
      },

      editConfig(config) {
        this.editingConfig = config;
        this.formData = {
          name: config.name,
          description: config.description,
          optimizationPrompt: config.optimizationPrompt,
          priority: config.priority || 0,
          displayOrder: config.displayOrder || 0,
        };
      },

      closeDialog() {
        this.showAddConfigDialog = false;
        this.editingConfig = null;
        this.formData = {
          name: '',
          description: '',
          optimizationPrompt: '',
          priority: 0,
          displayOrder: 0,
        };
      },

      // 批量操作相关方法
      async batchEnable() {
        if (this.selectedConfigs.length === 0) return;

        try {
          const response = await fetch('/api/prompt-config/batch-enable', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify(this.selectedConfigs),
          });

          const result = await response.json();
          if (result.success) {
            this.showMessage(result.message, 'success');
            this.loadOptimizationConfigs();
            this.clearSelection();
          } else {
            this.showMessage(result.message, 'error');
          }
        } catch (error) {
          console.error('批量启用失败:', error);
          this.showMessage('批量启用失败', 'error');
        }
      },

      async batchDisable() {
        if (this.selectedConfigs.length === 0) return;

        try {
          const response = await fetch('/api/prompt-config/batch-disable', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify(this.selectedConfigs),
          });

          const result = await response.json();
          if (result.success) {
            this.showMessage(result.message, 'success');
            this.loadOptimizationConfigs();
            this.clearSelection();
          } else {
            this.showMessage(result.message, 'error');
          }
        } catch (error) {
          console.error('批量禁用失败:', error);
          this.showMessage('批量禁用失败', 'error');
        }
      },

      clearSelection() {
        this.selectedConfigs = [];
        this.showBatchActions = false;
      },

      // 全选/取消全选
      toggleSelectAll() {
        if (this.isAllSelected) {
          // 如果已全选，则取消全选
          this.selectedConfigs = [];
        } else {
          // 如果未全选，则全选所有配置
          this.selectedConfigs = this.optimizationConfigs.map(config => config.id);
        }
      },

      // 优先级相关方法
      handleShowPriorityDialog(config) {
        this.editingPriorityConfig = config;
        this.priorityForm = {
          priority: config.priority || 0,
          displayOrder: config.displayOrder || 0,
        };
        this.showPriorityDialog = true;
      },

      async updatePriority() {
        try {
          const response = await fetch(
            `/api/prompt-config/${this.editingPriorityConfig.id}/priority`,
            {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json',
              },
              body: JSON.stringify({ priority: this.priorityForm.priority }),
            },
          );

          const result = await response.json();
          if (result.success) {
            this.showMessage('优先级更新成功', 'success');
            this.loadOptimizationConfigs();
            this.closePriorityDialog();
          } else {
            this.showMessage(result.message, 'error');
          }
        } catch (error) {
          console.error('更新优先级失败:', error);
          this.showMessage('更新优先级失败', 'error');
        }
      },

      closePriorityDialog() {
        this.showPriorityDialog = false;
        this.editingPriorityConfig = null;
        this.priorityForm = {
          priority: 0,
          displayOrder: 0,
        };
      },

      showMessage(text, type = 'success') {
        this.message = {
          show: true,
          text,
          type,
        };
        setTimeout(() => {
          this.message.show = false;
        }, 3000);
      },

      hideMessage() {
        this.message.show = false;
      },
    },
  };
</script>

<style scoped>
  .prompt-optimization-config {
    padding: 20px;
    background: var(--bg-glass);
    backdrop-filter: var(--backdrop-blur);
    -webkit-backdrop-filter: var(--backdrop-blur);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-glass);
    box-shadow: var(--shadow-sm);
  }

  .message-toast {
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 12px 16px;
    border-radius: var(--radius-md);
    color: white;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 8px;
    z-index: 1000;
    max-width: 300px;
    box-shadow: var(--shadow-lg);
  }

  .message-toast.success {
    background: var(--success-color);
  }

  .message-toast.error {
    background: #ef4444;
  }

  .message-close {
    background: none;
    border: none;
    color: white;
    cursor: pointer;
    font-size: 16px;
    padding: 0;
    margin-left: auto;
  }

  .config-header {
    margin-bottom: 24px;
  }

  .config-header h3 {
    margin: 0 0 8px 0;
    color: var(--primary-color);
    font-size: 18px;
    font-weight: 700;
  }

  .config-description {
    color: var(--text-secondary);
    margin-bottom: 12px;
    line-height: 1.5;
  }

  .optimization-tips {
    margin: 0;
    padding-left: 20px;
    color: var(--text-tertiary);
  }

  .optimization-tips li {
    margin-bottom: 4px;
  }

  .agent-prompt-section {
    margin-bottom: 24px;
    padding: 16px;
    background: var(--bg-glass);
    backdrop-filter: var(--backdrop-blur);
    -webkit-backdrop-filter: var(--backdrop-blur);
    border: 1px solid var(--border-glass);
    border-radius: var(--radius-md);
  }

  .agent-prompt-section h4 {
    margin: 0 0 12px 0;
    color: var(--primary-color);
    font-size: 14px;
    font-weight: 600;
  }

  .prompt-display {
    color: var(--text-primary);
    line-height: 1.5;
    font-size: 14px;
  }

  .optimization-configs {
    border-top: 1px solid var(--border-glass);
    padding-top: 24px;
  }

  .config-list-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
  }

  .header-actions {
    display: flex;
    gap: 12px;
    align-items: center;
  }

  .config-list-header h4 {
    margin: 0;
    color: var(--primary-color);
    font-size: 16px;
    font-weight: 700;
  }

  .batch-action-btn,
  .add-config-btn {
    padding: 8px 16px;
    background: var(--accent-color);
    color: white;
    border: none;
    border-radius: var(--radius-sm);
    cursor: pointer;
    font-size: 14px;
    transition: all 0.2s;
  }

  .batch-action-btn:hover,
  .add-config-btn:hover {
    background: var(--accent-hover);
  }

  .batch-action-btn {
    background: var(--success-color);
  }

  .batch-action-btn:hover {
    background: #16a34a;
  }

  .empty-state {
    text-align: center;
    padding: 40px 20px;
    color: var(--text-tertiary);
  }

  .config-list {
    space-y: 12px;
  }

  .config-item {
    border: 1px solid var(--border-glass);
    border-radius: var(--radius-md);
    padding: 16px;
    margin-bottom: 12px;
    transition: all 0.2s;
    background: var(--bg-glass);
    backdrop-filter: var(--backdrop-blur);
    -webkit-backdrop-filter: var(--backdrop-blur);
  }

  .config-item.disabled {
    opacity: 0.6;
    background: var(--bg-glass-hover);
  }

  .config-item.selected {
    border-color: var(--accent-color);
    background: var(--accent-light);
  }

  .config-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
  }

  .config-info {
    display: flex;
    gap: 12px;
    align-items: center;
  }

  .config-checkbox {
    margin-right: 8px;
  }

  .config-name {
    font-weight: 600;
    color: var(--primary-color);
  }

  .config-priority {
    font-size: 12px;
    color: var(--text-secondary);
    background: var(--bg-glass-hover);
    padding: 2px 6px;
    border-radius: 4px;
  }

  .config-actions {
    display: flex;
    gap: 8px;
  }

  .toggle-btn,
  .edit-btn,
  .priority-btn,
  .delete-btn {
    padding: 4px 8px;
    border: 1px solid var(--border-glass);
    background: var(--bg-glass);
    backdrop-filter: var(--backdrop-blur);
    -webkit-backdrop-filter: var(--backdrop-blur);
    border-radius: var(--radius-sm);
    cursor: pointer;
    font-size: 12px;
    transition: all 0.2s;
    color: var(--text-primary);
  }

  .toggle-btn.active {
    background: var(--success-color);
    color: white;
    border-color: var(--success-color);
  }

  .edit-btn:hover {
    border-color: var(--accent-color);
    color: var(--accent-color);
  }

  .priority-btn:hover {
    border-color: var(--highlight-color);
    color: var(--highlight-color);
  }

  .delete-btn:hover {
    border-color: #ef4444;
    color: #ef4444;
  }

  .config-content {
    border-top: 1px solid var(--border-glass);
    padding-top: 12px;
  }

  .config-description {
    margin-bottom: 8px;
    color: var(--text-secondary);
    font-size: 14px;
  }

  .optimization-prompt {
    background: var(--bg-glass-hover);
    backdrop-filter: var(--backdrop-blur);
    -webkit-backdrop-filter: var(--backdrop-blur);
    padding: 12px;
    border-radius: var(--radius-sm);
    color: var(--text-primary);
    font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
    font-size: 13px;
    line-height: 1.4;
    white-space: pre-wrap;
    word-break: break-word;
  }

  .dialog-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
  }

  .dialog-content {
    background: var(--bg-glass);
    backdrop-filter: var(--backdrop-blur);
    -webkit-backdrop-filter: var(--backdrop-blur);
    border: 1px solid var(--border-glass);
    border-radius: var(--radius-lg);
    width: 90%;
    max-width: 600px;
    max-height: 90vh;
    overflow-y: auto;
  }

  .dialog-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 20px 0 20px;
    border-bottom: 1px solid var(--border-glass);
  }

  .dialog-header h3 {
    margin: 0;
    color: var(--primary-color);
  }

  .close-btn {
    background: none;
    border: none;
    font-size: 24px;
    cursor: pointer;
    color: var(--text-tertiary);
    padding: 0;
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .close-btn:hover {
    color: var(--primary-color);
  }

  .config-form {
    padding: 20px;
  }

  .form-group {
    margin-bottom: 16px;
  }

  .form-group label {
    display: block;
    margin-bottom: 4px;
    color: var(--text-primary);
    font-weight: 600;
  }

  .form-group input,
  .form-group select,
  .form-group textarea {
    width: 100%;
    padding: 8px 12px;
    border: 1px solid var(--border-glass);
    border-radius: var(--radius-sm);
    font-size: 14px;
    background: var(--bg-glass);
    backdrop-filter: var(--backdrop-blur);
    -webkit-backdrop-filter: var(--backdrop-blur);
    color: var(--text-primary);
    transition: border-color 0.2s;
  }

  .form-group input:focus,
  .form-group select:focus,
  .form-group textarea:focus {
    outline: none;
    border-color: var(--accent-color);
    box-shadow: var(--shadow-glow);
  }

  .form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    margin-top: 24px;
    padding-top: 16px;
    border-top: 1px solid var(--border-glass);
  }

  .cancel-btn,
  .save-btn {
    padding: 8px 16px;
    border: 1px solid var(--border-glass);
    border-radius: var(--radius-sm);
    cursor: pointer;
    font-size: 14px;
    transition: all 0.2s;
  }

  .cancel-btn {
    background: var(--bg-glass);
    backdrop-filter: var(--backdrop-blur);
    -webkit-backdrop-filter: var(--backdrop-blur);
    color: var(--text-secondary);
  }

  .cancel-btn:hover {
    border-color: var(--border-glass-hover);
  }

  .save-btn {
    background: var(--accent-color);
    color: white;
    border-color: var(--accent-color);
  }

  .save-btn:hover {
    background: var(--accent-hover);
  }

  .batch-actions-panel {
    background: var(--bg-glass);
    backdrop-filter: var(--backdrop-blur);
    -webkit-backdrop-filter: var(--backdrop-blur);
    border: 1px solid var(--border-glass);
    border-radius: var(--radius-md);
    padding: 12px;
    margin-bottom: 16px;
  }

  .batch-actions-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .batch-selection {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .batch-info {
    color: var(--text-secondary);
    font-size: 14px;
  }

  .select-all-checkbox {
    margin-right: 4px;
    cursor: pointer;
  }

  .batch-buttons {
    display: flex;
    gap: 8px;
  }

  .batch-btn {
    padding: 6px 12px;
    border: 1px solid var(--border-glass);
    border-radius: var(--radius-sm);
    cursor: pointer;
    font-size: 12px;
    background: var(--bg-glass);
    backdrop-filter: var(--backdrop-blur);
    -webkit-backdrop-filter: var(--backdrop-blur);
    transition: all 0.2s;
    color: var(--text-primary);
  }

  .batch-btn.enable {
    color: var(--success-color);
    border-color: var(--success-color);
  }

  .batch-btn.enable:hover {
    background: var(--success-color);
    color: white;
  }

  .batch-btn.disable {
    color: #ef4444;
    border-color: #ef4444;
  }

  .batch-btn.disable:hover {
    background: #ef4444;
    color: white;
  }

  .batch-btn.cancel {
    color: var(--text-secondary);
    border-color: var(--border-glass);
  }

  .batch-btn.cancel:hover {
    background: var(--bg-glass-hover);
  }

  .batch-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  .form-row {
    display: flex;
    gap: 16px;
  }

  .form-row .form-group {
    flex: 1;
  }

  .form-hint {
    font-size: 12px;
    color: var(--text-tertiary);
    margin-top: 4px;
    margin-bottom: 0;
  }
</style>
