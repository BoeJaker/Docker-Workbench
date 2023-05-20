#!/bin/bash
git clone "https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@${CLIENT_REPO}" /app || echo ""
cd /app
pip install -r requirements.txt &

python3 -m http.server 8000 &

while true; do
    git pull &
    sleep 600m
done 