cd ~
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.20.3 TARGET_ARCH=x86_64 sh -
cd istio-1.20.3
export PATH=$PWD/bin:$PATH
istioctl install -f my-config.yaml









## 让我们安装Istio operator：

istioctl operator init

## 现在，让我们实例化服务网格。 Istio 代理在 #0# 中包含一个 traceID。请注意，您将设置访问日志以将该跟踪 ID 作为日志消息的一部分注入：


kubectl apply -f - << 'EOF'
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  name: istio-operator
  namespace: istio-system
spec:
 profile: default
 meshConfig:
   accessLogFile: /dev/stdout
   accessLogFormat: |
     [%START_TIME%] "%REQ(:METHOD)% %REQ(X-ENVOY-ORIGINAL-PATH?:PATH)% %PROTOCOL%" %RESPONSE_CODE% %RESPONSE_FLAGS% %RESPONSE_CODE_DETAILS% %CONNECTION_TERMINATION_DETAILS% "%UPSTREAM_TRANSPORT_FAILURE_REASON%" %BYTES_RECEIVED% %BYTES_SENT% %DURATION% %RESP(X-ENVOY-UPSTREAM-SERVICE-TIME)% "%REQ(X-FORWARDED-FOR)%" "%REQ(USER-AGENT)%" "%REQ(X-REQUEST-ID)%" "%REQ(:AUTHORITY)%" "%UPSTREAM_HOST%" %UPSTREAM_CLUSTER% %UPSTREAM_LOCAL_ADDRESS% %DOWNSTREAM_LOCAL_ADDRESS% %DOWNSTREAM_REMOTE_ADDRESS% %REQUESTED_SERVER_NAME% %ROUTE_NAME% traceID=%REQ(x-b3-traceid)%
   enableTracing: true
   defaultConfig:
     tracing:
       sampling: 100
       max_path_tag_length: 99999
       zipkin:
         address: otel-collector.tracing.svc:9411
EOF