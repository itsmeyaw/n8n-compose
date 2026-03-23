# Lean N8N Compose

A HTTPS-ready n8n deployment for your own server using Traefik + Let's Encrypt.

This setup uses Traefik ACME DNS challenge with Cloudflare, so SSL works even when Cloudflare proxy (orange cloud) is enabled.

n8n runs HTTP internally behind Traefik, while public/editor/webhook URLs are HTTPS on your domain.

## Steps

1. Copy `.env.example` to `.env` and configure values.

  Required values:
  - `N8N_DOMAIN`: Public DNS name pointing to this server.
  - `TRAEFIK_ACME_EMAIL`: Email used for Let's Encrypt certificate registration.
  - `POSTGRES_NON_ROOT_USER`: n8n application database user.
  - `POSTGRES_NON_ROOT_PASSWORD`: n8n application database user password.
  - `TIMEZONE` and `N8N_VERSION` as needed.

2. Create secrets:

      - ./postgres_user.txt
      - ./postgres_password.txt
      - ./cloudflare_dns_api_token.txt

    `cloudflare_dns_api_token.txt` must contain a Cloudflare API token with Zone DNS Edit permission.
  
    You can generate the secrets using `init-secret.sh`.
3. In Cloudflare SSL/TLS settings, set mode to `Full (strict)`.

4. Make sure ports `80` and `443` are open and not used by another service.

5. Run docker compose

```bash
docker compose up -d
```