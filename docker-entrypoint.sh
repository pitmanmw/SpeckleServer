#!/bin/sh
set -e
cd nodejs

echo "STARTING ENTRY POINT RUNNING AS: $RUN_AS"

if [ "$RUN_AS" = "web" ]; then
  echo "Running as WEB"
fi

exec "$@"
