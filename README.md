# znav
## Docker部署
```shell
mkdir /data && cd /data
git clone https://github.com/zhanghao123321/znav.git
cd znav
### 修改docker-compose.image.yml文件
vim docker-compose.image.yml

### 已构建后镜像运行
docker-compose -f docker-compose.image.yml up -d

### 重新构建镜像运行
docker-compose -f docker-compose.build.yml up --build -d

### web访问：
http:ip
admin
admin

```
前台：
![image](https://github.com/zhanghao123321/znav/blob/main/foreground.png)

后台：
![image](https://github.com/zhanghao123321/znav/blob/main/background.png)

## K8S部署
```
git clone https://github.com/zhanghao123321/znav.git
cd znav
kubectl apply -f mysql-pv.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f znav-ingress.yaml
```
