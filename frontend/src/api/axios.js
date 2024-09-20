// src/api/axios.js

import axios from 'axios';
import store from '../store';  // 引入Vuex Store

// 创建一个Axios实例
const apiClient = axios.create({
    baseURL: process.env.VUE_APP_BASE_API,  // 你可以在.env文件中设置API的基础URL
    timeout: 10000,  // 请求超时时间
});

// 请求拦截器
apiClient.interceptors.request.use(config => {
    const token = store.state.token;
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
}, error => {
    return Promise.reject(error);
});

// 响应拦截器
apiClient.interceptors.response.use(response => {
    return response;
}, error => {
    if (error.response && error.response.status === 401) {
        store.commit('clearToken');  // 清除无效的Token
        alert('您的登录已过期，请重新登录。');
        // 可以在此处重定向到登录页面，或者触发重新登录的流程
    }
    return Promise.reject(error);
});

export default apiClient;
