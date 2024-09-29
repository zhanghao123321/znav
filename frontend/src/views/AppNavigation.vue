<template>
  <el-container>
    <!-- 顶部侧边栏 -->
    <el-header :class="['header-container', { 'header-expanded': !isSidebarVisible }]">
      <div class="toggle-sidebar-button" @click="toggleSidebar">
        <!-- 侧边栏切换按钮 -->
        <icon aria-hidden="true" :icon="'solar:hamburger-menu-bold'" width="45" height="45" color="black" />
      </div>

      <!-- 热榜区域 -->
      <div class="hot-rankings-container" @mouseenter="showHotDropdown" @mouseleave="scheduleHideHotDropdown">
        <icon :icon="'fluent:fire-16-filled'" width="30" height="30" style="margin-right: 5px; color: rgb(187, 12, 12);" />
        <div class="hotspot-rankings-toggle">今日热榜</div>

        <!-- 热点榜单下拉框 -->
        <div v-if="hotDropdownVisible" class="rankings-dropdown">
          <div class="hot-header">
            <span @click="scrollLeft" class="scroll-button">
              <icon :icon="'ri:skip-left-line'" width="20" height="20" />
            </span>
                    <div class="hot-categories-wrapper">
                      <div class="hot-categories">
                    <span v-for="category in categories" :key="category" @click="fetchHotRank(category)" :class="{ 'active': selectedCategory === category }">
                        {{ category }}
                    </span>
                      </div>
                    </div>
                    <span @click="scrollRight" class="scroll-button">
              <icon :icon="'ri:skip-right-line'" width="20" height="20" />
            </span>
          </div>
          <ul class="hot-list">
            <li v-for="(item, index) in hotRank" :key="item.url" class="hot-item">
              <div class="item-content">
                <!-- index 带背景颜色 -->
                <span class="rank-number" :class="getRankClass(index + 1)">{{ index + 1 }}</span>
                <a :href="item.url" target="_blank" class="hot-title">{{ item.title }}</a>
                <span class="hot-value">
                  {{ item.hot ? (item.hot < 10000 ? item.hot : (item.hot / 10000).toFixed(2) + '万') : '未知' }}
                </span>
              </div>
            </li>
          </ul>
        </div>
      </div>

      <!-- 每日一言 -->
      <div class="hitokoto" @click="fetchHitokoto" style="cursor: pointer;">
        <p v-if="hitokoto">{{ hitokoto }}</p>
        <p v-else>点击获取每日一言</p>
      </div>

      <!-- 管理员区域 -->
      <div class="header-actions">
        <div v-if="isLoggedIn" class="admin-dropdown" @mouseenter="showAdminDropdown" @mouseleave="scheduleHideAdminDropdown">
          <div class="admin-info">
            <template v-if="isUrl(siteSettings.icon)">
              <img :src="siteSettings.icon" :style="{ color: siteSettings.icon_color || '#000' }" width="45" height="45" alt="" />
            </template>
            <template v-else>
              <icon :icon="siteSettings.icon" :color="siteSettings.icon_color || '#000'" width="45" height="45" />
            </template>
            <span class="username">管理员</span>
          </div>

          <!-- 管理员下拉框 -->
          <div v-if="adminDropdownVisible" class="dropdown-menu" @mouseenter="clearAdminDropdownTimeout" @mouseleave="scheduleHideAdminDropdown">
            <div class="dropdown-item" @click="goToDashboard">管理后台</div>
            <div class="dropdown-item" @click="logout">退出登录</div>
          </div>
        </div>

        <!-- 登录按钮 -->
        <div v-else @click="goToLogin" class="login-button">
          登录
        </div>
      </div>
    </el-header>

    <el-container>
      <!-- 侧边栏 -->
      <transition
        name="sidebar"
        @before-enter="beforeEnter"
        @enter="enter"
        @leave="leave"
        @after-leave="afterLeave"
      >
        <el-aside
          v-show="isSidebarVisible"
          ref="sidebar"
          :class="['sidebar-container', { 'sidebar-hidden': !isSidebarVisible, 'sidebar-shown': isSidebarVisible }]"
        >
          <div
            class="logo"
            @click="goToHome"
          >
            <!-- 判断是否为 URL -->
            <template v-if="isUrl(siteSettings.icon)">
              <img
                :src="siteSettings.icon"
                :style="{ color: siteSettings.icon_color || '#000' }"
                width="45"
                height="45"
                alt=""
              >
            </template>
            <!-- 如果不是 URL，则使用 Iconify 图标 -->
            <template v-else>
              <icon
                :icon="siteSettings.icon"
                :color="siteSettings.icon_color || '#000'"
                width="30"
                height="30"
              />
            </template>
            <span class="logo-text">{{ siteSettings.title }}</span>
          </div>
          <el-menu
            :default-active="activeMenu"
            class="el-menu-vertical-demo"
            unique-opened
          >
            <template v-for="menu in menusWithLevels">
              <div
                v-if="!menu.parent_id"
                :key="menu.id"
                class="menu-item-wrapper"
              >
                <el-menu-item
                  :index="menu.id.toString()"
                  @click="toggleSubMenu(menu)"
                >
                  <template v-if="isUrl(menu.icon)">
                    <img
                      :src="menu.icon"
                      :style="{ color: menu.icon_color || '#000' }"
                      class="menu-icon"
                      width="30"
                      height="30"
                      alt=""
                    >
                  </template>
                  <template v-else>
                    <icon
                      :icon="menu.icon"
                      :color="menu.icon_color || '#000'"
                      class="menu-icon"
                      width="30"
                      height="30"
                    />
                  </template>
                  <span>{{ menu.title }}</span>
                  <span
                    v-if="menu.children.length > 0"
                    class="submenu-arrow"
                  >
                    <icon
                      v-if="openedMenuId !== menu.id"
                      :icon="'mingcute:right-line'"
                      width="14"
                      height="14"
                      color="black"
                    />
                    <icon
                      v-if="openedMenuId === menu.id"
                      :icon="'mingcute:down-line'"
                      width="14"
                      height="14"
                      color="black"
                    />
                  </span>
                </el-menu-item>
                <el-menu-item
                  v-for="subMenu in menu.children"
                  v-show="openedMenuId === menu.id"
                  :key="subMenu.id"
                  :index="subMenu.id.toString()"
                  :style="{ paddingLeft: '40px' }"
                  @click="handleMenuClick(subMenu)"
                >
                  <template v-if="isUrl(subMenu.icon)">
                    <img
                      :src="subMenu.icon"
                      :style="{ color: subMenu.icon_color || '#000' }"
                      class="menu-icon"
                      width="30"
                      height="30"
                      alt=""
                    >
                  </template>
                  <template v-else>
                    <icon
                      :icon="subMenu.icon"
                      :color="subMenu.icon_color || '#000'"
                      class="menu-icon"
                      width="30"
                      height="30"
                    />
                  </template>
                  <span>{{ subMenu.title }}</span>
                </el-menu-item>
              </div>
            </template>
          </el-menu>
        </el-aside>
      </transition>

      <!-- 主内容区 -->
      <el-main :class="{'main-container-expanded': !isSidebarVisible, 'main-container': isSidebarVisible}">
        <div
          v-for="menu in menusWithLevels"
          :id="`menu-${menu.id}`"
          :key="menu.id"
        >
          <!-- 一级菜单展示 -->
          <div
            v-if="!menu.parent_id"
            class="menu-section"
          >
            <h2 class="menu-title">
              <template v-if="isUrl(menu.icon)">
                <img
                  :src="menu.icon"
                  :style="{ color: menu.icon_color || '#000' }"
                  class="menu-icon"
                  width="30"
                  height="30"
                  alt=""
                >
              </template>
              <template v-else>
                <icon
                  :icon="menu.icon"
                  :color="menu.icon_color || '#000'"
                  class="menu-icon"
                  width="30"
                  height="30"
                />
              </template>
              {{ menu.title }}
            </h2>
            <div class="app-card-container">
              <el-row
                :gutter="20"
                justify="start"
              >
                <el-col
                  v-for="app in filteredApplications(menu.id)"
                  :key="app.id"
                  :xs="24"
                  :sm="12"
                  :md="8"
                  :lg="6"
                  :xl="4"
                >
                  <el-card
                    shadow="hover"
                    class="app-card"
                    @mouseover="showDescription(app.id, $event)"
                    @mouseleave="hideDescription"
                    @click="handleCardClick(app)"
                  >
                    <div class="app-card-content">
                      <div class="app-icon-container">
                        <template v-if="isUrl(app.icon)">
                          <img
                            :src="app.icon"
                            :style="{ color: app.icon_color || '#000' }"
                            class="app-icon"
                            width="45"
                            height="45"
                            alt=""
                          >
                        </template>
                        <template v-else>
                          <icon
                            :icon="app.icon"
                            :color="app.icon_color || '#000'"
                            class="app-icon"
                            width="45"
                            height="45"
                          />
                        </template>
                      </div>
                      <div class="app-info-container">
                        <h3 class="app-title">
                          {{ app.title }}
                        </h3>
                        <p class="app-description">
                          {{ app.description }}
                        </p>
                      </div>
                    </div>
                  </el-card>
                  <!-- Teleport 用于在卡片悬停时显示完整描述 -->
                  <Teleport
                    v-if="currentAppId === app.id"
                    to="body"
                  >
                    <div
                      class="app-full-description"
                      :style="descriptionStyle"
                    >
                      <div class="triangle" />
                      {{ app.description }}
                    </div>
                  </Teleport>
                </el-col>
              </el-row>
            </div>

            <!-- 渲染该一级菜单下的所有二级菜单 -->
            <div
              v-for="subMenu in menu.children"
              :id="`menu-${subMenu.id}`"
              :key="subMenu.id"
              class="menu-section"
            >
              <h2 class="menu-title sub-menu-title">
                <template v-if="isUrl(subMenu.icon)">
                  <img
                    :src="subMenu.icon"
                    :style="{ color: subMenu.icon_color || '#000' }"
                    class="menu-icon"
                    width="30"
                    height="30"
                    alt=""
                  >
                </template>
                <template v-else>
                  <icon
                    :icon="subMenu.icon"
                    :color="subMenu.icon_color || '#000'"
                    class="menu-icon"
                    width="30"
                    height="30"
                  />
                </template>
                {{ subMenu.title }}
              </h2>
              <div class="app-card-container">
                <el-row
                  :gutter="20"
                  justify="start"
                >
                  <el-col
                    v-for="app in filteredApplications(subMenu.id)"
                    :key="app.id"
                    :xs="24"
                    :sm="12"
                    :md="8"
                    :lg="6"
                    :xl="4"
                  >
                    <el-card
                      shadow="hover"
                      class="app-card"
                      @mouseover="showDescription(app.id, $event)"
                      @mouseleave="hideDescription"
                      @click="handleCardClick(app)"
                    >
                      <div class="app-card-content">
                        <div class="app-icon-container">
                          <template v-if="isUrl(app.icon)">
                            <img
                              :src="app.icon"
                              :style="{ color: app.icon_color || '#000' }"
                              class="app-icon"
                              alt=""
                            >
                          </template>
                          <template v-else>
                            <icon
                              :icon="app.icon"
                              :color="app.icon_color || '#000'"
                              class="app-icon"
                              width="45"
                              height="45"
                            />
                          </template>
                        </div>
                        <div class="app-info-container">
                          <h3 class="app-title">
                            {{ app.title }}
                          </h3>
                          <p class="app-description">
                            {{ app.description }}
                          </p>
                        </div>
                      </div>
                    </el-card>
                    <Teleport
                      v-if="currentAppId === app.id"
                      to="body"
                    >
                      <div
                        class="app-full-description"
                        :style="descriptionStyle"
                      >
                        <div class="triangle" />
                        {{ app.description }}
                      </div>
                    </Teleport>
                  </el-col>
                </el-row>
              </div>
            </div>
          </div>
        </div>
        <el-tooltip content="返回顶部" placement="top">
          <div
              class="back-to-top"
              @click="scrollToTop"
              @mouseenter="iconColor = 'red'"
              @mouseleave="iconColor = 'black'"
          >
            <icon
                :icon="'ph:rocket-fill'"
                width="48"
                height="48"
                :color="iconColor"
            />
          </div>
        </el-tooltip>
      </el-main>
      <el-footer class="footer-container">
        <p>{{ siteSettings.footer }}  ©  <span class="icp">{{ siteSettings.icp }}</span></p>
      </el-footer>
    </el-container>
  </el-container>
