#!/usr/bin/env bash

set -euo pipefail

usage() {
	cat <<'EOF'
Usage: ./init-secret.sh [options]

Creates the following files in the current working directory:
	- postgres_user.txt
	- postgres_password.txt

Options:
	-u, --postgres-user STRING               PostgreSQL root user
	-p, --postgres-password STRING           PostgreSQL root password
	-h, --help                               Show this help message

If an option is not provided, a random value is generated.
EOF
}

random_password() {
	# 16 random bytes rendered as hex => 32 chars.
	od -An -N16 -tx1 /dev/urandom | tr -d ' \n'
}

random_username() {
	# 6 random bytes rendered as hex => 12 chars.
	printf 'user_%s' "$(od -An -N6 -tx1 /dev/urandom | tr -d ' \n')"
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

while [[ $# -gt 0 ]]; do
	case "$1" in
		-u|--postgres-user)
			[[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
			postgres_user="${2:-}"
			shift 2
			;;
		-p|--postgres-password)
			[[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
			postgres_password="${2:-}"
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

write_secret "postgres_user.txt" "$postgres_user"
write_secret "postgres_password.txt" "$postgres_password"

echo "Secret files created successfully."
