#!/bin/sh
set -euo pipefail

# Capture all environment variables starting with REACT_APP_ and make JSON string from them
ENV_JSON="$(jq --compact-output --null-input 'env | with_entries(select(.key | startswith("REACT_APP_")))')"

# Escape sed replacement's special characters: \, &, /.
# No need to escape newlines, because --compact-output already removed them.
# Inside of JSON strings newlines are already escaped.
ENV_JSON_ESCAPED="$(printf "%s" "${ENV_JSON}" | sed -e 's/[\&/]/\\&/g')"

sed -i "s/<noscript id=\"env-insertion-point\"><\/noscript>/<script>var ENV=${ENV_JSON_ESCAPED}<\/script>/g" /var/www/index.html

exec "$@"
