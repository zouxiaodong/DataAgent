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
