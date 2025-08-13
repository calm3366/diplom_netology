resource "yandex_vpc_security_group" "regional-k8s-sg" {
  name        = "regional-k8s-sg"
  description = "Правила группы обеспечивают базовую работоспособность кластера Managed Service for Kubernetes. Примените ее к кластеру и группам узлов."
  network_id  = yandex_vpc_network.network.id
  ingress {
    protocol          = "TCP"
    description       = "Правило разрешает проверки доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера Managed Service for Kubernetes и сервисов балансировщика."
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Правило разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol       = "ANY"
    description    = "Правило разрешает взаимодействие под-под и сервис-сервис. Укажите подсети вашего кластера Managed Service for Kubernetes и сервисов."
    v4_cidr_blocks = concat(var.vpc_subnet[0].v4_cidr_blocks, var.vpc_subnet[1].v4_cidr_blocks, var.vpc_subnet[2].v4_cidr_blocks)
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol       = "ICMP"
    description    = "Правило разрешает отладочные ICMP-пакеты из внутренних подсетей."
    v4_cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }
  egress {
    protocol       = "ANY"
    description    = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Yandex Object Storage, Docker Hub и т. д."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "regional-k8s-sg-nodeport" {
  name        = "regional-k8s-sg-nodeport"
  description = "правило для подключения к сервисам из интернета"
  network_id  = yandex_vpc_network.network.id
  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }
}

resource "yandex_vpc_security_group" "regional-k8s-sg-ssh" {
  name        = "regional-k8s-sg-ssh"
  description = "правило для подключения к узлам по SSH"
  network_id  = yandex_vpc_network.network.id
  ingress {
    protocol       = "TCP"
    description    = "SSH доступ"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
}

resource "yandex_vpc_security_group" "regional-k8s-sg-api" {
  name        = "regional-k8s-sg-api"
  description = "правила для доступа к API Kubernetes"
  network_id  = yandex_vpc_network.network.id
  ingress {
    protocol       = "TCP"
    description    = "правила для доступа к API Kubernetes"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
  ingress {
    protocol       = "TCP"
    description    = "правила для доступа к API Kubernetes"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 6443
  }
}