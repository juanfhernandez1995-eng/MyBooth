# MyBooth Communication Protocol

## Overview

The MyBooth Client communicates with the MyBooth Server over a private local Wi-Fi network.

The server is responsible for all hardware control.

```text
Android Tablet Client
        |
   Private Wi-Fi
        |
Gaming Laptop MyBooth Server
        |
Canon EOS R50 / DNP Printer / AI Engine / Local Gallery
```

## Current v0.13 Scope

v0.13 makes the Flutter client call the laptop server skeleton over HTTP for the first time.

It includes:

- Server status
- Module status
- Connection readiness
- Hardware module boundaries
- Future local API wiring
- Server IP and port settings
- Real `/health` and `/status` handshake
- Mock fallback for demos when the server is offline
- Dashboard connection indicator

## Responsibilities

### Client

- User interface
- Event management
- Theme selection
- Operator flow
- Station selection
- QR/gallery screens in future releases
- Status display

### Server

- Canon EOS R50 control
- Live view streaming
- Photo capture
- Image processing
- AI backgrounds
- Printer control
- Event storage
- Local gallery hosting
- Future gallery delivery

## Future API Direction

The client should send simple requests. The server should perform the hardware work and return status updates.

Prepared client connection settings:

- Default server IP: `192.168.4.1`
- Default server port: `8080`
- Default endpoint: `http://192.168.4.1:8080`

Possible future transport:

- HTTP/WebSocket local API
- Private Wi-Fi address discovery
- Pairing code or booth PIN
- Local heartbeat/status checks

## v0.13 Real Server Handshake

The app saves a server IP/port and can now verify the laptop server by calling real local HTTP endpoints. Mock fallback remains available for demos and offline testing.

Active first endpoints:

- `GET /health`
- `GET /status`
- `POST /pair`
- `WS /events`

## Example Commands

### Server Status

Client → Server

```json
{
  "command": "server_status"
}
```

Server → Client

```json
{
  "status": "online",
  "camera": "ready",
  "printer": "ready",
  "aiEngine": "ready",
  "galleryStorage": "ready"
}
```

### Capture Photo

Client → Server

```json
{
  "command": "capture_photo",
  "eventId": "MB-123456789"
}
```

### Camera Ready

Server → Client

```json
{
  "status": "camera_ready"
}
```

### Printing

Server → Client

```json
{
  "status": "printing",
  "copies": 2
}
```

### Print Complete

Server → Client

```json
{
  "status": "print_complete"
}
```

## Future Commands

- server_status
- pair_client
- start_live_view
- stop_live_view
- capture_photo
- retake_photo
- print
- reprint
- generate_ai_background
- publish_gallery
- email_gallery
- shutdown_booth

## Design Goal

The client should never need to know how the camera or printer works.

It only sends requests.

The server performs the work and returns status updates.

## v0.12 Local Server Skeleton

The server skeleton introduced the first local HTTP contract:

```text
GET  /health
GET  /status
GET  /modules
POST /pair
```

## v0.13 Flutter Client Wiring

The Flutter app now calls:

```text
GET /health
GET /status
```

A successful handshake marks the connection as `Server connected`, stores server metadata, displays the server version, and updates the dashboard Local Connection card. The default booth network target remains `http://192.168.4.1:8080`, while `127.0.0.1:8080` is provided for laptop/browser testing.

## v0.14 Server Pairing Polish

The Flutter client still validates the Python server through `GET /health` and `GET /status`. The pairing UI now separates laptop development testing from private booth router testing, adds clearer failure guidance, and keeps mock fallback available for offline demos.

The Python server binds to `0.0.0.0` in development so it can accept local network requests from a tablet on the same Wi-Fi. Laptop browser testing remains available at `http://127.0.0.1:8080`.



## v0.15 Router Field Test Prep

v0.15 keeps the existing `/health` and `/status` handshake and documents how to test it from a real Android tablet over a private router. The tablet must use the laptop Wi-Fi IPv4 address and port `8080`; `127.0.0.1` is only valid when Flutter and the server run on the same machine.