</template>

<script>
import { Icon } from '@iconify/vue';
import axios from 'axios';

export default {
  components: {
    Icon,
  },
  data() {
    return {
      hitokoto: '', // 保存每日一言
      hotRank: [], // 存储热榜数据
      selectedCategory: '百度', // 默认选中的热榜类别
      categories: [
        "百度", "微博", "知乎", "抖音", "今日头条", "哔哩哔哩", "HelloGitHub", "51CTO", "CSDN", "稀土掘金",
        "少数派", "IT之家", "百度贴吧", "澎湃新闻", "网易新闻", "中央气象台", "中国地震台",
        "豆瓣电影", "爱范儿", "英雄联盟", "AcFun", "微信读书", "NGA", "历史上的今天"
      ],
      scrollPosition: 0,
      menus: [], // 菜单数据
      applications: [], // 应用数据
      currentAppId: null, // 当前悬停的卡片的应用 ID
      descriptionStyle: { top: '0px', left: '0px' }, // 下拉框的样式
      activeMenu: '', // 当前激活的菜单项
      searchQuery: '', // 搜索框内容
      isSidebarVisible: true, // 控制侧边栏是否可见
      sidebarOpeningRight: false,
      dropdownVisible: false,
      openedMenuId: null, // 当前展开的一级菜单ID
      hotDropdownVisible: false,  // 控制热点榜单下拉框的显示
      adminDropdownVisible: false,  // 控制管理员下拉框的显示
      hotDropdownTimeout: null,  // 控制热点榜单下拉框隐藏的定时器
      adminDropdownTimeout: null,  // 控制管理员下拉框隐藏的定时器
      iconColor: 'black',
    };
  },
  computed: {
    isLoggedIn() {
      return !!this.$store.state.token; // 检查用户是否已登录
    },
    siteSettings() {
      return this.$store.getters.siteSettings || {
        title: 'zh导航',
        icon: 'https://img1.baidu.com/it/u=1217061905,2277984247&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500',
        icp: '123456',
        footer: 'zh导航. All Rights Reserved.'
      };
    },
    menusWithLevels() {
      const addLevel = (menus, parentId = null, level = 0) => {
        return menus
            .filter(menu => menu.parent_id === parentId)
            .map(menu => {
              const children = addLevel(menus, menu.id, level + 1);
              return {
                ...menu,
                level,
                children,
              };
            });
      };
      return addLevel(this.menus);
    },
  },
  created() {
    this.fetchMenus();
    this.fetchAllApplications(); // 一次性获取所有数据
    this.$store.dispatch('fetchSiteSettings');
    this.fetchHitokoto(); // 页面加载时获取每日一言
    this.fetchHotRank('百度'); // 初始化百度栏目的数据
  },
  methods: {
    getRankClass(index) {
      // 返回不同的 CSS 类
      if (index === 1) return 'rank-first';
      if (index === 2) return 'rank-second';
      if (index === 3) return 'rank-third';
      return 'rank-default';
    },
    // 热点榜单下拉框显示/隐藏逻辑
    showHotDropdown() {
      this.clearHotDropdownTimeout();
      this.hotDropdownVisible = true;
    },
    scheduleHideHotDropdown() {
      this.hotDropdownTimeout = setTimeout(() => {
        this.hotDropdownVisible = false;
      }, 300); // 延迟300ms隐藏
    },
    clearHotDropdownTimeout() {
      if (this.hotDropdownTimeout) {
        clearTimeout(this.hotDropdownTimeout);
        this.hotDropdownTimeout = null;
      }
    },

    // 管理员下拉框显示/隐藏逻辑
    showAdminDropdown() {
      this.clearAdminDropdownTimeout();
      this.adminDropdownVisible = true;
    },
    scheduleHideAdminDropdown() {
      this.adminDropdownTimeout = setTimeout(() => {
        this.adminDropdownVisible = false;
      }, 300); // 延迟300ms隐藏
    },
    clearAdminDropdownTimeout() {
      if (this.adminDropdownTimeout) {
        clearTimeout(this.adminDropdownTimeout);
        this.adminDropdownTimeout = null;
      }
    },
    fetchHitokoto() {
      axios.get(`${process.env.VUE_APP_API_URL}/hitokoto`)
          .then(response => {
            this.hitokoto = response.data.hitokoto; // 保存每日一言
          })
          .catch(error => {
            console.error('Error fetching hitokoto:', error);
          });
    },
    fetchHotRank(category) {
      this.selectedCategory = category; // 更新选中的类别
      axios.get(`${process.env.VUE_APP_API_URL}/hotrank`, {
        params: { category: this.selectedCategory }
      })
          .then(response => {
            this.hotRank = response.data; // 更新热榜数据
          })
          .catch(error => {
            console.error('Error fetching hot rank:', error);
          });
    },
    scrollLeft() {
      const wrapper = this.$el.querySelector(".hot-categories-wrapper");
      const scrollAmount = wrapper.clientWidth; // 可见区域的宽度，即一页的宽度
      const currentScroll = wrapper.scrollLeft; // 当前滚动位置

      // 计算新的滚动位置（向左翻一页）
      const newScrollPosition = Math.max(currentScroll - scrollAmount, 0);

      // 如果当前已经在第一页，则不再滚动
      if (currentScroll === 0) {
        return;
      }

      // 滚动到新的位置
      wrapper.scrollTo({ left: newScrollPosition, behavior: "smooth" });
    },

    scrollRight() {
      const wrapper = this.$el.querySelector(".hot-categories-wrapper");
      const scrollAmount = wrapper.clientWidth; // 可见区域的宽度，即一页的宽度
      const currentScroll = wrapper.scrollLeft; // 当前滚动位置
      const maxScroll = wrapper.scrollWidth - wrapper.clientWidth; // 最大滚动距离

      // 计算新的滚动位置（向右翻一页）
      const newScrollPosition = Math.min(currentScroll + scrollAmount, maxScroll);

      // 如果已经到达最后一页，则不再滚动
      if (currentScroll >= maxScroll) {
        return;
      }

      // 滚动到新的位置
      wrapper.scrollTo({ left: newScrollPosition, behavior: "smooth" });
    },
    scrollToTop() {
      this.$nextTick(() => {
        // 获取实际滚动容器
        const scrollContainer = document.querySelector('.main-container');

        if (scrollContainer) {
          // 使用 scrollIntoView 实现平滑滚动
          scrollContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });
        } else {
          console.error("Unable to find the scroll container.");
        }
      });
    },
    isUrl(string) {
      return string.startsWith('http://') || string.startsWith('https://');
    },
    fetchMenus() {
      let page = 1;
      const limit = 100; // 假设每页的菜单数据为100条，可以根据实际情况调整
      const fetchPage = () => {
        axios.get(`${process.env.VUE_APP_API_URL}/menus`, {
          headers: { Authorization: `Bearer ${this.$store.state.token}` },
          params: {
            page,
            limit,
          },
        })
            .then((response) => {
              const newMenus = response.data.menus;
              if (newMenus.length > 0) {
                // 过滤掉状态为“停用”的菜单
                const activeMenus = newMenus.filter(menu => menu.status === 'active');
                this.menus = [...this.menus, ...activeMenus].sort((a, b) => a['order_id'] - b['order_id']);
                page++;
                fetchPage(); // 递归调用以获取下一页数据
              }
            })
            .catch((error) => {
              console.error('Error fetching menus:', error);
            });
      };
      fetchPage();
    },
    fetchAllApplications() {
      let page = 1;
      const limit = 100;
      const fetchPage = () => {
        axios.get(`${process.env.VUE_APP_API_URL}/applications`, {
          headers: { Authorization: `Bearer ${this.$store.state.token}` },
          params: {
            page,
            limit,
          },
        })
            .then((response) => {
              const newApplications = response.data.applications;
              if (newApplications.length > 0) {
                this.applications = [...this.applications, ...newApplications]
                    .sort((a, b) => a['order_id'] - b['order_id']);
                page++;
                fetchPage();
              }
            })
            .catch((error) => {
              console.error('Error fetching applications:', error);
            });
      };
      fetchPage();
    },
    filteredApplications(menuId) {
      return this.applications.filter(
          app => app.menu_id === menuId && app.status === 'active'
      );
    },
    showDescription(appId, event) {
      this.currentAppId = appId;
      const rect = event.currentTarget.getBoundingClientRect();
      const viewportHeight = window.innerHeight;
      const shouldShowAbove = rect.bottom + 100 > viewportHeight;

      this.descriptionStyle = {
        top: shouldShowAbove ? `${rect.top - 10}px` : `${rect.bottom + 10}px`,
        left: `${rect.left + rect.width / 2 - 118}px`,
        transform: shouldShowAbove ? 'translateY(-100%)' : 'translateY(0)',
      };
    },
    hideDescription() {
      this.currentAppId = null;
    },
    handleCardClick(app) {
      window.open(app.link, '_blank');
    },
    handleMenuClick(menu) {
      this.activeMenu = menu.id.toString();
      this.scrollToMenu(menu.id);
    },
    scrollToMenu(menuId) {
      this.$nextTick(() => {
        const element = document.getElementById(`menu-${menuId}`);
        if (element) {
          element.style.scrollMarginTop = '90px';
          element.scrollIntoView({ behavior: 'smooth', block: 'start' });
          window.setTimeout(() => {
            element.style.scrollMarginTop = '';
          }, 1000);
        } else {
          console.error(`Element not found for menuId: ${menuId}`);
        }
      });
    },
    toggleSidebar() {
      if (this.isSidebarVisible) {
        this.sidebarOpeningRight = false;
        this.isSidebarVisible = false;
      } else {
        this.sidebarOpeningRight = true;
        this.isSidebarVisible = true;
      }
    },
    beforeEnter(el) {
      el.style.transform = 'translateX(-100%)'; // 初始状态下隐藏在左侧
    },
    enter(el, done) {
      requestAnimationFrame(() => {
        el.style.transition = 'transform 0.5s ease-in-out';
        el.style.transform = 'translateX(0)';
        done();
      });
    },
    leave(el, done) {
      el.style.transition = 'transform 0.5s ease-in-out';
      el.style.transform = 'translateX(-100%)';

      // 延迟调用 done()，确保动画完成后再结束
      setTimeout(() => {
        done();
      }, 500); // 500ms 与动画持续时间保持一致
    },
    afterLeave(el) {
      el.style.display = 'none'; // 完成后确保隐藏
    },
    goToLogin() {
      this.$router.push('/login');
    },
    goToDashboard() {
      window.open('/dashboard', '_blank'); // 在新标签页中打开管理后台
    },
    logout() {
      this.$store.commit('clearToken');
      this.$router.push('/');
    },
    goToHome() {
      window.location.reload();
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
    toggleSubMenu(menu) {
      if (this.openedMenuId === menu.id) {
        this.openedMenuId = null;
      } else {
        this.openedMenuId = menu.id;
      }
      this.scrollToMenu(menu.id);
    },
  }
};
</script>

