<template>
  <div id="app">
    <el-container>
      <el-aside
        v-if="showSidebar"
        width="240px"
        class="sidebar"
      >
<!--        <div class="logo">-->
<!--          <a-->
<!--              href="/"-->
<!--              class="logo-link"-->
<!--              @click.prevent="goToHome"-->
<!--          >-->
<!--            &lt;!&ndash; 动态显示图标 &ndash;&gt;-->
<!--            <div v-if="isUrl(displayIcon)">-->
<!--              <img-->
<!--                  :src="displayIcon"-->
<!--                  class="logo-image"-->
<!--                  width="45"-->
<!--                  height="45"-->
<!--                  alt="Logo"-->
<!--              />-->
<!--            </div>-->
<!--            <div v-else>-->
<!--              <icon-->
<!--                  :icon="displayIcon"-->
<!--                  color="white"-->
<!--                  width="45"-->
<!--                  height="45"-->
<!--              />-->
<!--            </div>-->
<!--            <span class="logo-text">{{ siteTitle }}</span>-->
<!--          </a>-->
<!--        </div>-->
        <div class="logo">
          <a
              href="/"
              class="logo-link"
              @click.prevent="goToHome"
          >
            <icon
                :icon="'jam:reddit'"
                width="45"
                height="45"
                color="white"
            />
            <span class="logo-text">{{ siteTitle }}</span>
          </a>
        </div>
        <el-menu
          :default-active="$route.path"
          class="el-menu-vertical-demo"
          @select="addTab"
        >
          <el-menu-item
            index="/dashboard"
            class="menu-item"
          >
            <i class="el-icon-s-home menu-icon" />
            <icon
              class="menu-svg"
              :icon="'clarity:dashboard-line'"
              width="1em"
              height="1em"
              color="white"
            />
            <span>仪表盘</span>
          </el-menu-item>
          <el-menu-item
            index="/apps"
            class="menu-item"
          >
            <i class="el-icon-s-grid menu-icon" />
            <icon
              class="menu-svg"
              :icon="'fluent:apps-16-regular'"
              width="1em"
              height="1em"
              color="white"
            />
            <span>应用管理</span>
          </el-menu-item>
          <el-menu-item
            index="/menus"
            class="menu-item"
          >
            <i class="el-icon-s-order menu-icon" />
            <icon
              class="menu-svg"
              :icon="'heroicons-solid:menu-alt-1'"
              width="1em"
              height="1em"
              color="white"
            />
            <span>菜单管理</span>
          </el-menu-item>
          <el-menu-item
            index="/settings"
            class="menu-item"
          >
            <i class="el-icon-setting menu-icon" />
            <icon
              class="menu-svg"
              :icon="'ion:earth-sharp'"
              width="1em"
              height="1em"
              color="white"
            />
            <span>站点设置</span>
          </el-menu-item>
          <el-menu-item
              index="/admin"
              class="menu-item"
          >
            <i class="el-icon-setting menu-icon" />
            <icon
                class="menu-svg"
                :icon="'mdi:user'"
                width="1em"
                height="1em"
                color="white"
            />
            <span>用户管理</span>
          </el-menu-item>
        </el-menu>
      </el-aside>
      <el-container>
        <el-header
          v-if="showHeader"
          class="topbar"
        >
          <!-- 顶部导航栏 -->
          <el-tabs
            v-model="activeTab"
            type="card"
            closable
            @tab-remove="removeTab"
            @tab-click="navigateToTab"
          >
            <el-tab-pane
              v-for="tab in tabs"
              :key="tab.name"
              :label="tab.label"
              :name="tab.name"
            />
          </el-tabs>
          <div class="topbar-right">
            <div
              class="admin-dropdown"
              @mouseenter="showDropdown"
              @mouseleave="hideDropdown"
            >
              <div class="admin-info">
                <!-- 动态显示头像 -->
                <div v-if="isUrl(displayIcon)">
                  <img
                      :src="displayIcon"
                      class="avatar"
                      alt="管理员头像"
                  />
                </div>
                <div v-else>
                  <icon
                      :icon="displayIcon"
                      :color="displayIconColor"
                      class="avatar-icon"
                      width="45"
                      height="45"
                  />
                </div>
                <span class="username">{{ username }}</span>
              </div>
              <div
                v-if="dropdownVisible"
                class="dropdown-menu"
                @mouseenter="showDropdown"
                @mouseleave="hideDropdown"
              >
                <div
                  class="dropdown-item"
                  @click="goToDashboard"
                >
                  主页
                </div>
                <div
                  class="dropdown-item"
                  @click="goToAdmin"
                >
                  个人中心
                </div>
                <div
                  class="dropdown-item"
                  @click="logout"
                >
                  退出登录
                </div>
              </div>
            </div>
          </div>
        </el-header>
        <el-main class="main-content">
          <router-view />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script>
