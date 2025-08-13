
output "k8s-cluster-id" {
  value = "Чтобы подключится к кластеру, используйте команду: yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.k8s-cluster.id} --external --force"
}

output "registry-id" {
  value = "Registry ID для собственных докер образов = ${yandex_container_registry.my-docker-registry.id}"
}