<style>
body {
  background-color: #f4f5f7;
  margin: 0;
  font-family: 'Arial', sans-serif;
  overflow: auto;
}

.submenu-arrow {
  float: right;
  margin-right: 10px;
}

.header-container {
  background-color: #ffffff;
  display: flex;
  justify-content: space-between;
  padding: 0 15px;
  align-items: center;
  border-bottom: 1px solid #ebeef5;
  position: fixed;
  top: 0;
  left: 200px;
  z-index: 100;
  width: calc(100% - 200px);
  height: 80px;
  transition: left 0.5s ease-in-out, width 0.5s ease-in-out;
}

.header-expanded {
  left: 0;
  width: 100%;
}

.sidebar-container {
  background-color: #ffffff;
  color: #333333;
  height: 100vh;
  position: fixed;
  top: 0;
  left: 0;
  overflow-y: auto;
  border-right: 1px solid #ebeef5;
  width: 200px;
  transform: translateX(0);
  transition: transform 0.5s ease-in-out;
}

.sidebar-hidden {
  transform: translateX(-100%);
}

.sidebar-shown {
  transform: translateX(0);
}

.main-container, .main-container-expanded {
  transition: margin-left 0.5s ease-in-out;
}

.main-container {
  padding: 20px;
  margin-left: 200px;
  padding-top: 84px;
}

