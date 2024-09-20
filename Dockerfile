# 使用 Go 官方镜像作为基础镜像
FROM golang:1.20-alpine

# 设置工作目录
WORKDIR /app

# 设置 Go Modules 代理，避免网络问题
ENV GOPROXY=https://goproxy.cn,direct

# 将当前目录的所有文件复制到容器中
COPY . .

# 复制 .env 文件到容器中
COPY ./backend/.env .env

# 进入 backend 目录，并下载安装 Go module 依赖
WORKDIR /app/backend

# 下载安装 Go module 依赖
RUN go mod tidy

# 编译 Go 应用为二进制文件
RUN go build -o main .

# 暴露服务端口（假设 Go 服务运行在 8080 端口）
EXPOSE 8080

# 设置启动命令
CMD ["./main"]