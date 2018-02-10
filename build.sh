#!/bin/bash
set -euo pipefail

docker build -t r2zer0/activityd:latest -f Dockerfile .
docker build -t r2zer0/activityd-database -f Dockerfile.database .
