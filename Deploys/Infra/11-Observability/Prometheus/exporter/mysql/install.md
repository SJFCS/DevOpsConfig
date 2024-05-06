## mysql instance

kubectl create deploy mysql-dev --image=registry.cn-beijing.aliyuncs.com/dotbalo/mysql:5.7.23 
kubectl  set env deploy/mysql-dev  MYSQL_ROOT_PASSWORD=mysql 
kubectl expose deploy mysql-dev --port 3306
# kubectl exec -ti mysql-69d6f69557-5vnvg  -- bash
mysql -uroot -pmysql 
mysql> CREATE USER 'exporter'@'%' IDENTIFIED BY 'exporter' WITH MAX_USER_CONNECTIONS 3;
mysql> GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';

kubectl create deploy mysql-test --image=registry.cn-beijing.aliyuncs.com/dotbalo/mysql:5.7.23 
kubectl  set env deploy/mysql-test  MYSQL_ROOT_PASSWORD=mysql 
kubectl expose deploy mysql-test --port 3306
# kubectl exec -ti mysql-69d6f69557-5vnvg  -- bash
mysql -uroot -pmysql 
CREATE USER 'exporter'@'%' IDENTIFIED BY 'exporter' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';


## install
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm  upgrade --install  mysql-exporter prometheus-community/prometheus-mysql-exporter -f values.yaml


https://grafana.com/grafana/dashboards/6239