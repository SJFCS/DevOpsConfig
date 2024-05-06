## 安装 Node exporter

``` shell
docker run -d \
  --name="prom-node-exporter" \
  --restart="always" \
  --net="host" \
  --pid="host" \
  -v "/:/rootfs:ro,rslave" \
  prom/node-exporter:latest \
  --path.rootfs=/rootfs
```

## 安装 cadvisor exporter

``` shell
sudo docker run \
  --restart="always" \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=prom-cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor:latest
```

## 安装 Kafka exporter

``` shell
docker run -d \
  --name="prom-kafka-exporter" \
  --restart="always" \
  --publish="9308:9308" \
  danielqsj/kafka-exporter \
  --kafka.server=kafka:9092

docker run -it --rm -p 9308:9308 danielqsj/kafka-exporter --kafka.server=kafka:9092
```
