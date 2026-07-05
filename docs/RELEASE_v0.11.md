# MyBooth v0.11 Local Connection Foundation

## Release Goal

Prepare the Android tablet client to connect to the gaming laptop MyBooth Server over private Wi-Fi.

This release does not start the real laptop server API yet. It creates the client-side connection model, settings flow, mock handshake, and dashboard visibility needed before the real API is introduced.

## New Files

- `lib/models/local_connection.dart`
- `lib/services/local_connection_service.dart`
- `lib/providers/local_connection_provider.dart`
- `lib/screens/local_connection_screen.dart`
- `lib/widgets/connection_status_card.dart`
- `docs/RELEASE_v0.11.md`

## Changed Files

- `lib/main.dart`
- `lib/screens/home_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/services/server_status_service.dart`
- `lib/widgets/dashboard_menu.dart`
- `lib/branding/mybooth_brand.dart`
- `docs/ARCHITECTURE.md`
- `docs/COMMUNICATION_PROTOCOL.md`
- `docs/ROADMAP.md`

## Features Added

### Local Connection Model

Added a dedicated model for tablet-to-laptop connection state:

- server IP address
- server port
- endpoint display
- connection state
- user-facing status message
- last checked timestamp

### Local Connection Provider

Added provider-managed connection state:

- load saved connection settings
- update server IP and port
- run mock handshake
- notify UI when state changes

### Local Connection Service

Added service-backed persistence using `SharedPreferences`:

- saves server IP
- saves server port
- loads defaults
- performs mock handshake

### Local Connection Screen

Added a new screen for the operator to manage tablet/server connection settings:

- server IP input
- server port input
- save action
- mock handshake action
- private Wi-Fi workflow explanation
- future API contract preview

### Dashboard Connection Indicator

Added a dashboard card showing the current local connection endpoint and state.

### Dashboard Navigation

Added a `Local Connection` dashboard menu item.

### Server Foundation Update

Updated server status copy to show that local connection settings now exist while real discovery and pairing are still future work.

## Testing Checklist

Run:

```powershell
flutter clean
flutter pub get
flutter analyze
flutter run -d chrome
```

Then verify:

- App opens with branded splash screen.
- Dashboard shows Local Connection card.
- Dashboard Local Connection button opens the new screen.
- Server IP defaults to `192.168.4.1`.
- Server port defaults to `8080`.
- Save button works.
- Test Handshake button shows a successful mock connection.
- Local Connection dashboard card updates after mock handshake.
- Server Status screen still opens.
- Theme Gallery still works.
- Create Event still works.
- Continue Event still opens Event Details.
- `flutter analyze` reports no issues.

## Git Commit

```powershell
git add .
git commit -m "Release MyBooth v0.11 local connection foundation"
git push origin feature/theme-engine
```

## Notes

The mock handshake is intentional. It proves that the client-side state, settings, persistence, and UI flow are ready before the real laptop server process is introduced.
