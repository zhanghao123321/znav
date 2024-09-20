import { createStore } from 'vuex';
import axios from 'axios';

export default createStore({
    state: {
        token: localStorage.getItem('token') || null,
        user: {
            username: '',
        },
        siteSettings: {
            title: '',
            icon: '',
            footerInfo: '',
            recordNumber: ''
        },
    },
    mutations: {
        setToken(state, token) {
            state.token = token;
            localStorage.setItem('token', token);
        },
        setUser(state, user) {
            state.user = user;  // 更新 Vuex 中的用户数据
        },
        clearToken(state) {
            state.token = null;
            state.user = {};  // 清空用户数据
            localStorage.removeItem('token');
        },
        setSiteSettings(state, settings) {
            state.siteSettings = settings;
        },
        updateSiteSetting(state, { key, value }) {
            state.siteSettings[key] = value;
        }
    },
    actions: {
        fetchUserData({ commit, state, dispatch }) {
            return new Promise((resolve, reject) => {
                if (!state.token) {
                    reject(new Error('No token available'));
                    return;
                }

                axios.get(`${process.env.VUE_APP_API_URL}/user`, {
                    headers: {
                        Authorization: `Bearer ${state.token}`
                    }
                }).then(response => {
                    commit('setUser', response.data.user);  // 提交提取后的 user 对象
                    resolve(response.data.user);  // 确保返回的是用户数据
                }).catch(error => {
                    if (error.response && error.response.status === 404) {
                        console.error('User data not found.');
                    }
                    if (error.response && error.response.status === 401) {
                        dispatch('logout'); // token 过期，执行登出操作
                    }
                    reject(error);
                });
            });
        },
        fetchSiteSettings({ commit, state }) {
            return axios.get(`${process.env.VUE_APP_API_URL}/settings`, {
                headers: { Authorization: `Bearer ${state.token}` }
            })
                .then(response => {
                    commit('setSiteSettings', response.data);
                })
                .catch(error => {
                    console.error('Failed to fetch site settings:', error);
                });
        },
        updateSiteSettings({ commit, state }, settings) {
            return axios.put(`${process.env.VUE_APP_API_URL}/settings`, settings, {
                headers: { Authorization: `Bearer ${state.token}` }
            })
                .then(response => {
                    commit('setSiteSettings', response.data);
                })
                .catch(error => {
                    console.error('Failed to update site settings:', error);
                    throw error;
                });
        },
        logout({ commit }) {
            commit('clearToken');
            this.$router.push('/login'); // 跳转到登录页面
        }
    },
    getters: {
        isAuthenticated: state => !!state.token,
        userData: state => state.user,  // 返回用户的所有信息
        siteSettings: state => state.siteSettings,
        username: state => state.user.username || '管理员',  // 从 state.user 中返回用户名
    },
});