import { Icon } from '@iconify/vue';
import { mapGetters } from 'vuex';

export default {
  name: 'App',
  components: { Icon },
  data() {
    return {
      activeTab: '',
      tabs: [],
      dropdownVisible: false,
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
    showHeader() {
      return this.$route.path !== '/' && this.$route.path !== '/login';
    },
    showSidebar() {
      return this.$route.path !== '/login' && (
          this.$route.path === '/dashboard' ||
          this.$route.path === '/apps' ||
          this.$route.path === '/menus' ||
          this.$route.path === '/admin' ||
          this.$route.path === '/settings'
      );
    },
    siteTitle() {
      return this.siteSettings.title || 'zh导航';
    },
    username() {
      return this.$store.state.user ? this.$store.state.user.username : '管理员';
    },
    token() {
      return this.$store.state ? this.$store.state.token : null;
    },
  },
  watch: {
    token(newToken) {
      if (newToken) {
        this.fetchUserData();
      }
    },
    $route(to) {
      this.activeTab = to.path;
    },
  },
  created() {
    this.$store.dispatch('fetchSiteSettings');
    this.$store.dispatch('fetchUserData').then(() => {
      if (this.requiresAuth(this.$route.path) && !this.token) {
        this.$router.push('/login');
      } else {
        this.activeTab = this.$route.path;
      }
    });
  },
  methods: {
    isUrl(string) {
      return /^(http|https):\/\//.test(string);
    },
    fetchUserData() {
      this.$store.dispatch('fetchUserData')
          .then(() => {
            if (this.$route.path === '/login') {
              this.$router.push('/dashboard');
            }
          })
          .catch((error) => {
            console.error('Error fetching user data:', error);
          });
    },
    logout() {
      this.$router.push('/login').then(() => {
        this.$store.commit('clearToken');
      });
    },
    requiresAuth(path) {
      const authRoutes = ['/dashboard', '/apps', '/menus', '/admin', '/settings'];
      return authRoutes.includes(path);
    },
    addTab(index) {
      const existingTab = this.tabs.find(tab => tab.name === index);
      if (!existingTab) {
        const label = this.getLabelByIndex(index);
        this.tabs.push({ label, name: index });
      }
      this.activeTab = index;
      this.$router.push(index);
    },
    removeTab(targetName) {
      this.tabs = this.tabs.filter(tab => tab.name !== targetName);
      if (this.activeTab === targetName) {
        if (this.tabs.length > 0) {
          this.activeTab = this.tabs[this.tabs.length - 1].name;
          this.$router.push(this.activeTab);
        } else {
          this.$router.push('/dashboard');
        }
      }
    },
    navigateToTab(tab) {
      const tabName = (tab.props && tab.props.name) || tab.paneName;
      if (tabName) {
        this.activeTab = tabName;
        this.$router.push(tabName).catch(err => {
          console.error('Navigation error:', err);
        });
      } else {
        console.error('Invalid tab object:', tab);
      }
    },
    getLabelByIndex(index) {
      switch (index) {
        case '/dashboard':
          return '仪表盘';
        case '/apps':
          return '应用管理';
        case '/menus':
          return '菜单管理';
        case '/settings':
          return '站点设置';
        case '/admin':
          return '用户管理';
        default:
          return '未知';
      }
    },
    goToHome() {
      this.$router.push('/'); // 跳转到首页
    },
    showDropdown() {
      if (this.hideTimeout) {
        clearTimeout(this.hideTimeout);
        this.hideTimeout = null;
      }
      this.dropdownVisible = true;
    },
    hideDropdown() {
      this.hideTimeout = setTimeout(() => {
        this.dropdownVisible = false;
      }, 300); // 延迟 300 毫秒隐藏
    },
    goToDashboard() {
      window.open('/', '_blank'); // 在新标签页中打开管理后台
    },
    goToAdmin() {
      this.$router.push('/admin');
    },
  },
};
</script>

<style scoped>
#app {
  display: flex; /* 确保子元素按列排列 */
  height: 100vh;
  background-color: #f9fafc;
  overflow: hidden; /* 防止出现滚动条 */
}

.topbar {
  background-color: #ffffff;
  color: black;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  height: 80px;
}

.sidebar {
  background-color: #001529;
  height: 100%;
  display: flex;
  flex-direction: column;
  z-index: 1000;
}

