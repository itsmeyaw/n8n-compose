# Lean N8N Compose

A HTTPS-ready n8n deployment using Traefik + Let's Encrypt (ACME DNS challenge via Cloudflare).

n8n runs HTTP internally behind Traefik, while public/editor/webhook URLs are exposed over HTTPS at your domain.

## Setup

1. Pull the repository 
   
2. Copy `.env.example` to `.env` and configure values.

    Required values:
    - `N8N_DOMAIN`: Public DNS name pointing to this server.
    - `ACME_EMAIL`: Email used for Let's Encrypt registration/recovery notices.
    - `POSTGRES_NON_ROOT_USER`: n8n application database user.
    - `POSTGRES_NON_ROOT_PASSWORD`: n8n application database user password.
    - `TIMEZONE` and `N8N_VERSION` as needed.

    Optional value:
    - `LETSENCRYPT_CA_SERVER`: Leave unset for production certificates. Set to `https://acme-staging-v02.api.letsencrypt.org/directory` to use Let's Encrypt test certificates.

3. Create database secret files:

   - `./postgres_user.txt`
   - `./postgres_password.txt`

   You can generate these with:

   ```bash
   ./init-secret.sh
   ```

4. Create a Cloudflare API token:

    1. Open Cloudflare Dashboard.
    2. Go to `My Profile` -> `API Tokens`.
    3. Create a token with at least:
        - `Zone` -> `DNS` -> `Edit`
        - `Zone` -> `Zone` -> `Read`
    4. Restrict it to the zone that contains your `N8N_DOMAIN`.
    5. Save the token into `./cloudflare_dns_api_token.txt` (single line, no extra spaces).

5. In Cloudflare `SSL/TLS` settings, set SSL mode to `Full (strict)`.

6. Make sure port `443` is open and not used by another service.

7. Start the stack:

    ```bash
    docker compose up -d
    ```