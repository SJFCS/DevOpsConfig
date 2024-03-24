## 参考
https://github.com/bitnami-labs/sealed-secrets?tab=readme-ov-file#helm-chart

https://dev.to/timtsoitt/argo-cd-and-sealed-secrets-is-a-perfect-match-1dbf
https://piotrminkowski.com/2022/12/14/sealed-secrets-on-kubernetes-with-argocd-and-terraform/
https://foxutech.medium.com/bitnami-sealed-secrets-kubernetes-secret-management-86c746ef0a79
https://docs.bitnami.com/tutorials/sealed-secrets

https://github.com/bitnami-labs/sealed-secrets/blob/main/docs/bring-your-own-certificates.md
https://docs.bitnami.com/tutorials/sealed-secrets
https://www.qikqiak.com/post/encrypt-k8s-secrets-with-sealed-secrets/
https://dev.to/ashokan/sealed-secrets-bring-your-own-keys-and-multi-cluster-scenario-1ee8
https://ismailyenigul.medium.com/take-backup-of-all-sealed-secrets-keys-or-re-encrypt-regularly-297367b3443
https://leeshengis.com/archives/629657
https://majinghe.github.io/devsecops/secret-encrypt/

## 安装
https://artifacthub.io/packages/helm/bitnami-labs/sealed-secrets

```bash
Repo=https://bitnami-labs.github.io/sealed-secrets
Chart=sealed-secrets
Target=sealed-secrets
NameSpace=kube-system

helm upgrade --install ${Target} ${Chart} \
  --repo ${Repo} \
  --namespace ${NameSpace} \
  --create-namespace \
  --set-string fullnameOverride=sealed-secrets-controller 
  --set customKey=YOUR_CUSTOM_KEY_HERE 指定私钥？，指定轮换周期？ 指定？
```
- --set-string fullnameOverride=sealed-secrets-controller 这个参数会 kube-system 命名空间里创建 sealed-secrets-controller 使得 kubeseal  命令不用加 --controller-name=sealed-secrets-controller  --controller-namespace=kube-systems 显示声明
- SealedSecret 和 Secret 必须具有相同的命名空间和名称。此功能可防止同一集群上的其他用户重复使用您密封的密钥。
- 不再需要与密钥相关的 YAML 清单，SealedSecret 是唯一将部署到群集的资源
- 控制器在首次部署时会生成自己的证书，它还会为您管理续订。但您也可以自带证书，以便控制器也可以使用它们。
- 控制器使用任何标记为 sealedsecrets.bitnami.com/sealed-secrets-key=active 的密钥中包含的证书，该密钥必须与控制器位于同一命名空间中。可以有多个这样的秘密。

## 使用
加密 secret
```bash
# 默认限制命名空间
kubectl create secret generic secret-name --dry-run=client --from-literal=foo=bar -o yaml | \
kubeseal --format yaml > mysealedsecret.yaml

# --scope 全局可用生成的密文可以在整个集群中使用，而不是仅限于特定的命名空间
kubectl create secret generic secret-name --dry-run=client --from-literal=foo=bar -o yaml >mysecret.yaml 
kubeseal --format yaml --scope cluster-wide < mysecret.yaml  > mysealedsecret2.yaml
```


导出公钥
```bash
kubeseal --fetch-cert > public-key-cert.pem
```
然后使用 kubeseal 使用公钥文件创建 SealedSecret CRD，如下所示：
```bash
kubeseal --format=yaml --cert=public-key-cert.pem < secret.yaml > sealed-secret.yaml
```
导出私钥 待补充
```bash
kubectl -n kube-system get secret -l sealedsecrets.bitnami.com/sealed-secrets-key=active -o yaml  | kubectl neat > allsealkeys.yml
```
解密文件
```bash
kubeseal --private-key=my-private-key.pem < my-sealed-secret.yaml > my-decrypted-secret.yaml
```

# 证书轮转
https://ismailyenigul.medium.com/take-backup-of-all-sealed-secrets-keys-or-re-encrypt-regularly-297367b3443


默认情况下，sealed secrets 证书每 30 天自动更新一次。并且 kubeseal 使用最新的密钥来加密新的秘密。

但 sealed secrets 不会自动轮换，并且生成新密钥时不会删除旧密钥。旧的密封秘密资源仍然可以解密。

假如有一天你的集群无法访问，而且你的secret文件使用kubeseal加密后存储在git上，那么你将无法访问和解锁普通secret文件，你必须从头开始在新集群中重新创建所有秘密并更新部署。这是最坏的情况！但你应该为这种情况做好准备。

