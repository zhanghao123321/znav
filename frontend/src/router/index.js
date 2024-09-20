import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'
import Dashboard from '../views/Dashboard.vue'
import AppManagement from '../views/AppManagement.vue'
import AppNavigation from '../views/AppNavigation.vue'
import MenuManagement from '../views/MenuManagement.vue'
import SiteSettings from '../views/SiteSettings.vue'
import Admin from '../views/Admin.vue';

const routes = [
    { path: '/login', component: Login },
    { path: '/dashboard', component: Dashboard, meta: { requiresAuth: true } },
    { path: '/apps', component: AppManagement, meta: { requiresAuth: true } },
    { path: '/menus', component: MenuManagement, meta: { requiresAuth: true } },
    { path: '/admin', component: Admin, meta: { requiresAuth: true } },
    { path: '/settings', component: SiteSettings, meta: { requiresAuth: true } },
    { path: '/', component: AppNavigation },
]

const router = createRouter({
    history: createWebHistory(process.env.BASE_URL),
    routes,
})

router.beforeEach((to, from, next) => {
    const loggedIn = !!localStorage.getItem('token');
    if (to.matched.some(record => record.meta.requiresAuth) && !loggedIn) {
        next('/login');
    } else {
        // 延迟导航，确保 Vuex 状态同步后再跳转
        setTimeout(() => {
            next();
        }, 200);  // 延迟200ms，确保渲染完成
    }
});


export default router
