#!/bin/bash

cd "$(dirname "$0")"
cd app

if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

source venv/bin/activate

pip install -q -r requirements.txt

if command -v nginx >/dev/null 2>&1; then
    echo "Starting nginx (proxy on port 80)..."
    sudo service nginx start >/dev/null 2>&1 || true
fi

export APP_MODE=client

python3 app.py "$@"
