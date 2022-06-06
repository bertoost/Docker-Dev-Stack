# Custom services

There are a couple of custom services you can use from the dev-stack. 
Central services you can use over multiple projects.

### Portainer

```bash
docker-compose -f services/portainer/docker-compose.yml up -d
```

### Mailhog (mail catcher)

```bash
docker-compose -f services/mailhog/docker-compose.yml up -d
```

### RabbitMQ

```bash
docker-compose -f services/rabbitmq/docker-compose.yml up -d
```

### Redis Insight (UI)

```bash
docker-compose -f services/redisui/docker-compose.yml up -d
```