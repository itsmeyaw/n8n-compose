# Lean N8N Compose

A HTTPS-ready n8n deployment using Traefik + Cloudflare Origin Server certificate.

n8n runs HTTP internally behind Traefik, while public/editor/webhook URLs are exposed over HTTPS at your domain.

## Setup

1. Pull the repository 
   
2. Copy `.env.example` to `.env` and configure values.

    Required values:
    - `N8N_DOMAIN`: Public DNS name pointing to this server.
    - `POSTGRES_NON_ROOT_USER`: n8n application database user.
    - `POSTGRES_NON_ROOT_PASSWORD`: n8n application database user password.
    - `TIMEZONE` and `N8N_VERSION` as needed.

3. Create database secret files:

   - `./postgres_user.txt`
   - `./postgres_password.txt`

   You can generate these with:

   ```bash
   ./init-secret.sh
   ```

4. Create a Cloudflare Origin Server certificate:

   1. Open Cloudflare Dashboard.
   2. Go to `SSL/TLS` -> `Origin Server`.
   3. Click `Create certificate`.
   4. Choose key format `PEM`.
   5. Include your hostname (for example `n8n.example.com`, and optionally `*.example.com`).
   6. Create and copy both values.

    Save them as files in the project root:

    - `./cf_certificate.pem` (certificate)
    - `./cf_private_key.pem` (private key)

    Recommended permissions:

    ```bash
    chmod 600 cf_certificate.pem cf_private_key.pem
    ```

5. In Cloudflare `SSL/TLS` settings, set SSL mode to `Full (strict)`. Note that this may disrupt any proxied service that was not configured with Cloudflare Origin Server.

6. Make sure port `443` is open and not used by another service.

7. Start the stack:

    ```bash
    docker compose up -d
    ```