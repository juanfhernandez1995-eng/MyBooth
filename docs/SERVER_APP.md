# MyBooth Server App Skeleton

MyBooth is moving toward a two-part platform:

```text
Android Tablet Client
        │
Private Wi-Fi
        │
Gaming Laptop MyBooth Server
        ├── Canon EOS R50
        ├── DNP DS-RX1HS
        ├── AI Background Engine
        ├── Local Gallery Storage
        └── Event Storage API
```

## v0.13 Scope

v0.13 keeps the Python server skeleton and wires the Flutter client to its real health/status endpoints.

The server skeleton includes:

- standard-library Python HTTP server
- server configuration file
- `/health` endpoint
- `/status` endpoint
- `/modules` endpoint
- `/pair` mock endpoint
- placeholders for camera, printer, AI, gallery, and event storage services

## Current Endpoint Plan

```text
GET  /health   Basic server health and version
GET  /status   Server status plus all module states
GET  /modules  Hardware/service module summaries
POST /pair     Tablet-to-server pairing handshake placeholder
```

## What Is Not Included Yet

v0.13 does not connect to the Canon EOS R50, DNP printer, AI background tools, or live pairing security yet. It verifies the local server boundary with real HTTP requests before hardware control is added.

## Running the Server

```powershell
cd server
py -m mybooth_server
```

Default local development URL:

```text
http://127.0.0.1:8080
```

Future private Wi-Fi target:

```text
http://192.168.4.1:8080
```


## Flutter Client Test

1. Start the server:

```powershell
cd server
py -m mybooth_server
```

2. Run the Flutter app in another terminal.
3. Open Local Connection.
4. Use `127.0.0.1` for same-laptop Chrome testing, or `192.168.4.1` for the private booth Wi-Fi target.
5. Tap **Real Handshake**.

Successful responses from `/health` and `/status` will show server name, version, module count, and response time in the app.

## v0.14 Pairing Notes

The server now binds to `0.0.0.0` so the laptop can accept requests from another device on the same private Wi-Fi network. Use `127.0.0.1` for laptop-only testing and the laptop Wi-Fi IPv4 address for real Android tablet testing.

If tablet pairing fails, check that the server is running, both devices are on the same Wi-Fi, the IP address is correct, port `8080` is open, and Windows Defender Firewall allows Python.



## v0.15 Router Field Test

Use `py -m mybooth_server` on the laptop, find the Wi-Fi IPv4 address with `ipconfig`, connect the Android tablet to the same private router, and pair to `http://<LAPTOP-IP>:8080`. The server binds to `0.0.0.0`, so another device on the same Wi-Fi can reach it when the Windows firewall allows Python.


## v0.16 Asset + Photo Storage Routes

- `GET /assets/templates` returns starter editable border/template metadata.
- `GET /assets/backgrounds` returns starter background pack metadata.
- `GET /storage/photo-plan` returns the planned event photo folder structure and original preservation rule.


## v0.18 Template Designer Metadata

The server exposes `/assets/template-designer-plan` so the laptop server can document and eventually own template-rendering metadata. Flutter currently edits and saves template metadata on the event profile; future server rendering will produce final bordered PNG/JPEG outputs.
