<template>
  <div class="site-settings-container">
    <el-form
        :model="settings"
        label-width="100px"
    >
      <el-form-item
          label="站点名称"
          required
      >
        <el-input
            v-model="settings.title"
            placeholder="请输入站点名称"
            class="short-input"
        />
      </el-form-item>

      <!-- 图床Token输入框和获取Token按钮 -->
      <el-form-item label="图床Token">
        <div class="token-input-button">
          <el-input v-model="settings.image_host_token" placeholder="请输入图床Token" class="short-input" />
          <el-button type="primary" @click="redirectToTokenPage" class="get-token-button">点我获取 Token</el-button>
        </div>
      </el-form-item>

      <el-form-item label="图标">
        <el-row :gutter="20" align="middle">
          <el-col :span="10">
            <el-input v-model="settings.icon" placeholder="请输入iconify图标或URL" />
          </el-col>
          <el-col :span="1" class="no-padding">
            <div v-if="isUrl(settings.icon)">
              <img :src="settings.icon" class="menu-icon" width="30" height="30" alt="icon" />
            </div>
            <div v-else>
              <icon :icon="settings.icon" class="menu-icon" width="30" height="30" />
            </div>
          </el-col>
          <el-col :span="1" class="align-right">
            <el-color-picker v-model="settings.icon_color" />
          </el-col>
        </el-row>
      </el-form-item>

      <el-form-item>
        <a
            href="https://icon-sets.iconify.design/?category=General"
            target="_blank"
            class="icon-link"
        >
          点我前往 Iconify 查看图标
        </a>
      </el-form-item>

      <el-form-item label="备案号">
        <el-input
            v-model="settings.icp"
            placeholder="请输入备案号"
            class="short-input"
        />
      </el-form-item>

      <el-form-item label="尾部信息">
        <el-input
            v-model="settings.footer"
            type="textarea"
            placeholder="请输入尾部信息"
            class="short-input"
        />
      </el-form-item>

      <el-form-item>
        <el-button
            class="custom-button"
            type="primary"
            @click="saveSettings"
        >
          修改数据
        </el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import { Icon } from "@iconify/vue";
import axios from 'axios';

export default {
  components: { Icon },
  computed: {
    settings: {
      get() {
        return this.$store.getters.siteSettings;
      },
      set(value) {
        this.$store.commit('setSiteSettings', value);
      }
    }
  },
  mounted() {
    this.$store.dispatch('fetchSiteSettings')
        .then(() => {
          console.log("Site settings loaded:", this.settings);  // 确保 settings 加载完成后有 token
        });
  },
  methods: {
    redirectToTokenPage() {
      // 跳转到图床 Token 获取页面
      window.open('https://img.ink/user/settings.html', '_blank');
    },
    isUrl(string) {
      return string.startsWith('http://') || string.startsWith('https://');
    },
    saveSettings() {
      // 创建一个新的对象
      const settingsToSave = { ...this.settings };

      // 保存 Token
      if (this.settings.image_host_token) {
        axios
            .post(`${process.env.VUE_APP_API_URL}/save-token`, {
              token: this.settings.image_host_token,
            })
            .then(() => {
              this.$message.success('Token 已保存');
            })
            .catch((error) => {
              this.$message.error('保存 Token 失败：' + error.message);
            });
      }

      // 保存其他设置
      this.$store
          .dispatch('updateSiteSettings', settingsToSave)
          .then(() => {
            this.$message.success('设置已保存');
          })
          .catch((error) => {
            this.$message.error('保存设置失败：' + error.message);
          });
    },
  }
};
</script>

<style>
.site-settings-container {
  padding: 20px;
}

.menu-icon {
  width: 30px;
  height: 30px;
  object-fit: contain;
  display: block;
}

.icon-link {
  display: block;
  margin-top: -15px;
  font-size: 12px;
  color: #409EFF;
  text-decoration: underline;
}

.custom-button {
  background-color: #2b5076;
  border: none;
  border-radius: 4px;
  color: #fff;
  font-size: 14px;
  padding: 10px 20px;
  transition: background-color 0.3s ease;
}

.custom-button:hover {
  background-color: rgba(43,80,118,0.71);
}

.custom-button:active {
  background-color: #2b5076;
}

.custom-button:focus {
  outline: none;
}

.short-input {
  width: 400px;
}

.el-color-dropdown__btns {
  display: flex;
  margin-top: 12px;
  align-items: flex-end;
}

.el-color-dropdown__btns .el-button {
  margin-left: 10px;
}

.align-right {
  display: flex;
  justify-content: flex-end;
}

.no-padding {
  padding-left: 0 !important;
  padding-right: 0 !important;
}

/* 新增样式 */
.token-input-button {
  display: flex;
  align-items: center;
}

.token-input-button .el-input {
  flex: 1;
}

.get-token-button {
  margin-left: 10px; /* 调整间距 */
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}

.dialog-footer .el-button + .el-button {
  margin-left: 10px; /* 按钮之间的间距 */
}
</style>
