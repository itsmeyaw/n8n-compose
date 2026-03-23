# Lean N8N Compose

A HTTPS-ready n8n deployment for your own server using Traefik + Let's Encrypt.

## Steps

1. Copy `.env.example` to `.env` and configure values.

  Required values:
  - `N8N_DOMAIN`: Public DNS name pointing to this server.
  - `TRAEFIK_ACME_EMAIL`: Email used for Let's Encrypt certificate registration.
  - `TIMEZONE` and `N8N_VERSION` as needed.

2. Create secrets:

      - ./postgres_user.txt
      - ./postgres_password.txt
      - ./postgres_non_root_user.txt
      - ./postgres_non_root_password.txt
  
    You can generate the secrets using `init-secret.sh`
3. Make sure ports `80` and `443` are open and not used by another service.

4. Run docker compose

```bash
docker compose up -d
```