.main-container-expanded {
  padding: 20px;
  margin-left: 0;
  padding-top: 84px;
}

.toggle-sidebar-button {
  margin-right: 20px;
}

.logo {
  display: flex;
  align-items: center;
  padding: 20px;
  cursor: pointer; /* 添加手型光标，指示可以点击 */
}

.logo-img {
  width: 40px;
  height: 40px;
}

.logo-text {
  font-size: 20px;
  font-weight: bold;
  margin-left: 10px;
}

.header-actions {
  display: flex;
  align-items: center;
}

.avatar {
  margin-right: 10px;
}

.username {
  font-weight: bold;
  color: #000;
  padding-left: 10px;
}

.el-menu-vertical-demo:not(.el-menu--collapse) {
  width: 100%;
  min-height: 400px;
  border-right: 0;
  font-weight: bold;
}

.el-header {
  --el-header-padding: 0 20px;
  --el-header-height: 80px;
  box-sizing: border-box;
  flex-shrink: 0;
  height: var(--el-header-height);
  padding: var(--el-header-padding);
}

.menu-icon {
  width: 30px !important;
  height: 30px !important;
  margin-right: 10px !important;
  vertical-align: middle !important;
  -o-object-fit: cover !important;
  object-fit: cover !important;
  box-shadow: none !important;
}

