#!/bin/bash
dub build
docker build -t r2zer0/activityd:latest .
