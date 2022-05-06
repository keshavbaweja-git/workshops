helm repo add eks https://aws.github.io/eks-charts


helm upgrade -i appmesh-prometheus eks/appmesh-prometheus \
--namespace appmesh-system



        