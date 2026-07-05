# MyBooth v0.9 Event Flow

## Release Summary

MyBooth v0.9 strengthens the event workflow so each event has a clearer profile, a dedicated detail hub, and a better continuation path from the dashboard.

This release keeps Flutter as the operator/customer interface while preparing the app structure for future laptop-server integrations, including Canon EOS R50 control, DNP DS-RX1HS printing, QR galleries, AI backgrounds, and local event storage.

## Goals Completed

- Improved Create Event flow.
- Added event date selection.
- Added operator notes.
- Added event status model.
- Added event detail screen.
- Added setup readiness checklist.
- Continue Event now opens the latest event detail hub.
- Recent Events now opens the event detail hub instead of jumping straight to station selection.
- Device selection now shows the event summary before selecting a station.
- Event storage remains backward compatible with older saved events.
- Architecture remains provider-driven with business logic outside the UI where practical.

## Changed Files

- `lib/models/event.dart`
- `lib/providers/event_provider.dart`
- `lib/services/event_service.dart`
- `lib/screens/create_event_screen.dart`
- `lib/screens/home_screen.dart`
- `lib/screens/device_selection_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/widgets/recent_events_card.dart`

## New Files

- `lib/screens/event_detail_screen.dart`
- `lib/widgets/event_summary_card.dart`
- `docs/RELEASE_v0.9.md`

## Folder Changes

No new folders were added.

## Architecture Notes

### Event model

`BoothEvent` now includes:

- `createdAt`
- `status`
- `notes`

Older saved events remain compatible because `fromJson` provides safe defaults.

### Event provider

`EventProvider` now keeps events sorted newest-first and exposes:

- `latestEvent`
- `updateEvent`

This supports a cleaner Continue Event workflow and prepares for future event lifecycle updates.

### Event detail hub

The new Event Detail screen is now the central place to continue a saved event. From there, the operator can review the event profile, check setup readiness, mark an event ready, and continue into station selection.

## Testing Checklist

Run:

```powershell
flutter clean
flutter pub get
flutter analyze
flutter run -d chrome
```

Then test:

- Create a new event.
- Pick a date.
- Select a theme.
- Change print copies.
- Add optional notes.
- Tap Create Event Profile.
- Confirm Event Details opens.
- Confirm Event Summary displays correctly.
- Tap Continue Setup.
- Confirm Choose Station opens.
- Return to dashboard.
- Tap Continue Event.
- Confirm it opens the latest Event Details screen.
- Open Recent Events.
- Tap a saved event.
- Confirm it opens Event Details.
- Delete a saved event.
- Restart the app.
- Confirm saved events still load.
- Confirm older v0.8/v0.8.1/v0.8.2 events still load.

## Git Commit Message

```bash
git add .
git commit -m "Release MyBooth v0.9 event flow"
git push origin feature/theme-engine
```
