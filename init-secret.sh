#!/usr/bin/env bash

set -euo pipefail

usage() {
	cat <<'EOF'
Usage: ./init-secret.sh [options]

Creates the following files in the current working directory:
	- postgres_user.txt
	- postgres_password.txt
	- postgres_non_root_user.txt
	- postgres_non_root_password.txt

Options:
	-u, --postgres-user STRING               PostgreSQL root user
	-p, --postgres-password STRING           PostgreSQL root password
	-n, --postgres-non-root-user STRING      PostgreSQL non-root user
	-r, --postgres-non-root-password STRING  PostgreSQL non-root password
	-h, --help                               Show this help message

If an option is not provided, a random value is generated.
EOF
}

random_password() {
	LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32
}

random_username() {
	printf 'user_%s' "$(LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | head -c 12)"
}

write_secret() {
	local file_name="$1"
	local value="$2"

	printf '%s\n' "$value" > "$file_name"
	chmod 600 "$file_name"
	echo "Wrote $file_name"
}

postgres_user=""
postgres_password=""
postgres_non_root_user=""
postgres_non_root_password=""

while [[ $# -gt 0 ]]; do
	case "$1" in
		-u|--postgres-user)
			postgres_user="${2:-}"
			shift 2
			;;
		-p|--postgres-password)
			postgres_password="${2:-}"
			shift 2
			;;
		-n|--postgres-non-root-user)
			postgres_non_root_user="${2:-}"
			shift 2
			;;
		-r|--postgres-non-root-password)
			postgres_non_root_password="${2:-}"
			shift 2
			;;
		-h|--help)
			usage
			exit 0
			;;
		*)
			echo "Unknown option: $1" >&2
			usage
			exit 1
			;;
	esac
done

postgres_user="${postgres_user:-$(random_username)}"
postgres_password="${postgres_password:-$(random_password)}"
postgres_non_root_user="${postgres_non_root_user:-$(random_username)}"
postgres_non_root_password="${postgres_non_root_password:-$(random_password)}"

write_secret "postgres_user.txt" "$postgres_user"
write_secret "postgres_password.txt" "$postgres_password"
write_secret "postgres_non_root_user.txt" "$postgres_non_root_user"
write_secret "postgres_non_root_password.txt" "$postgres_non_root_password"

echo "Secret files created successfully."
