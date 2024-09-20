# 使用 Node.js 官方镜像构建前端应用
FROM node:18 as build

# 设置工作目录
WORKDIR /app

# 复制 frontend 文件夹的内容到容器中
COPY . /app

# 安装依赖
RUN npm --registry https://registry.npmmirror.com/ install

# 构建前端应用
RUN npm --registry https://registry.npmmirror.com/ run build

# 使用 Nginx 来部署前端应用
FROM nginx:alpine

# 拷贝 Nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 复制前端构建产物到 Nginx 的默认目录
COPY --from=build /app/dist /usr/share/nginx/html

# 暴露 Nginx 默认的 80 端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]