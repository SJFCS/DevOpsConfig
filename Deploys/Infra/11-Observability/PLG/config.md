s3:
access:
XphirMnytMYAb6CPHghd
secret:
qYZBEChsjPGMWxjAijHtF8xjIU1Q7OUxkOw9gfAB




## 部署优化
- 数据压缩
- 标签和索引
- Querier HPA 扩容

上面的部署案例已经在数据压缩、索引、HPA 等方面进行优化了。

**数据压缩**

Loki 默认使用 gzip 压缩算法，但是 gzip 解压速度比较慢，推荐使用 zstd 压缩，两者的比较请参考 [从 gzip 切换到 zstd](https://www.oschina.net/news/207430/aws-from-gzip-to-zstd)

loki:
  ingester:
    chunk_encoding: zstd


**TSDB 索引**
Loki v2.8 引入的 TSDB 比旧版本的索引方案具有更优的性能，请参考 [官方文档](https://grafana.com/docs/loki/latest/operations/storage/tsdb/)



loki:
  storage_config:
    tsdb_shipper:


**增加吞吐量**

loki:
  limits_config:
    ingestion_rate_strategy: local    # default = "global"
    # retention_period: 240h
    ingestion_rate_mb: 20    # default = 4
    ingestion_burst_size_mb: 100    # default = 6
    per_stream_rate_limit: 6MB    # default = 3MB
    per_stream_rate_limit_burst: 50MB    # default = 15MB
    max_concurrent_tail_requests: 20
    max_cache_freshness_per_query: 10m
    max_query_length: 72h
    max_line_size: 256kb
    max_line_size_truncate: true
    ## [max_streams_matchers_per_query: <int> | default = 1000]
    ## [max_query_bytes_read: <int> | default = 0B]
    shard_streams:
      enabled: true
      desired_rate: 2097152    #2MiB
  
  server:
    grpc_server_max_recv_msg_size: 32000100    # default = 4194304
    grpc_server_max_send_msg_size: 32000100    # default = 4194304

**自定义标签**

[INFO] Reloading
[INFO] plugin/reload: Running configuration SHA512 = 637429c29e6628b9c013e5f8bd5211d4564943dd9f2dd6eeb506a5a2993177f61da856d85e9ed3c8020ebde2b4abbc232f057d9ba5d9df8247d706893feb8754
[INFO] Reloading complete
[ERROR] plugin/errors: 2 cm-cn-central-00001.albatross.10086.cn. HTTPS: read tcp 10.4.63.250:47580->100.100.2.136:53: i/o timeout

在部署 Promtail 的时候可以提取日志级别作为标签：

```
- match:
    ## 匹配容器名以 java 开头的容器
    selector: '{container=~"java.*"}'
    stages:
    - multiline:
        ## 跨行合并
        firstline: '^\[[A-Z]{3,9}\] '
        max_wait_time: 3s
        max_lines: 2000
    - regex:
        expression: '^\[(?P<level>[A-Z]{3,9})\] '
        #source: log
    - labels:
        level:
```
上面这个案例会提取每条日志从行首开始中括号里的大写字母并打上 level 标签，查询条件加上 level 标签可以显著提升查询效率。



**网络带宽和存储IO**

如果日志量比较大，建议 Kubernetes 节点选择 10G 以上的网络带宽，因为 Querier 可以分布到多个节点，所以节点网络带宽的压力可以稀释，带宽瓶颈会转移到后端存储。如果云平台对象存储的性能不能满足需求，可以考虑裸机部署 MinIO 存储。



给日志增加自定义标签，提升查询效率。
在 Loki 微服务架构中，查询日志时 Querier 需要消耗大量 CPU 和网络带宽，但它并不需要稳定的机器。可以把 querier 调度到廉价的 spot 节点，并尽可能均匀地分布到多台节点上，用较低的成本大幅度提升查询速度。
加快 Querier HPA 扩容速度。