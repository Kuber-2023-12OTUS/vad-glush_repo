v.0.13 #ДЗ Установка и использование CSI драйвера

- Создание ServiceAccount в Yandex Cloud
yc iam service-account create --name my-service-account
- Генерация ключей доступа для ServiceAccount
yc iam access-key create --service-account-name my-service-account
- Перевод id и secret в base64
echo -n "XXXXX" | base64
- `secret.yaml` -  secret c ключами для доступа к Object Storage
- `storageclass.yaml` - storageClass описýваĀщий класс хранилища
- `pvc.yaml` - манифест PVC, использующий для хранения созданный storageClass
- `pod.yaml` - манифест pod использующий созданный ранее PVC в качестве volume

v.0.12 #ДЗ Хранилище секретов для приложения Vault.

helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm install consul hashicorp/consul -f kubernetes-vault/consul-values.yaml --namespace consul --create-namespace
helm install vault hashicorp/vault -f kubernetes-vault/vault-values.yaml --namespace vault --create-namespace

- `sa-vault-auth.yaml` - serviceAccount с именем vault-auth иClusterRoleBinding длā него с ролþĀ system:auth-delegator

- Cоздания роли `auth/kubernetes/role/otus`
vault write auth/kubernetes/role/otus \
    bound_service_account_names=vault-auth \
    bound_service_account_namespaces=vault \
    policies=otus-policy \
    ttl=1h

- Установка `External Secrets Operator`
helm repo add external-secrets https://charts.external-secrets.io
helm repo update
helm install external-secrets external-secrets/external-secrets --namespace vault

- `secretstore.yaml` -  манифест crd обьекта `SecretStore`
- `externalsecret.yaml` - манифест описания `ExternalSecret`, который будет получать данные из Vault

v.0.11 #ДЗ GitOps и инструментыпоставки
helm repo add argo https://argoproj.github.io/argo-helm
с
helm install argocd argo/argo-cd -f argo-values.yaml --namespace argocd --create-namespace
kubectl port-forward service/argocd-server -n argocd 8080:443
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
- argo-project.yaml - project с именем Otus
- app-templating.yaml - апликейшен из kubernetes-ne![alt text](image.png)

v.0.10 #ДЗ Сервисы централизованного логирования для Kubernetes
-  Создан файл с выводом команд kubectlcommand.txt

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade --install loki grafana/loki-stack --set loki.image.tag=2.9.3 --namespace logging --create-namespace -f loki-values.yaml 
helm upgrade --install promtail grafana/promtail --namespace logging --create-namespace -f promtail-values.yaml
helm upgrade --install grafana grafana/grafana --namespace logging -f grafana-values.yaml

v.0.9 #ДЗ Мониторинг приложения в кластере
- Создан кастомный образ nginx, отдающий свои метрики
- Установлен в кластер Prometheus-operator
(
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus-operator prometheus-community/kube-prometheus-stack
)
- Создан deployment запускающий кастомный nginx образ и service для него 
- Настроен запуск nginx prometheus exporter отделбным подом и сконфигурирован для сбора метрик с nginx
- Создан манифест serviceMonitor, описывающий сбор метрик с подов

v.0.8 #ДЗ Создание собственного CRD

v.0.7.1 #ДЗ Шаблонизация манифестов приложения, использование Helm. Установка community Helm charts.
- Создан sripts/create_namespase.sh - для автоматического создания namespase, при его отсутвии.
- Созданы inventory, для раскатки в разные окружения, n-го кол-ва сервисов
- Создан release - дефолтная роль которая рендериться  в зависимоти от  кол-ва приложений в env которые необходимо развернуть
- Созданы template - для использования в качестве унификации release
- Создан _helpers.tpl - рендеринг release
для установки команда helmfile -f helm/helmfile.yaml --interactive -e prod apply
interactive - интерактивный ррежим, показывает изменение конфига и запрашивает подтвержение выполнения  действия
-e prod - выбор  окружения

v.0.7 #ДЗ Шаблонизация манифестов приложения, использование Helm. Установка community Helm charts.
- Создан heml chart 'my-app-chart' с зависимым чартом 'reddis (Учтановка чарта helm install mychart my-app-chart --values my-app-chart/values.yaml) 
- Параметоризированы конфиги 
- Добавлено возможность отключения readinessProbe 
- Cоздана деректоия 'inventory' 
- Cоздан 'helmfile.yaml'

Ps: запуск чата ДЗ поизводиться из inventory homework (helm install myname my-app-chart --values inventory/homework/values.yaml)

v.0.6 #ДЗ Основы безопасности в Kubernetes
- добавлен 'sa-monitoring.yaml' файл с описанием service account monitoring, привязки service account monitoring к ClusterRole metrics-reader и доступа к эндпоинту /metrics
- Добавлен 'sa-cd.yml' создание service account с именем cd и пердоставление
роли admin в namespace homework
- Обновлен 'deployment.yaml' добавлен запуск подов из под service account monitoring
- Сгенирирован и сохранен токен для аккаунта cd (kubectl create token cd --namespace homework --duration 24h >> token)
- Создан kubeconfig для service account cd
- Обновлен 'deployment.yaml', в
процессе запуска pod происходило обращение к эндпоинту
/metrics кластера
- Обновлен 'ingressesdzvolume.yaml' добавлен default префикс
- Обновлен 'configmap.yaml' добавлены настройки nginx