.app-card {
  position: relative;
  display: flex;
  align-items: center;
  padding: 0;
  margin-bottom: 20px;
  height: 100px;
  border-radius: 10px;
  cursor: pointer;
}

.app-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

.app-title {
  font-size: 1rem !important;
  margin: 0 !important;
  white-space: nowrap !important; /* 不换行 */
  overflow: hidden !important;
  text-overflow: ellipsis !important;
  font-weight: 700 !important;
  max-width: 100% !important;
  display: inline-block !important;
  margin-top: 25px !important;
  transition: color 0.3s ease !important;
}

.app-card:hover .app-title {
  color: red;
}

.app-card-content {
  display: flex;
  align-items: center;
  width: 100%;
}

.app-icon-container {
  flex: 0 0 40px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.app-icon {
  width: 45px;
  height: 45px;
  object-fit: cover;
  border-radius: 100%;
  box-shadow: 0 2px 4px rgb(255 255 255 / 10%);
}

.app-info-container {
  flex: 1;
  padding-left: 10px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  height: 100%;
}

.app-description {
  margin-top: 10px;
  font-size: .75rem;
  color: rgb(156 163 175);
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  word-break: break-all;
  line-height: 1.4em;
  min-height: 36px;
}

.app-full-description {
  position: absolute;
  background-color: #444;
  color: white;
  font-family: 'Microsoft YaHei', 'Arial', sans-serif;
  padding: 10px;
  border-radius: 5px;
  z-index: 99999;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
  font-size: 0.78rem;
  line-height: 1.5;
  width: 220px;
  max-width: 220px;
  white-space: normal;
  transform-origin: bottom;
}

.triangle {
  position: absolute;
  width: 0;
  height: 0;
  border-left: 8px solid transparent;
  border-right: 8px solid transparent;
  border-bottom: 8px solid #444;
  top: -6px;
  left: 50%;
  transform: translateX(-50%);
}

.app-full-description[style*="translateY(-100%)"] .triangle {
  top: auto;
  bottom: -6px;
  border-bottom: none;
  border-top: 8px solid #444;
}

.app-category-section {
  margin-bottom: 40px;
}

.section-icon {
  width: 24px;
  height: 24px;
  margin-right: 10px;
  vertical-align: middle;
}

.login-button {
  background-color: transparent;
  border-color: #000 !important;
  color: #000 !important;
  border-radius: 15px;
  padding: 10px 20px;
  font-weight: bold;
  transition: background-color 0.3s, color 0.3s, box-shadow 0.3s;
  box-shadow: none !important;
  outline: none !important; /* 移除 outline */
}

.login-button:hover {
  background-color: #000 !important;
  color: #fff !important;
  box-shadow: 0 1px 5px rgba(0, 0, 0, 0.5) !important;
  border-color: #000 !important;
}

.login-button:focus {
  outline: none !important; /* 确保按钮在获得焦点时没有 outline */
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
  top: calc(100% + 10px); /* 调整菜单位置，留出箭头的空间 */
  right: 0;
  background-color: #fff;
  border: 1px solid #ebeef5;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  z-index: 1000;
  width: 100px;
  margin-top: 5px;
  border-radius: 10px;
  padding-top: 11px; /* 给菜单内容留出空间放箭头 */
  font-size: 0.9rem;
}

/* 增加三角形箭头 */
.dropdown-menu::before {
  content: '';
  position: absolute;
  top: -10px; /* 三角形的底部与菜单顶部对齐 */
  right: 10px; /* 可以根据需要调整箭头的位置 */
  border-width: 0 6px 6px 6px; /* 创建三角形的宽度 */
  border-style: solid;
  border-color: transparent transparent #fff transparent; /* 使箭头颜色与菜单背景一致 */
  z-index: 1001; /* 确保箭头在菜单之上 */
}

.dropdown-menu::after {
  content: '';
  position: absolute;
  top: -10px; /* 三角形的底部与菜单顶部对齐 */
  right: 40%; /* 可以根据需要调整箭头的位置 */
  border-width: 0 8px 8px 8px; /* 创建三角形的宽度 */
  border-style: solid;
  border-color: transparent transparent #ebeef5 transparent; /* 使箭头颜色与边框一致 */
  z-index: 1000; /* 确保箭头的边框在菜单之上 */
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

.el-menu-item * {
  float: right;
  margin-right: 10px;
}

.app-category-section h2 {
  padding-left: 0;
}

.app-category-section h2[style*="padding-left"] {
  padding-left: 10px; /* 使二级菜单与一级菜单对齐 */
}

.menu-section {
  margin-bottom: 40px; /* 统一每个菜单的底部间距 */
}

.menu-title {
  display: flex;
  align-items: center;
  margin-bottom: 20px; /* 菜单标题与内容之间的间距 */
}

.menu-icon {
  margin-right: 10px;
  width: 30px;
  height: 30px;
  object-fit: cover;
}

.app-card-container {
  margin-bottom: 20px; /* 卡片容器与下一个菜单的间距 */
}

.menu-item-wrapper {
  border-bottom: 1px solid #ebeef5; /* 设置分割线的颜色 */
}

.menu-item-wrapper:last-child {
  border-bottom: none; /* 可选：最后一个菜单项不显示分割线 */
}

.slide-fade-enter-active, .slide-fade-leave-active {
  transition: all 0.3s ease;
}

.slide-fade-enter, .slide-fade-leave-to /* .slide-fade-leave-active in <2.1.8 */ {
  opacity: 0;
  transform: translateY(-10px);
}

.icp {
  text-decoration: underline;
}

.back-to-top {
  position: fixed;
  bottom: 80px;
  right: 25px;
  z-index: 1000;
  cursor: pointer;
  transition: opacity 0.3s ease;
}

.back-to-top:hover {
  opacity: 0.8;
}

.hitokoto {
  width: auto; /* 自动根据内容调整宽度 */
  max-width: 40%; /* 设置最大宽度，防止超出 */
  text-align: left;
  font-size: 0.9rem;
  color: #333;
  cursor: pointer;
  margin-left: auto; /* 将 hitokoto 向右对齐 */
  margin-right: auto; /* 同时在右边也保持居中对齐 */
  white-space: normal; /* 允许文字换行 */
  flex-grow: 1; /* 使 hitokoto 在导航栏中占据可用空间 */
}

.hitokoto-text {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2; /* 限制最多显示两行 */
  overflow: hidden; /* 超出部分隐藏 */
  text-overflow: ellipsis; /* 超出部分显示省略号 */
  white-space: normal; /* 允许换行 */
  word-break: break-word; /* 长词语自动换行 */
}

.hitokoto:hover {
  color: rgba(43,80,118,0.71); /* 悬停时更改颜色，提供视觉反馈 */
}

/* 外部容器 */
.hot-rankings-container {
  display: flex;
  align-items: center;
  padding-right: 20px; /* 使其靠右 */
  position: relative;
}

/* 外部容器 */
.hot-rankings-container {
  display: flex;
  align-items: center;
  padding-right: 20px; /* 使其靠右 */
  position: relative;
}

/* 热点榜单字样 */
.hotspot-rankings-toggle {
  cursor: pointer;
  font-weight: bold;
  color: black; /* 字体颜色为黑色 */
  font-size: 16px;
}

/* 一个统一的下拉框 */
.rankings-dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  background-color: white;
  border: 1px solid #ccc;
  width: 400px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  z-index: 1000;
  padding: 10px;
  border-radius: 5px;
  margin-top: 10px;
  height: 430px;
  overflow-y: auto; /* 当内容超过高度时启用滚动 */
}


/* 类别的头部 */
.hot-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
  padding-bottom: 10px;
  border-bottom: 1px solid #ddd;
}

