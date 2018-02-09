#!/bin/bash
set -euo pipefail

docker build -t r2zer0/activityd:latest -f Dockerfile .
docker build -t r2zer0/activityd-postman-postqueue -f Dockerfile.postqueue .