## Possible solutions: 可能的解决方案：

- Solution #1 解决方案#1

定期备份所有密封密钥并将其存储在安全的地方，并在新集群中需要时恢复。您可以使用以下命令转储 kube-system 命名空间中的所有活动密封密钥。

```bash
$ kubectl -n kube-system get secret -l sealedsecrets.bitnami.com/sealed-secrets-key=active -o yaml  | kubectl neat > allsealkeys.yml
```
> PS：您可以使用 [kubectl neat](https://github.com/itaysk/kubectl-neat) 插件来删除 yaml 输出中不必要的行

- Solution #2 解决方案#2
使用 [own generated certificate](https://github.com/bitnami-labs/sealed-secrets/blob/main/docs/bring-your-own-certificates.md) 并通过设置 key-renew-period=0 禁用密钥轮换,但这是一种不太安全的方式。

- Solution #3 解决方案#3


每当 sealed-secrets 创建新证书时，请重新加密 Re-encrypt 您现有的秘密。您在 git 存储库中的秘密将使用最新的密钥进行加密，并且只需备份最新的密钥即可。有关更多详细信息，请参阅 https://github.com/bitnami-labs/sealed-secrets#re-encryption-advanced。



# 自定义密钥
设置变量
```bash
export PRIVATEKEY="default.key"
export PUBLICKEY="default.crt"
export NAMESPACE="sealed-secrets"
export SECRETNAME="mycustomkeys"
export DAYS="3650"
```
生成新的 RSA 密钥对（证书）
```bash
openssl req -x509 -days ${DAYS} -nodes -newkey rsa:4096 -keyout "$PRIVATEKEY" -out "$PUBLICKEY" -subj "/CN=sealed-secret/O=sealed-secret"
```
使用您最近创建的 RSA 密钥对创建 tls k8s 密钥
```bash
kubectl -n "$NAMESPACE" create secret tls "$SECRETNAME" --cert="$PUBLICKEY" --key="$PRIVATEKEY"
kubectl -n "$NAMESPACE" label secret "$SECRETNAME" sealedsecrets.bitnami.com/sealed-secrets-key=active
```
需要删除控制器 Pod 才能选择新密钥
```bash
kubectl -n  "$NAMESPACE" delete pod -l name=sealed-secrets-controller
```
查看控制器日志中的新证书（私钥）
```bash
kubectl -n "$NAMESPACE" logs -l name=sealed-secrets-controller

controller version: v0.12.1+dirty
2020/06/09 14:30:45 Starting sealed-secrets controller version: v0.12.1+dirty
2020/06/09 14:30:45 Searching for existing private keys
2020/06/09 14:30:45 ----- sealed-secrets-key5rxd9
2020/06/09 14:30:45 ----- mycustomkeys
2020/06/09 14:30:45 HTTP server serving on :8080
```

试用您自己的证书
现在，您可以尝试使用自己的证书来密封密钥，而不是使用控制器提供的证书。

使用 --cert 以下标志使用自己的证书（密钥）：

```bash
kubeseal --cert "./${PUBLICKEY}" --scope cluster-wide < mysecret.yaml | kubectl apply -f-
```
我们可以看到秘密已经成功解封
```bash
kubectl -n "$NAMESPACE" logs -l name=sealed-secrets-controller

controller version: v0.12.1+dirty
2020/06/09 14:30:45 Starting sealed-secrets controller version: v0.12.1+dirty
2020/06/09 14:30:45 Searching for existing private keys
2020/06/09 14:30:45 ----- sealed-secrets-key5rxd9
2020/06/09 14:30:45 ----- mycustomkeys
2020/06/09 14:30:45 HTTP server serving on :8080
2020/06/09 14:37:55 Updating test-namespace/mysecret
2020/06/09 14:37:55 Event(v1.ObjectReference{Kind:"SealedSecret", Namespace:"test-namespace", Name:"mysecret", UID:"f3a6c537-d254-4c06-b08f-ab9548f28f5b", APIVersion:"bitnami.com/v1alpha1", ResourceVersion:"20469957", FieldPath:""}): type: 'Normal' reason: 'Unsealed' SealedSecret unsealed successfully
```
$PRIVATEKEY 是您的私钥，控制器使用它来解封您的密钥。不要与任何你不信任的人分享它，并将其保存在一个安全的地方！









