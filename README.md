# POPMAP

Simple setup and run guide.

## 1) Download

Option A (git/curl style):
```bash
git clone https://github.com/eliotpage/POPMAP_NEA.git
cd POPMAP_NEA
```

Option B (manual):
1. Download ZIP from GitHub
2. Extract it
3. Open terminal in the extracted folder

## 2) Start Server

Linux/macOS:
```bash
./start_server.sh
```

Windows:
```bat
start_server.bat
```

Quick help:
```bash
./start_server.sh --help
```

Auth setup during server startup:
1. Server setup now checks `app/.env` for auth variables.
2. Missing `SECRET_KEY` and `POPMAP_CONNECTION_SECRET` are generated automatically.
3. You are prompted for `MAIL_USERNAME` and `MAIL_PASSWORD` (optional, needed for OTP email).
4. Values are saved to `app/.env` for future runs.

Common server usage:
```bash
# Start normally (quiet)
./start_server.sh

# Setup auth and ngrok (first time or reconfiguring)
./start_server.sh -s -n

# Show verbose HTTP logs
./start_server.sh -l 1

# Custom tile directory and port with verbose logs
./start_server.sh -t /path/to/tiles --port 5001 -l 1

# Full first-time setup with ngrok and logs
./start_server.sh -s -n -l 1
```

Server flag reference:

| Short | Long | Argument | Description |
|-------|------|----------|-------------|
| `-s` | `--setup-auth` | — | Forces re-prompt for auth secrets. Regenerates SECRET_KEY and POPMAP_CONNECTION_SECRET, re-prompts for MAIL_USERNAME/PASSWORD. |
| `-n` | `--ngrok` | — | Auto-installs ngrok (if missing) and creates tunnel for remote access. |
| `-l` | `--logs` | `0` or `1` | 0 = quiet (default), 1 = show HTTP request logs (verbose, for debugging). |
| `-t` | `--tile-dir` | `<path>` | Path to tile directory for map tiles. |
| `-h` | `--help` | — | Show help message with examples. |

What server prints:
1. `Connection URL`
2. `Connection ID` (UID)

Share the Connection ID with clients.

## 3) Start Client

Linux/macOS:
```bash
./start_client.sh --uid <connection-id>
```

Windows:
```bat
start_client.bat --uid <connection-id>
```

Quick help:
```bash
./start_client.sh --help
```

Common client usage:
```bash
# Basic: connect with your connection ID
./start_client.sh -u abc123def

# Show verbose HTTP logs
./start_client.sh -u abc123def -l 1

# Use custom port (if 5000 is busy)
./start_client.sh -u abc123def -p 5002

# All options combined
./start_client.sh -u abc123def -l 1 -p 5002
```

Client flag reference:

| Short | Long | Argument | Description |
|-------|------|----------|-------------|
| `-u` | `--uid` | `<id>` | Connection ID from server (required). Get this from server startup output. |
| `-l` | `--logs` | `0` or `1` | 0 = quiet (default), 1 = show HTTP request logs (verbose, for debugging). |
| `-p` | `--port` | `<port>` | Port to run client on. Default: 5000. Use 5002 if 5000 is busy. |
| `-h` | `--help` | — | Show help message with examples. |

Open in browser:
1. Client: `http://localhost:5000` (or your `--port`)
2. Server monitor: `http://localhost:5001/monitor` (or your `--port`)

## 4) Login Flow

1. Enter email on client login page
2. Receive OTP email
3. Enter OTP
4. Open `/map`

## 5) Tiles (How It Works)

1. Server stores/serves tiles (`--tile-dir` on server)
2. Client requests `/tiles/...` from its own app
3. If client has no local tile, client proxies that tile request to server automatically

So clients can run without local tile copies.

## 6) Public Access From Anywhere

If server is in Codespaces:
1. Start server normally
2. Use printed Connection ID on any client

If server is local PC and needs internet access:
1. Start server with: `./start_server.sh --ngrok`
2. Setup auto-installs ngrok when missing (requires package manager/admin permissions)
3. Share printed Connection ID

If auto-install fails:
1. Install ngrok manually from `https://ngrok.com/download`
2. Rerun server with `--ngrok`