.sidebar-title {
  background-color: #11171e;
  color: white;
  font-size: 22px;
  font-weight: bold;
  text-align: center;
  padding: 10px 20px;
  height: 60px;
  line-height: 40px;
  box-sizing: border-box;
  z-index: 1000;
}

.logout-button {
  background-color: transparent;
  border-color: #000 !important;
  color: #000 !important;
  border-radius: 15px;
  padding: 10px 20px;
  font-weight: bold;
  transition: background-color 0.3s, color 0.3s, box-shadow 0.3s;
  box-shadow: none !important;
}

.logout-button:hover {
  background-color: #000 !important;
  color: #fff !important;
  box-shadow: 0 1px 5px rgba(0, 0, 0, 0.5) !important;
  border-color: #000 !important;
}

.el-menu-vertical-demo {
  background-color: #001529;
  border-right: none;
}

.menu-item {
  color: #ffffff;
  font-size: 16px;
  height: 50px;
  line-height: 50px;
  display: flex;
  align-items: center;
  padding-left: 20px;
  transition: background-color 0.3s, transform 0.3s;
}

.menu-item:hover {
  background-color: rgba(0,83,155,0.79) !important;
  transform: translateX(5px);
}

.menu-item.is-active {
  background-color: rgba(0,83,155,0.79) !important;
}

.menu-icon {
  margin-right: 10px;
  font-size: 20px;
}

.main-content {
  padding: 20px;
  background-color: #ffffff;
  height: auto; /* 让内容自动撑开高度 */
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow: auto; /* 当内容超出时显示滚动条 */
}

.logo {
  display: flex;
  align-items: center;
  padding: 30px;
  cursor: pointer;
  margin-left: 12px;
}

.menu-svg {
  position: relative;
  left: -10px; /* 调整此值来将图标向左移动 */
}

.logo {
  display: flex;
  align-items: center; /* 垂直方向居中对齐 */
  padding: 20px;
}

.logo-link {
  display: flex;
  align-items: center; /* 确保链接内的内容也居中对齐 */
  text-decoration: none; /* 去除链接下划线 */
}

.logo-text {
  color: white;
  font-size: 20px;
  font-weight: bold;
  margin-left: 10px; /* 控制Logo和文字之间的间距 */
}

.topbar-right {
  display: flex;
  align-items: center;
}

.admin-dropdown {
  position: relative;
  display: inline-block;
  cursor: pointer;
}

.admin-info {
  display: flex;
  align-items: center;
}

.logo-image {
  width: 45px;
  height: 45px;
  object-fit: contain;
  background-color: transparent;
}

.avatar-icon {
  width: 45px;
  height: 45px;
}

.avatar {
  width: 45px;
  height: 45px;
  border-radius: 50%;
  margin-right: 10px;
}

.username {
  font-weight: bold;
  color: #000;
}

.dropdown-menu {
  position: absolute;
  top: calc(100% + 10px);
  right: 0;
  background-color: #fff;
  border: 1px solid #ebeef5;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  z-index: 1000;
  width: 100px;
  margin-top: 5px;
  border-radius: 10px;
  padding-top: 11px;
  font-size: 0.9rem;
}

.dropdown-menu::before {
  content: '';
  position: absolute;
  top: -10px;
  right: 10px;
  border-width: 0 6px 6px 6px;
  border-style: solid;
  border-color: transparent transparent #fff transparent;
  z-index: 1001;
}

.dropdown-menu::after {
  content: '';
  position: absolute;
  top: -10px;
  right: 40%;
  border-width: 0 8px 8px 8px;
  border-style: solid;
  border-color: transparent transparent #ebeef5 transparent;
  z-index: 1000;
}

.dropdown-item {
  padding: 10px;
  cursor: pointer;
  text-align: center;
}

.dropdown-item:hover {
  background-color: rgba(0,82,255,0.16);
  color: rgba(0,79,255,0.55);
}

:deep(.el-tabs__item) {
  background-color: #f5f5f5 !important; /* 未选中时的背景色 */
  color: #333 !important;               /* 未选中时的文本颜色 */
  border-radius: 4px !important;        /* 圆角效果 */
  margin-right: 10px !important;        /* 每个tab之间的间距 */
  padding: 5px 15px !important;         /* 内边距增加以获得更好的视觉效果 */
  border: none !important;    /* 给tab添加边框 */
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1) !important; /* 添加阴影效果 */
}

:deep(.el-tabs__item.is-active) {
  background-color: #000 !important; /* 选中时的背景色 */
  color: #fff !important;            /* 选中时的文本颜色 */
  border: none !important; /* 选中时的边框颜色 */
}

.el-tabs--card > .el-tabs__header .el-tabs__nav {
  border: none !important; /* 强制去掉边框 */
}

</style>
