# POPMAP - Unified Tactical Mapping

Collaborative real-time mapping with pathfinding and hostile zone avoidance.

---

## Install

**Clone the repo:**
```bash
git clone https://github.com/eliotpage/POPMAP_NEA.git
cd POPMAP_NEA
```

**Set up Python environment:**
```bash
cd app
python -m venv venv

# Linux/macOS
source venv/bin/activate

# Windows
venv\Scripts\activate.bat
```

**Install dependencies:**
```bash
pip install -r requirements.txt
```

---

## Run Server

**Start on default port 5001:**
```bash
./start_server.sh
```

**Or with flags:**
```bash
./start_server.sh --port 5001 --tile-dir /path/to/tiles
```

**For public access (local PC):**
1. Install ngrok: `brew install ngrok` (or download from ngrok.com)
2. In another terminal: `ngrok http 5001`
3. Run server: `./start_server.sh --public`

Server prints:
```
[Server] Connection URL: https://...
[Server] Connection ID: 76317c68...
```

Share the Connection ID with clients.

---

## Run Client

**Start on default port 5000:**
```bash
./start_client.sh
```

**Or with connection ID:**
```bash
./start_client.sh --port 5000 --tile-dir /path/to/tiles --uid <connection-id>
```

Then open http://localhost:5000 (or whatever port you set).

---

## Email Setup (Server Only)

For OTP email authentication, add to `app/.env`:
```
SECRET_KEY=your-secret-key
MAIL_USERNAME=your-gmail@gmail.com
MAIL_PASSWORD=your-app-password
```

Or set environment variables before running:
```bash
export SECRET_KEY=your-secret-key
export MAIL_USERNAME=your-gmail@gmail.com
export MAIL_PASSWORD=your-app-password
./start_server.sh
```

Without email config, server runs in demo mode (no OTP emails sent).

---

## Map Tiles & Terrain Data

Map tiles and elevation data are not included (too large).

**If you need map functionality:**
1. Get tiles and `output_be.tif` from your administrator
2. Place tiles in: `app/static/tiles/`
3. Place DEM file in: `app/static/output_be.tif`
4. Run with: `./start_server.sh --tile-dir /path/to/tiles`

Server runs fine without tiles—just no map display or pathfinding.
```nginx
upstream popmap_server {
    server localhost:5001;
}

server {
    listen 80;
    server_name server.yourdomain.com;

    location / {
        proxy_pass http://popmap_server;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

**Client Machine** (`/etc/nginx/sites-available/popmap-client.conf`):
```nginx
upstream popmap_client {
    server localhost:5000;
}

server {
    listen 80;
    server_name client.yourdomain.com;

    location / {
        proxy_pass http://popmap_client;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Enable Nginx Config

```bash
sudo ln -s /etc/nginx/sites-available/popmap.conf /etc/nginx/sites-enabled/
sudo nginx -t  # Test configuration
sudo systemctl restart nginx
```

### SSL/HTTPS (Recommended for Production)

Install Certbot:
```bash
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com
```

Certbot will automatically update your nginx config to use HTTPS on port 443 and redirect HTTP to HTTPS.

## Features

### 🗺️ Interactive Mapping
- Leaflet-based map with offline tile support
- Draw markers, lines, polygons, and circles
- Color-coded features with hostile zone marking
- Real-time drawing synchronization

### 🛣️ Intelligent Pathfinding
- D* Lite algorithm for optimal path calculation
- Hostile zone avoidance
- Terrain-aware routing using DEM data
- Risk assessment (Low/Medium/High)
- Corridor-based path constraints

### 🔒 Security
- OTP-based authentication via email
- Session management
- Server-side cryptography
- SHA-256 hashing for credentials

### 📊 Risk Analysis
- Automatic path risk calculation
- Proximity-based threat assessment
- Visual alerts for dangerous routes
- Distance metrics to hostile zones

## Deployment

### For Production Server
1. Configure `.env` with production email credentials
2. Set secure `SECRET_KEY`
3. Update CORS/network settings as needed
4. Deploy server to production server

### For Client Distribution
1. Package `/client` directory
2. Users configure `.env` with their server URL
3. Users install dependencies
4. Users run the application

## Requirements

- Python 3.8+
- Flask
- Rasterio (for DEM data)
- Leaflet.js (included)
- GDAL (for Rasterio)

## License

[Add your license here]

## Support

For issues or questions:
- Check server logs: `cd server && python app.py`
- Check client logs: `cd client && python app.py`
- Review `.env` configuration
- Verify server connectivity from client

