# Lean N8N Compose

A HTTPS ready for n8n deployment for your own server.

## Steps

1. Copy `.env.example` to `.env` and configure the value
2. Create secrets:
      - ./postgres_user.txt
      - ./postgres_password.txt
      - ./postgres_non_root_user.txt
      - ./postgres_non_root_password.txt
    You can
3. Run docker compose
```bash
docker compose up -d
```