# MyBooth v0.8.1 Layout Polish

## Release Goal

MyBooth v0.8.1 is a layout polish release focused on the Theme Gallery screen.

The v0.8 theme engine works, but the Theme Gallery cards could overflow vertically in Chrome/web debug mode. This release fixes that layout issue while preserving the working theme engine, live theme switching, and saved theme selection from v0.8.

## Changed Files

### `lib/screens/theme_gallery_screen.dart`

Replaced the Theme Gallery implementation with a more responsive layout:

- Added `SafeArea` around the gallery body.
- Added `LayoutBuilder` so the grid can adapt to available screen width.
- Replaced aspect-ratio-based card sizing with explicit `mainAxisExtent` sizing.
- Removed nested `FilledButton` / `OutlinedButton` controls inside the tappable card.
- Added a lightweight theme selection pill to avoid vertical RenderFlex overflow.
- Added `Semantics` metadata for better accessibility.
- Kept the whole card tappable.
- Kept live theme switching through `ThemeProvider.selectTheme()`.
- Kept selected-theme snackbar confirmation.

## New Files

### `docs/RELEASE_v0.8.1.md`

Documents this release, testing checklist, and Git commit message.

## Folder Changes

No folder structure changes.

## Testing Checklist

Run these commands from the project root:

```bash
flutter clean
flutter pub get
flutter analyze
flutter run -d chrome
```

Then verify:

- Dashboard opens successfully.
- Theme Gallery opens successfully.
- No yellow/black overflow warning appears on theme cards.
- No `RenderFlex overflowed` exception appears in the terminal.
- Selecting Classic Purple changes the app theme immediately.
- Selecting Wedding Gold changes the app theme immediately.
- Selecting Birthday Confetti changes the app theme immediately.
- Selecting Graduation Blue changes the app theme immediately.
- Selecting Corporate Black changes the app theme immediately.
- Selecting Holiday Red changes the app theme immediately.
- The selected theme pill updates correctly.
- The snackbar shows the selected theme name.
- Returning to the dashboard shows the active theme.
- Stopping and restarting the app keeps the saved theme.

## Git Commit Message

```bash
git add .
git commit -m "Release MyBooth v0.8.1 layout polish"
git push origin feature/theme-engine
```

## Notes

This release does not change the MyBooth hardware architecture. The Android tablet remains the customer/operator interface, and the gaming laptop remains the MyBooth Server responsible for camera, printer, AI engine, gallery, and event storage.
