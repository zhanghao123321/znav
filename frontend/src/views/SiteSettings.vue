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

      <!-- 调整后的图床Token输入框和获取Token按钮 -->
      <el-form-item label="图床Token">
        <div class="token-input-button">
          <el-input
              v-model="settings.image_host_token"
              placeholder="请输入图床Token"
              class="short-input"
          />
          <el-button
              type="primary"
              @click="openTokenModal"
              class="get-token-button"
          >
            点我获取 Token
          </el-button>
        </div>
      </el-form-item>

      <!-- 获取Token的弹窗 -->
      <el-dialog
          title="获取图床 Token"
          v-model="tokenDialogVisible"
          width="600px"
      >
      <el-form :model="tokenForm" label-width="80px">
        <el-form-item label="URL" required>
          <el-input v-model="tokenForm.url" placeholder="请输入URL,例：http://192.168.222.173:12345" />
        </el-form-item>
        <el-form-item label="Email" required>
          <el-input v-model="tokenForm.email" placeholder="请输入Email" />
        </el-form-item>
        <el-form-item label="密码" required>
          <el-input
              v-model="tokenForm.password"
              placeholder="请输入密码"
              show-password
              type="password"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="tokenDialogVisible = false">取消</el-button>
          <el-button
              type="primary"
              @click="fetchToken"
              :loading="fetchingToken"
          >
            获取
          </el-button>
        </div>
      </template>
      </el-dialog>

      <!-- 其他表单项 -->
      <el-form-item label="图标">
        <el-row :gutter="20" align="middle">
          <!-- 图标输入框和图标展示列 -->
          <el-col :span="10">
            <el-input
                v-model="settings.icon"
                placeholder="请输入iconify图标或URL"
            />
          </el-col>
          <!-- 图标展示列 -->
          <el-col :span="1" class="no-padding">
            <div v-if="isUrl(settings.icon)">
              <img
                  :src="settings.icon"
                  :style="{ color: settings.icon_color }"
                  class="menu-icon"
                  width="30"
                  height="30"
                  alt="icon"
              />
            </div>
            <div v-else>
              <icon
                  :icon="settings.icon"
                  :color="settings.icon_color"
                  class="menu-icon"
                  width="30"
                  height="30"
              />
            </div>
          </el-col>
          <!-- 颜色选择器列 -->
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
  data() {
    return {
      tokenDialogVisible: false,
      tokenForm: {
        url: '',
        email: '',
        password: ''
      },
      fetchingToken: false
    };
  },
  computed: {
    settings: {
      get() {
        return this.$store.getters.siteSettings;
      },
      set(value) {
        this.$store.commit('SET_SITE_SETTINGS', value);
      }
    }
  },
  mounted() {
    this.$store.dispatch('fetchSiteSettings');
  },
  methods: {
    isUrl(string) {
      return string.startsWith('http://') || string.startsWith('https://');
    },
    saveSettings() {
      // 在保存设置时，将 image_host_url 也一起发送到后端
      this.$store.dispatch('updateSiteSettings', this.settings)
          .then(() => {
            this.$message.success('设置已保存');
          })
          .catch((error) => {
            this.$message.error('保存失败：' + error.message);
          });
    },
    openTokenModal() {
      // 初始化表单数据
      this.tokenForm.url = this.settings.image_host_url || '';
      this.tokenForm.email = '';
      this.tokenForm.password = '';
      this.tokenDialogVisible = true;
    },
    fetchToken() {
      if (!this.isUrl(this.tokenForm.url)) {
        this.$message.error('请输入有效的 URL');
        return;
      }
      if (!this.tokenForm.email || !this.tokenForm.password) {
        this.$message.error('请填写所有必填项');
        return;
      }

      this.fetchingToken = true; // 开始加载

      // 构建请求数据
      const formData = new FormData();
      formData.append('email', this.tokenForm.email);
      formData.append('password', this.tokenForm.password);

      // 发送请求获取 Token
      axios.post(`${this.tokenForm.url}/api/v1/tokens`, formData)
          .then(response => {
            if (response.data && response.data.data && response.data.data.token) {
              // 将获取到的 Token 和 URL 填入到设置中
              this.settings.image_host_token = response.data.data.token;
              this.settings.image_host_url = this.tokenForm.url; // 保存 URL 到设置中
              this.$message.success('Token 获取成功');
              this.tokenDialogVisible = false;
            } else {
              this.$message.error('未能获取到 Token，请检查输入的信息是否正确');
            }
          })
          .catch(error => {
            console.error('Error fetching token:', error);
            let errorMessage = error.message;
            if (error.response && error.response.data && error.response.data.message) {
              errorMessage = error.response.data.message;
            }
            this.$message.error('获取 Token 失败：' + errorMessage);
          })
          .finally(() => {
            this.fetchingToken = false; // 加载结束
          });
    }
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
