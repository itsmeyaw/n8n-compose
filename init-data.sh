#!/bin/bash
set -e

read_secret() {
	local value="${!1:-}"
	local file_var="${1}_FILE"
	local file="${!file_var:-}"

	if [ -n "$value" ]; then
		echo "$value"
	elif [ -n "$file" ] && [ -f "$file" ]; then
		cat "$file"
	fi
}

db_name="${POSTGRES_DB:-n8n}"
admin_user="$(read_secret POSTGRES_USER)"
app_user="$(read_secret POSTGRES_NON_ROOT_USER)"
app_password="$(read_secret POSTGRES_NON_ROOT_PASSWORD)"

if [ -n "$admin_user" ] && [ -n "$app_user" ] && [ -n "$app_password" ]; then
	psql \
		-v ON_ERROR_STOP=1 \
		-v db_name="$db_name" \
		-v app_user="$app_user" \
		-v app_password="$app_password" \
		--username "$admin_user" \
		--dbname "$db_name" <<-'EOSQL'
		DO
		$$
		BEGIN
			IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = :'app_user') THEN
				EXECUTE format('CREATE USER %I WITH PASSWORD %L', :'app_user', :'app_password');
			END IF;

			EXECUTE format('GRANT ALL PRIVILEGES ON DATABASE %I TO %I', :'db_name', :'app_user');
			EXECUTE format('GRANT CREATE ON SCHEMA public TO %I', :'app_user');
		END
		$$;
	EOSQL
else
	echo "SETUP INFO: Missing one of POSTGRES_USER(_FILE), POSTGRES_NON_ROOT_USER(_FILE), POSTGRES_NON_ROOT_PASSWORD(_FILE)."
fi