.scroll-button {
  cursor: pointer;
  font-size: 20px;
  user-select: none;
  padding: 5px;
  margin-top: 4px; /* 增加 margin-top */
}

/* 类别水平滑动 */
.hot-categories-wrapper {
  overflow-x: auto;
  display: flex;
  scroll-behavior: smooth; /* 平滑滚动 */
  scrollbar-width: none; /* 隐藏滚动条（Firefox） */
  -ms-overflow-style: none; /* 隐藏滚动条（IE/Edge） */
}

.hot-categories-wrapper::-webkit-scrollbar {
  display: none; /* 隐藏滚动条（Chrome, Safari） */
}

.hot-categories {
  display: flex;
  white-space: nowrap;
  padding: 0 10px;
  scroll-snap-type: x mandatory; /* 启用滑动时的停靠效果 */
}

.hot-categories span {
  padding: 10px 15px;
  cursor: pointer;
  color: #333;
  font-size: 14px;
  scroll-snap-align: start; /* 停靠时对齐到元素的起点 */
}

.hot-categories span.active {
  font-weight: bold;
  color: #1890ff;
  border-bottom: 2px solid #1890ff;
}

/* 热榜列表 */
.hot-list {
  list-style: none;
  padding: 0;
  margin: 0;
  max-height: 500px; /* 根据需要设置合适的高度 */
  overflow-y: auto; /* 内容超过高度时滚动显示 */
}

