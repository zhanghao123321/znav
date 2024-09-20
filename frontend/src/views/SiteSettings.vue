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
                  alt="icon"/>
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

export default {
  components: { Icon },
  computed: {
    settings() {
      return this.$store.getters.siteSettings;
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
      this.$store.dispatch('updateSiteSettings', this.settings)
          .then(() => {
            this.$message.success('设置已保存');
          })
          .catch((error) => {
            this.$message.error('保存失败：' + error.message);
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
  background-color: #2b5076; /* 按钮背景颜色 */
  border: none; /* 去掉边框 */
  border-radius: 4px; /* 圆角边框 */
  color: #fff; /* 文字颜色 */
  font-size: 14px; /* 字体大小 */
  padding: 10px 20px; /* 内边距 */
  transition: background-color 0.3s ease; /* 背景色过渡效果 */
}

.custom-button:hover {
  background-color: rgba(43,80,118,0.71); /* 鼠标悬停时的背景颜色 */
}

.custom-button:active {
  background-color: #2b5076; /* 鼠标点击时的背景颜色 */
}

.custom-button:focus {
  outline: none; /* 去掉焦点时的边框 */
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

</style>
