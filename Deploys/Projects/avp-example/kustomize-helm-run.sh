https://github.com/kubernetes-sigs/kustomize/blob/master/examples/chart.md

function kustomizeIt {
    kustomize build \
    --enable-helm \
    $1
}

# 现在构建两个变体 dev 和 prod 并比较它们的差异：
vimdiff <(kustomizeIt overlay/dev) <(kustomizeIt overlay/prod)

如果chart存在，kustomize 不会覆盖它, kustomize 不会检查日期或版本号，也不会执行任何类似缓存管理的操作。