/* 每一行的条目 */
.hot-item {
  display: flex;
  justify-content: flex-start; /* 保持左对齐 */
  align-items: center;
  padding: 8px 10px;
  border-bottom: 1px solid #ebeef5;
  transition: background-color 0.3s ease;
}

.hot-item:hover {
  background-color: #f0f0f0; /* 悬停时改变背景色 */
}

/* 保持布局 */
.item-content {
  display: flex;
  align-items: center;
  justify-content: space-between; /* 保持标题和热度值两端分布 */
  padding-left: 5px;
  padding-right: 5px; /* 减少右侧内边距 */
  width: 100%; /* 确保内容占据全部宽度 */
}

/* 序号：固定宽度，左对齐 */
.rank-number {
  display: inline-block;
  width: 20px; /* 固定宽度 */
  height: 20px; /* 固定高度 */
  line-height: 20px; /* 垂直居中 */
  text-align: center;
  font-weight: bold;
  font-size: 12px;
  color: white;
  border-radius: 5px;
  margin-right: 10px;
  flex-shrink: 0; /* 防止 rank-number 被缩小 */
}

/* 标题：设置固定宽度，防止挤压 hot-value */
.hot-title {
  flex-grow: 1;
  font-size: 14px;
  text-decoration: none;
  color: #333;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
  text-align: left;
  margin-right: 10px; /* 增加标题和热度值之间的空隙 */
  width: 220px; /* 固定宽度，确保无论是否有省略号都保持一致 */
  transition: color 0.3s ease;
}

