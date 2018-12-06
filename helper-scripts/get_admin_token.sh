#kubectl -n kube-system describe secret admin-user-token-lzvvg
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

