import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import store from './store';
import ElementPlus from 'element-plus';
import 'element-plus/dist/index.css';
import { getIcon } from '@iconify/vue';
import 'element-plus/theme-chalk/index.css';

const app = createApp(App);

app.use(store);
app.use(router);
app.use(ElementPlus);

app.mount('#app');





// 定义 isUrl 方法
function isUrl(string) {
    return string.startsWith('http://') || string.startsWith('https://');
}

// 定义 isIconifyIcon 方法，判断是否为 :icon 格式的 Iconify 图标
function isIconifyIcon(string) {
    return string && string.includes(':');
}

// 动态更新页面标题和图标
store.dispatch('fetchSiteSettings').then(() => {
    const siteSettings = store.getters.siteSettings;
    updateIconAndTitle(siteSettings);

    // 监听 store 里的设置变化并动态更新图标
    store.watch(
        (state) => state.siteSettings,
        (newSettings) => {
            updateIconAndTitle(newSettings);
        }
    );
}).catch(() => {
    // 获取失败时，使用默认标题和图标
    updateIconAndTitle({
        title: window.location.pathname === '/' ? 'zh导航' : '管理系统',
        icon: window.location.pathname === '/'
            ? 'https://img1.baidu.com/it/u=1217061905,2277984247&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'
            : ''
    });
});

// 更新图标和标题
function updateIconAndTitle(settings) {
    let siteIcon = settings.icon;

    if (isUrl(siteIcon)) {
        // 如果是 URL 图标，直接使用 URL 更新 favicon
        setFavicon(siteIcon);
    } else if (isIconifyIcon(siteIcon)) {
        // 如果是 Iconify 图标，通过 Iconify 处理
        setIconifyIcon(siteIcon);
    } else {
        // 默认使用一个图标
        setFavicon('https://img1.baidu.com/it/u=1217061905,2277984247&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500');
    }

    // 更新标题
    if (window.location.pathname === '/') {
        document.title = settings.title || 'zh导航';
    } else {
        document.title = '管理系统';
    }
}

// 设置 URL 图标为 favicon
function setFavicon(iconUrl) {
    const link = document.querySelector("link[rel~='icon']");
    if (link) {
        link.href = iconUrl;
    } else {
        const newLink = document.createElement('link');
        newLink.rel = 'icon';
        newLink.href = iconUrl;
        document.head.appendChild(newLink);
    }
}

// 设置 Iconify 图标为 favicon
function setIconifyIcon(iconName) {
    try {
        // 获取 Iconify 图标的 SVG 数据
        const iconData = getIcon(iconName);

        if (!iconData) {
            console.error('Icon not found');
            return;
        }

        // 构造 SVG 图标，并确保图标居中
        const svg = `
            <svg xmlns="http://www.w3.org/2000/svg" 
                 width="64" height="64" 
                 viewBox="0 0 ${iconData.width} ${iconData.height}" 
                 preserveAspectRatio="xMidYMid meet">
                <g transform="translate(0, 4)">
                    ${iconData.body}
                </g>
            </svg>
        `;

        const svgUrl = `data:image/svg+xml,${encodeURIComponent(svg)}`;

        // 设置生成的 SVG 图标为 favicon
        setFavicon(svgUrl);
    } catch (error) {
        console.error('Error loading icon:', error);
    }
}