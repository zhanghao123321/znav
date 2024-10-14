# znav
## Docker部署
```shell
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
![image](https://github.com/user-attachments/assets/4f1def89-5d57-4e55-b8a8-1d6e6d38c331)

后台：
![image](https://github.com/user-attachments/assets/87aae9cf-f0b9-49d0-8871-44db2f81964c)

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
