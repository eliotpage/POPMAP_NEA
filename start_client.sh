#!/bin/bash

cd "$(dirname "$0")"
cd app

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "POPMAP client launcher"
    echo "Usage: ./start_client.sh -u <connection-id> [options] [--port <port>]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -u, --uid <id>          Connection ID (required - share with server)"
    echo "  -l, --logs <0|1>        0=quiet (default), 1=show HTTP request logs"
    echo "  -p, --port <port>       Port to run client on (default: 5000)"
    echo ""
    echo "Examples:"
    echo "  ./start_client.sh -u abc123def                # Basic usage"
    echo "  ./start_client.sh -u abc123def -l 1           # Show logs"
    echo "  ./start_client.sh -u abc123def -p 5002        # Custom port"
    echo "  ./start_client.sh -u abc123def -l 1 -p 5002   # Both options"
    exit 0
fi

# Parse flags
LOGS_VALUE=0
FORWARD_ARGS=()

while [ $# -gt 0 ]; do
    case "$1" in
        -l|--logs)
            if [ $# -gt 1 ]; then
                LOGS_VALUE="$2"
                shift 2
            else
                echo "Error: -l/--logs requires a value (0 or 1)"
                exit 1
            fi
            ;;
        -u|--uid)
            if [ $# -gt 1 ]; then
                FORWARD_ARGS+=("--uid" "$2")
                shift 2
            else
                echo "Error: -u/--uid requires a connection ID"
                exit 1
            fi
            ;;
        -p|--port)
            if [ $# -gt 1 ]; then
                FORWARD_ARGS+=("--port" "$2")
                shift 2
            else
                echo "Error: -p/--port requires a port number"
                exit 1
            fi
            ;;
        *)
            FORWARD_ARGS+=("$1")
            shift
            ;;
    esac
done

if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

source venv/bin/activate

export PIP_DISABLE_PIP_VERSION_CHECK=1
pip install -q -r requirements.txt

export APP_MODE=client

if [ "$LOGS_VALUE" -eq 1 ]; then
    export QUIET_HTTP_LOGS=0
else
    export QUIET_HTTP_LOGS=1
fi

python3 app.py "${FORWARD_ARGS[@]}"
