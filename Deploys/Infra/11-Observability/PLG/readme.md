https://aleiwu.com/img/loki/loki-arch.png

目前 loki 的运行模式还是 All in One 的, 即distributor, querier, ingester这些组件全都跑在 loki 主进程里. 不过这些组件之间的交互全都通过 gRPC 完成, 因此只要稍加改造就能作为一个分布式系统来跑.


distributor 直接接收来自 promtail 的日志写入请求后, 会将一个 PushRequest 中的 Stream 根据 labels 拆分成多个 PushRequest, 这个过程使用一致性哈希:

在 All in One 的运行模式中, hash ring 直接存储在内存中. 在生产环境, 由于要起多个 distributor 节点做高可用, 这个 hash ring 会存储到外部的 Consul 集群中.

ingester 接收 distributor 下发的 PushRequest, 也就是多段日志流([]Entry). 在 ingester 内部会先将收到的 []Entry Append 到内存中的 Chunk 流([]Chunk). 同时会有一组 goroutine 异步将 Chunk 流存储到对象存储当中:

https://aleiwu.com/img/loki/loki-ingester.png


Chunk 其实就是多条日志构成的压缩包. 将日志压成 Chunk 的意义是可以直接存入对象存储, 而对象存储是最便宜的(便宜是 loki 的核心目标之一). 在 一个 Chunk 到达指定大小之前它就是 open 的, 会不断 Append 新的日志(Entry) 到里面. 而在达到大小之后, Chunk 就会关闭等待持久化(强制持久化也会关闭 Chunk, 比如关闭 ingester 实例时就会关闭所有的 Chunk并持久化).

对 Chunk 的大小控制是一个调优要点:

假如 Chunk 容量过小: 首先是导致压缩效率不高. 同时也会增加整体的 Chunk 数量, 导致倒排索引过大. 最后, 对象存储的操作次数也会变多, 带来额外的性能开销;
假如 Chunk 过大: 一个 Chunk 的 open 时间会更长, 占用额外的内存空间, 同时, 也增加了丢数据的风险. 最后, Chunk 过大也会导致查询读放大, 比方说查一小时的数据却要下载整天的 Chunk;
丢数据问题: 所有 Chunk 要在 close 之后才会进行存储. 因此假如 ingester 异常宕机, 处于 open 状态的 Chunk, 以及 close 了但还没有来得及持久化的 Chunk 数据都会丢失. 从这个角度来说, ingester 其实也是 stateful 的, 在生产中可以通过给 ingester 跑多个副本来解决这个问题. 另外, ingester 里似乎还没有写 WAL, 这感觉是一个 PR 机会, 可以练习一下写存储的基本功.



最后是 Querier, 这个比较简单了, 大致逻辑就是根据chunk index中的索引信息, 请求 ingester 和对象存储. 合并后返回. 这里主要看一下”合并”操作:



最后想说的是, 现今摩尔定律已近失效, 没有了每年翻一番的硬件性能, 整个后端架构需要更精细化地运作. 像以前那样用昂贵的全文索引或者列式存储直接存大量低价值的日志信息(99%没人看)已经不合时宜了. 在程序的运行信息(“日志”)和埋点,用户行为等业务信息(也是”日志”)之间进行业务,抽象与架构上的逐步切分, 让各自的架构适应到各自的 ROI 最大的那个点上, 会是未来的趋势, 而 Grafana Loki 则恰到好处地把握住了这个趋势.