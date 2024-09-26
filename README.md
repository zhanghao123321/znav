# znav
## Docker部署
```shell
git clone https://github.com/zhanghao123321/znav.git
cd znav
docker-compose up -d --build
```

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