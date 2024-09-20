<template>
  <div class="login-container">
    <el-card class="login-box">
      <div class="login-logo">
        <!-- 动态显示图标 -->
        <div v-if="isUrl(displayIcon)">
          <img
              :src="displayIcon"
              class="login-logo-image"
              alt="Logo"
          />
        </div>
        <div v-else>
          <icon
              :icon="displayIcon"
              :color="displayIconColor"
              class="login-logo-icon"
              width="50"
              height="50"
          />
        </div>
        <h2>用户登录</h2>
      </div>
      <el-form ref="loginForm" :model="loginForm" @submit.prevent="login">
        <el-form-item prop="username">
          <el-input v-model="loginForm.username" placeholder="用户名" required />
        </el-form-item>
        <el-form-item prop="password">
          <el-input
              v-model="loginForm.password"
              type="password"
              placeholder="密码"
              required
          />
        </el-form-item>
        <el-button type="primary" native-type="submit" class="login-button">
          登录
        </el-button>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import axios from 'axios';
import { mapGetters } from 'vuex';
import { Icon } from '@iconify/vue';

export default {
  components: {
    Icon,
  },
  data() {
    return {
      loginForm: {
        username: '',
        password: '',
      },
    };
  },
  computed: {
    ...mapGetters(['siteSettings']),
    displayIcon() {
      return this.siteSettings.icon || 'https://img1.baidu.com/it/u=1217061905,2277984247&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500';
    },
    displayIconColor() {
      return this.siteSettings.icon_color || '#000000';
    },
  },
  methods: {
    isUrl(string) {
      return /^(http|https):\/\//.test(string);
    },
    login() {
      this.$refs.loginForm.validate((valid) => {
        if (valid) {
          axios
              .post(`${process.env.VUE_APP_API_URL}/login`, {
                username: this.loginForm.username,
                password: this.loginForm.password,
              })
              .then((response) => {
                const token = response.data.token;
                localStorage.setItem('token', token); // 存储 token
                this.$store.commit('setToken', token); // 更新 Vuex 的 token
                this.$router.push('/dashboard'); // 登录成功后跳转到 dashboard
              })
              .catch((error) => {
                console.error(error);
                // 检查后端返回的错误信息
                if (
                    error.response &&
                    error.response.data &&
                    error.response.data.error
                ) {
                  const errorMsg = error.response.data.error;
                  if (errorMsg === '用户已停用') {
                    this.$message.error('用户已停用');
                  } else if (errorMsg === '密码验证失败') {
                    this.$message.error('密码验证失败');
                  } else if (errorMsg === '用户未注册') {
                    this.$message.error('用户未注册');
                  } else {
                    this.$message.error(`登录失败：${errorMsg}`);
                  }
                } else {
                  this.$message.error('登录失败');
                }
              });
        } else {
          this.$message.error('请完整填写表单');
        }
      });
    },
  },
  mounted() {
    // 如果网站设置尚未获取，触发获取操作
    if (!this.siteSettings || !this.siteSettings.icon) {
      this.$store.dispatch('fetchSiteSettings');
    }
  },
};
</script>

<style>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.login-box {
  width: 400px;
  text-align: center;
}

.login-logo-image,
.login-logo-icon {
  width: 50px;
  height: 50px;
  margin-bottom: 10px;
}

h2 {
  margin-bottom: 20px;
  color: #333;
}

.login-button {
  width: 100%;
}
</style>
