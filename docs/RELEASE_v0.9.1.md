# MyBooth v0.9.1 — Branding Polish

## Summary
This release adds MyBooth branding to the app and polishes the product identity while keeping the v0.9 event flow intact.

## Revision
This package includes the corrected logo scale revision. The original v0.9.1 logo appeared too small because the source image had extra canvas padding. The logo assets are now cropped tighter and displayed at larger production-ready sizes.

## Changed files
- `pubspec.yaml`
- `web/index.html`
- `web/manifest.json`
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`
- `lib/main.dart`
- `lib/branding/mybooth_brand.dart`
- `lib/screens/splash_screen.dart`
- `lib/screens/home_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/widgets/brand_lockup.dart`
- `lib/widgets/brand_mark.dart`
- `lib/widgets/dashboard_header.dart`

## New files
- `assets/branding/mybooth_logo.png`
- `assets/branding/mybooth_logo_on_light.png`
- `assets/branding/mybooth_mark.png`
- `docs/RELEASE_v0.9.1.md`

## Folder changes
- Added `assets/branding/`
- Added `lib/branding/`

## Testing checklist
- Run `flutter clean`
- Run `flutter pub get`
- Run `flutter analyze`
- Run `flutter run -d chrome`
- Confirm splash logo is large and readable
- Confirm Dashboard logo is large and readable
- Confirm Dashboard still shows active theme
- Confirm Theme Gallery still switches themes live
- Confirm Create Event still opens Event Details
- Confirm Continue Event still opens Event Details
- Confirm no RenderFlex overflow warnings appear

## Git commit message
```bash
git add .
git commit -m "Release MyBooth v0.9.1 branding polish"
git push origin feature/theme-engine
```
