# MyBooth Server

Laptop-side server skeleton for the MyBooth platform.

The Flutter app remains the tablet/customer/operator interface. The gaming laptop will run this server and own the hardware-facing responsibilities:

- Canon EOS R50 capture control
- DNP DS-RX1HS print queue control
- AI background workflow
- local gallery storage
- event session storage
- private Wi-Fi tablet connection

## Current scope: v0.21

This release keeps the standard-library server skeleton and adds router pairing metadata for real tablet-to-laptop booth testing. It does not control real hardware yet.

## Run locally

From the project root:

```powershell
cd server
py -m mybooth_server
```

Default address:

```text
http://127.0.0.1:8080
```

For booth use, the laptop private-Wi-Fi IP must come from `ipconfig`. A common example is:

```text
http://LAPTOP-IP:8080
```

## Endpoints

```text
GET /health
GET /status
POST /pair
GET /modules
```

## Design rule

The server is intentionally separate from Flutter. Flutter displays and controls the booth experience; the server owns hardware, file storage, local API state, and long-running jobs.


## Flutter handshake test

Start the server, then open the Flutter app Local Connection screen and use `127.0.0.1:8080` for Chrome testing on the same laptop. Tap **Real Handshake** to verify `/health` and `/status`.

## v0.15 Router Field Test Notes

The development server binds to `0.0.0.0` so another device on the same Wi-Fi can reach it. Test locally with `http://127.0.0.1:8080/health`. For an Android tablet, use the laptop Wi-Fi IPv4 address shown by `ipconfig`.



## Router field test flow

1. Connect the laptop to the private MyBooth router Wi-Fi.
2. Run `ipconfig` and find the Wi-Fi IPv4 address.
3. Start the server with `py -m mybooth_server`.
4. On the tablet/client, enter `http://<LAPTOP-IP>:8080` in Server Pairing.
5. Test `/health`, `/status`, and the app Pair with Server action.

If the laptop browser can reach `/health` but the tablet cannot, check that both devices are on the same Wi-Fi and allow Python through Windows Defender Firewall.


## v0.20 Photo + Asset Routes

- `/assets/templates` returns editable template metadata for weddings, baptisms, birthdays, corporate events, and seasonal designs.
- `/assets/backgrounds` returns starter background pack metadata for future green screen workflows.
- `/storage/photo-plan` returns the planned event photo storage structure.

## v0.20 QR Delivery Route

`GET /gallery/qr-plan` returns the planned QR delivery behavior.

The default guest QR target is the final bordered/composited session gallery. Raw originals stay operator-only and are not exposed to guest QR downloads by default.


## v0.20 Template Designer Route

`GET /assets/template-designer-plan` returns the editable template design rules used by the Flutter Template Designer foundation.

The server-side rule matches the booth product rule: guest QR, gallery, print, and future Google Photos export should use final bordered/composited outputs. Raw Canon originals remain operator-only.


## v0.21 Router Pairing Route

`GET /pairing/router-field-plan` returns the real-world router pairing rules used by the Flutter Server Pairing screen.

Important field-test rules:

- Use the laptop Wi-Fi IPv4 Address from `ipconfig`.
- Do not use `0.0.0.0` or `127.0.0.1` from the tablet.
- Keep Python/MyBooth Server running on port `8080`.
- If testing Flutter Web from the tablet, allow port `5000`.
- If the tablet cannot reach the laptop, check Windows Firewall and router client/AP isolation.
