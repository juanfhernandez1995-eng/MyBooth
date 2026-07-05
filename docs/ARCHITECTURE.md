# MyBooth Architecture

## Core Direction

MyBooth is a local-first professional photo booth system.

The system is built around two main parts:

1. **MyBooth Client**
   - Flutter app
   - Runs on the Android tablet in vertical orientation
   - May also run in Chrome during development
   - Handles the operator/customer interface
   - Shows event flow, themes, status, gallery, and QR screens

2. **MyBooth Server**
   - Runs on the gaming laptop
   - Controls the Canon EOS R50
   - Controls the DNP DS-RX1HS printer
   - Stores event photos locally
   - Handles AI backgrounds
   - Hosts the local gallery
   - Sends gallery delivery workflows in future releases

## Hardware Plan

- Canon EOS R50 camera
- Gaming laptop as the MyBooth Server
- Android tablet as the booth interface
- DNP DS-RX1HS printer
- Dedicated private Wi-Fi network
- Local-first event and gallery storage

## Design Principle

The tablet should not directly control the camera or printer.

Instead:

```text
Android Tablet Client
        |
   Private Wi-Fi
        |
Gaming Laptop MyBooth Server
        |
Camera / Printer / AI / Gallery / Storage
```

This keeps the system reliable, modular, and easier to expand.

## v0.10 Server Foundation

The app now contains a server status foundation with:

- Server status model
- Server module model
- Server status provider
- Server status service
- Server Details screen
- Dashboard Server Status navigation

The hardware integrations are not connected yet. v0.10 creates the app-side boundaries for those future integrations.

## Local-First Rule

MyBooth must continue working even without internet.

Internet is optional and used later for:

- Gallery email delivery
- Cloud backup
- Software updates
- Customer portal

## Current App Milestones

- v0.1 Flutter project created
- v0.2 Home screen and project structure
- v0.3 Provider event management
- v0.4 Persistent event storage
- v0.8 Theme engine
- v0.8.1 Layout polish
- v0.8.2 Analyzer cleanup
- v0.9 Event flow
- v0.9.1 Branding polish
- v0.10 Server foundation


## v0.11 Local Connection Foundation

The Flutter app now has a client-side connection layer for the Android tablet workflow.

Current behavior:

- Stores the laptop server IP address.
- Stores the laptop server port.
- Displays a local endpoint on the dashboard.
- Runs a mock tablet-to-laptop handshake.
- Keeps the UI independent from the future real server transport.

Prepared future replacement:

```text
LocalConnectionService mock handshake
        ↓
Real HTTP/WebSocket MyBooth Server API
```

The UI should continue talking to `LocalConnectionProvider`. The provider/service layer should absorb the future real networking implementation.

## v0.12 Server App Skeleton

The project now includes a dedicated `server/` folder for the laptop-side MyBooth Server. Flutter remains the tablet UI; the server owns future hardware control, local API routes, gallery storage, event storage, and long-running jobs.

Initial server routes:

```text
GET /health
GET /status
GET /modules
POST /pair
```

This keeps the tablet client and laptop server responsibilities separate before Canon, DNP, AI, and gallery integrations are added.
