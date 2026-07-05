# MyBooth Roadmap

## Phase 1 - Foundation ✅

- Flutter project
- Navigation
- Event model
- Persistent storage
- Provider architecture
- Theme engine
- Branding

Status: COMPLETE

---

## Phase 2 - Event Manager ✅

- Continue Event
- Delete Event
- Event detail hub
- Create Event flow
- Event status foundation
- Setup readiness checklist

Status: COMPLETE FOUNDATION

---

## Phase 3 - Server Foundation ✅

- MyBooth Server status model
- Server module model
- Server status provider
- Server status service
- Server Details screen
- Dashboard server status navigation

Status: COMPLETE FOUNDATION

---

## Phase 4 - Local Connection Foundation ✅

- Local connection model
- Local connection provider
- Server IP and port settings
- Mock tablet/server handshake
- Dashboard connection indicator
- Connection status screen

Status: COMPLETE FOUNDATION

---

## Phase 4.5 - Local Server API

- Laptop server process
- Local API endpoint
- Tablet/server heartbeat
- Private Wi-Fi pairing
- Server status polling
- Error handling and reconnect flow

Status: NEXT

---

## Phase 5 - Camera

- Canon EOS R50 connection
- Live View
- Camera settings
- Countdown
- Capture
- Review screen
- Retake

---

## Phase 6 - Printing

- DNP DS-RX1HS integration
- Print queue
- Print status
- Reprint
- Multiple copies

---

## Phase 7 - AI

- Background removal
- AI backgrounds
- Face enhancement
- AI templates

---

## Phase 8 - Gallery

- QR code
- Local gallery
- Next-day email
- Download portal

---

## Phase 9 - Commercial Release

- Booth diagnostics
- Operator mode
- Customer mode
- Licensing
- Automatic updates

## Release History

### v0.8 Theme Engine

- Working live theme switching.
- Theme persistence.
- Theme Gallery foundation.

### v0.8.1 Layout Polish

- Theme Gallery overflow fixed.
- Better responsive card layout.

### v0.8.2 Analyzer Cleanup

- Flutter analyzer returns no issues.

### v0.9 Event Flow

- Event detail hub.
- Improved create/continue event workflow.
- Event status and readiness foundation.

### v0.9.1 Branding Polish

- MyBooth logo assets.
- Splash branding.
- Dashboard brand polish.

### v0.10 Server Foundation

- Server status foundation.
- Module boundaries for laptop, tablet, network, camera, printer, AI, and gallery storage.


### v0.11 Local Connection Foundation

- Server IP and port settings.
- Mock tablet-to-laptop handshake.
- Dashboard connection indicator.
- Local connection screen and future API contract.

### v0.12 Server App Skeleton

- Add laptop-side `server/` project folder.
- Add Python standard-library local HTTP skeleton.
- Add `/health`, `/status`, `/modules`, and `/pair` route boundaries.
- Add placeholders for camera, printer, AI, gallery, and event storage services.
- Keep Flutter app as tablet/operator UI only.


### v0.13 Real Server Handshake

- Wire Flutter Local Connection screen to the Python server `/health` and `/status` endpoints.
- Show server name, version, module count, and response time.
- Add localhost testing shortcut for Chrome/laptop development.
- Preserve mock fallback for offline demos.
- Prepare for pairing, heartbeat polling, and live module status updates.

### v0.14 Server Pairing Polish

- Polish tablet-to-laptop server pairing flow.
- Add clearer Laptop Test and Booth Router presets.
- Add troubleshooting guidance for Wi-Fi, firewall, and server address issues.
- Prepare for real private-router testing before hardware integration.



### v0.15 Router Field Test Prep

- Add router field test checklist to the app.
- Add laptop IP discovery guidance.
- Add firewall troubleshooting.
- Prepare for real Android tablet to gaming laptop server testing over private Wi-Fi.


## v0.16 Photo + Template + Capture Foundation

- Photo storage foundation.
- Editable border/template library foundation.
- Background pack foundation for green screen workflows.
- Event-level honoree/name/subtitle fields.
- Countdown settings foundation.
- Server endpoints for templates, backgrounds, and storage plan metadata.


## v0.18 Template Designer Foundation

- Add per-event Template Designer screen.
- Support editable event title, honoree/name/company, date, and subtitle fields.
- Support interchangeable color palettes.
- Support 2x6 and 4x6 live foundation previews.
- Save template choices to the event profile.
- Prepare later rendering of final bordered/composited outputs for QR, print, gallery, and Google Photos export.

## v0.19 Gallery + QR Page Foundation

- Guest gallery preview screen.
- Dashboard Gallery + QR screen.
- Booth Mode QR step links to the guest gallery preview.
- Server session gallery route foundation.
- Final bordered/composited outputs are guest-visible; raw originals remain operator-only.
