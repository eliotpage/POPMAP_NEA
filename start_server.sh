#!/bin/bash

cd "$(dirname "$0")"
cd app

if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

source venv/bin/activate

pip install -q -r requirements.txt

export APP_MODE=server

python3 app.py --server "$@"
