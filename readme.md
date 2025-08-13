# Дипломный практикум в Yandex.Cloud
## Создание облачной инфраструктуры и Kubernetes кластера
```vim
Terraform v1.5.7
on darwin_amd64

Your version of Terraform is out of date! The latest version
is 1.8.4. You can update by downloading from https://www.terraform.io/downloads.html
```
#### backend для Terraform в S3 bucket YC:
- [providers.tf](terr/providers.tf) 

`terraform init -backend-config=secret.backend.tfvars`
#### Terraform манифесты:

- [terraform folder](terr/) 

![!\[Alt text\](<img/!\[Alt text\](<img/2.png>)>)](<img/2.png>)
## Создание тестового приложения

- [Git репозиторий с тестовым приложением и Dockerfile](https://gitlab.com/group01734935/my-nginx)

### Yandex Registry

Образ: `cr.yandex/crpdgkjqba4kiu6sm7bq/netology-web:3.11.5`

## Подготовка cистемы мониторинга и деплой приложения
#### Деплоим в кластер стек [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus/tree/release-0.13) версии 0.13, т.к. версия kubernetes 1.26
```shell
kubectl apply --server-side -f manifests/setup
kubectl wait \
	--for condition=Established \
	--all CustomResourceDefinition \
	--namespace=monitoring
kubectl apply -f manifests/
```
*Предварительно изменяем тип cервиса grafana на LoadBalancer*
- [kube-prometheus manifests](k8s/manifests) 

Ссылка на веб интерфейс [Grafana](http://158.160.146.243) (креды стандартные)
- Общедоступный дашборд - [ссылка](http://158.160.146.243/dashboard/snapshot/hU1Hok9muPYxdsp1A99YdHY2dhhr2v01?orgId=0&refresh=30s&from=now-30m&to=now)


Деплоим Service для приложения и ServiceAccount для удаленного подключения из CI/CD в кластер

- [serviceaccount.yaml](k8s/serviceaccount.yaml) 
- [service-nginx.yaml](k8s/service-nginx.yaml) 

Ссылка на веб интерфейс собственной страницы: [My webpage](http://158.160.155.47)

![!\[Alt text\](<img/!\[Alt text\](<img/3.png>)>)](<img/3.png>)

## Установка и настройка CI/CD

Последний pipeline из [Gitlab с версией тестового приложения 3.11.5 ](https://gitlab.com/group01734935/my-nginx/-/pipelines/1326135501)

- [deployment-nginx.yaml](k8s/deployment-nginx.yaml) 
В Deployment установлен якорь "IMAGE_TAG" для автоматического изменения тега приложения и деплоя.

- [.gitlab-ci.yml](https://gitlab.com/group01734935/my-nginx/-/blob/master/.gitlab-ci.yml) 

После внесения изменений в репозиторий с тестовым приложением, автоматически собирается образ и отправляется в реджистри.

- Если отправлен коммит без тега - собирается latest версия и пушится в репозиторий.
- Если отправлен коммит с любым тегом - собирается соответсвующий образ, пушится в репозиторий и деплоится в кластер.

#### Также для успешного деплоя в кластер для CI/CD пайплайна необходимо предварительно добавить токен и сертификат подключения к кластеру в переменные GitLab:
```
SA_TOKEN=$(kubectl -n kube-system get secret $(kubectl -n kube-system get secret | \
  grep admin-user-token | \
  awk '{print $1}') -o json | \
  jq -r .data.token | \
  base64 -d)
```
``` 
yc managed-kubernetes cluster get --id $CLUSTER_ID --format json | \
  jq -r .master.master_auth.cluster_ca_certificate | \
  awk '{gsub(/\\n/,"\n")}1' > ca.pem 
```
где, 

**$CLUSTER_ID** - ID кластера в YCloud

внешний IP-адрес автоматически подставится из файла, сформированного при деплое кластера в переменную **$K8S_MASTER_IP**

	
![!\[Alt text\](<img/!\[Alt text\](<img/6.png>)>)](<img/6.png>)
![!\[Alt text\](<img/!\[Alt text\](<img/7.png>)>)](<img/7.png>)
![!\[Alt text\](<img/!\[Alt text\](<img/8.png>)>)](<img/8.png>)

![!\[Alt text\](<img/!\[Alt text\](<img/4.png>)>)](<img/4.png>)
