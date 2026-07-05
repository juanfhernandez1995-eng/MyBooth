# MyBooth v0.8 Release Notes

## Release Goal

MyBooth v0.8 stabilizes the Flutter client foundation and fixes the Theme Engine as a complete release instead of a file-by-file patch.

## What Changed

- Fixed live theme switching from the Theme Gallery.
- Theme Gallery now reads selected state directly from `ThemeProvider`.
- Theme selection now calls `ThemeProvider.selectTheme(theme.id)`.
- Selected theme persists using `ThemeService` and `shared_preferences`.
- `MaterialApp` rebuilds from the active `MyBoothTheme`.
- Dashboard header, cards, buttons, settings, camera, and display screens now follow the active theme.
- Removed hardcoded Theme Gallery callback from the dashboard.
- Refactored shared layout into reusable widgets.
- Added reusable empty state and card layout widgets.
- Reduced hardcoded UI colors where app theme should control styling.
- Moved event persistence into `EventService`.
- Added `ThemeService` for persistent theme storage.
- Improved event decoding so corrupted saved events do not crash startup.
- Replaced patch-style Theme Gallery API with provider-driven state.

## Root Cause Fixed

The dashboard previously opened Theme Gallery with:

```dart
selectedThemeName: "Classic Purple",
onThemeSelected: (_) {},
```

That meant Theme Gallery never updated `ThemeProvider`, and the selected theme was always passed in as Classic Purple. v0.8 removes those props and makes Theme Gallery own the provider interaction directly.

## Changed Files

- `lib/main.dart`
- `lib/models/event.dart`
- `lib/models/mybooth_theme.dart`
- `lib/providers/event_provider.dart`
- `lib/providers/theme_provider.dart`
- `lib/services/event_service.dart`
- `lib/screens/camera_screen.dart`
- `lib/screens/create_event_screen.dart`
- `lib/screens/device_selection_screen.dart`
- `lib/screens/display_screen.dart`
- `lib/screens/home_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/screens/theme_gallery_screen.dart`
- `lib/themes/app_theme.dart`
- `lib/widgets/dashboard_header.dart`
- `lib/widgets/dashboard_menu.dart`
- `lib/widgets/primary_button.dart`
- `lib/widgets/recent_events_card.dart`
- `lib/widgets/system_status_card.dart`

## New Files

- `lib/widgets/app_page.dart`
- `lib/widgets/section_card.dart`
- `lib/widgets/empty_state.dart`
- `lib/services/theme_service.dart`
- `docs/RELEASE_v0.8.md`

## Folder Changes

No existing folders were removed. The `lib/widgets/` folder now includes reusable layout/state widgets used across screens.

## Testing Checklist

Run these commands locally:

```bash
flutter clean
flutter pub get
flutter analyze
flutter run
```

Manual tests:

1. Launch MyBooth.
2. Open Theme Gallery.
3. Select Wedding Gold.
4. Confirm the app bar, dashboard icon, buttons, snackbar, and active theme label update immediately.
5. Select Birthday Confetti.
6. Return to Dashboard and confirm the selected theme remains active.
7. Close and relaunch the app.
8. Confirm the last selected theme is still active.
9. Create a new event.
10. Confirm the event saves and opens Choose Station.
11. Return home and confirm the recent event appears.
12. Delete the event and confirm it disappears.
13. Open Settings and confirm active theme is shown.
14. Open Camera Station and Display Station and confirm both use the active app theme.

## Git Commit Message

```bash
git add .
git commit -m "Release MyBooth v0.8 theme engine"
git push origin feature/theme-engine
```
