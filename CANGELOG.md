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