.hot-title:hover {
  color: red;
}

/* 热度值：固定宽度，靠右对齐 */
.hot-value {
  font-size: 14px;
  color: #888;
  text-align: right;
  white-space: nowrap;
  width: 70px; /* 固定宽度，确保布局稳定 */
  flex-shrink: 0; /* 防止被压缩 */
}

.hot-rankings-container {
  position: relative;
}

.rankings-dropdown {
  position: absolute;
  top: 100%; /* 确保下拉框位于触发元素的正下方 */
  left: 0;
  background-color: white;
  border: 1px solid #ccc;
  width: 400px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  z-index: 1000;
  padding: 10px;
  border-radius: 5px;
  margin-top: 10px;
  overflow-y: hidden; /* 隐藏多余的滚动条 */
  height: auto; /* 允许弹性高度 */
}

.rankings-dropdown::before {
  content: '';
  position: absolute;
  top: -10px; /* 确保箭头在下拉框上方 */
  left: 20px; /* 调整箭头相对于下拉框的位置，根据需要修改数值 */
  border-width: 0 10px 10px 10px; /* 创建一个倒三角形 */
  border-style: solid;
  border-color: transparent transparent white transparent; /* 设置箭头颜色与下拉框背景一致 */
  z-index: 1001;
}

.rank-number {
  display: inline-block;
  width: 20px; /* 固定宽度 */
  height: 20px; /* 固定高度 */
  line-height: 20px; /* 让数字垂直居中 */
  text-align: center;
  font-weight: bold;
  font-size: 12px; /* 字体大小调整 */
  color: white; /* 文字颜色 */
  border-radius: 5px; /* 圆角 */
  margin-right: 10px; /* 添加间距 */
}


.rank-first {
  background-color: #ff4d4f; /* 第一名背景颜色 */
}

.rank-second {
  background-color: #ffa940; /* 第二名背景颜色 */
}

.rank-third {
  background-color: #ffec3d; /* 第三名背景颜色 */
}

.rank-default {
  background-color: #001529; /* 其他名次的背景颜色（黑色） */
}

.footer-container {
  background-color: #ffffff;
  color: #333333;
  text-align: left;
  position: relative; /* 改为相对定位 */
  width: calc(100% - 200px); /* 计算宽度以适应页面 */
  margin-left: 200px; /* 与左侧边栏对齐 */
  border-top: 1px solid #ebeef5;
  box-sizing: border-box; /* 包括内边距在内 */
  margin-top: 0;
}

.el-footer {
  --el-footer-height: 30px !important;
}
</style>
