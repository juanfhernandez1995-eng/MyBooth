# MyBooth

MyBooth is a commercial AI-powered photo booth platform.

The Flutter app is the customer/operator interface. The laptop acts as the MyBooth Server and will control booth hardware, including the Canon EOS R50, DNP DS-RX1HS printer, AI engine, local gallery, and event storage.

## Current Development Release

MyBooth v0.9.1 Branding Polish adds:

- MyBooth logo assets
- Splash/loading screen foundation
- Branded dashboard header
- Reusable brand widgets
- Updated web app identity
- Updated platform display labels

## Development Rules

- Complete releases only
- No incremental snippets
- Keep screens small
- Keep widgets reusable
- Keep business logic out of UI
- Use providers for state
- Use services for persistence and business logic
- Run analyzer before committing

## Test Commands

```powershell
flutter clean
flutter pub get
flutter analyze
flutter run -d chrome
```


## MyBooth v0.10

Server Foundation release.

Adds the app-side foundation for the laptop-as-server architecture, including server/module status models, provider, service, dashboard status card, and Server Details screen.

## MyBooth Server

As of v0.16, the project includes a laptop-side server skeleton under `server/`. Flutter remains the Android tablet/client interface. The server folder prepares the future hardware and local API layer for camera, printer, AI, gallery, and event storage integrations.

## Current Release: v0.16 Photo + Template + Capture Foundation

The client can now pair with the laptop-side MyBooth Server through a cleaner Server Pairing flow. Use Laptop Test for same-machine development and Booth Router or a custom laptop IP for private Wi-Fi testing.



## v0.15 Router Field Test Prep

v0.15 prepares MyBooth for the first real private-router field test with the Android tablet and gaming laptop server. It keeps the real HTTP handshake from v0.13/v0.14 and adds clearer setup instructions for Wi-Fi, laptop IP discovery, firewall checks, and server startup.


## v0.16 Photo + Template + Capture Foundation

v0.16 adds the foundation for photo storage, editable border/template metadata, background packs, event honoree/name text fields, interchangeable colors, and countdown settings.
