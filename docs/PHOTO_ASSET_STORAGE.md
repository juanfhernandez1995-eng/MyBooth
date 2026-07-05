# MyBooth Photo + Asset Storage Foundation

MyBooth treats the gaming laptop as the source of truth for all photo captures, templates, backgrounds, overlays, print files, gallery files, and logs.

## Storage Root

```text
mybooth_data/
├── assets/
│   ├── backgrounds/
│   │   ├── wedding/
│   │   ├── baptism/
│   │   ├── birthday/
│   │   ├── corporate/
│   │   └── seasonal/
│   ├── templates/
│   │   ├── wedding/
│   │   ├── baptism/
│   │   ├── birthday/
│   │   ├── corporate/
│   │   └── seasonal/
│   └── borders/
│       ├── 2x6/
│       └── 4x6/
└── events/
    └── 2026-07-04_event-slug/
        ├── event.json
        ├── captures/
        │   ├── original/
        │   ├── processed/
        │   ├── composited/
        │   ├── bordered/
        │   └── thumbnails/
        ├── prints/
        │   ├── strips/
        │   └── reprints/
        ├── gallery/
        └── logs/
```

## Original Photo Rule

Original Canon EOS R50 captures are never overwritten. MyBooth saves every derivative separately:

- processed image
- green screen / AI background composite
- bordered/template version
- print-ready version
- gallery version
- thumbnail

## Template Requirements

Templates support:

- 2x6 strips
- 4x6 prints
- editable event title
- editable honoree/person name
- editable date
- editable subtitle
- interchangeable color palettes
- event categories: weddings, baptisms, birthdays, corporate, seasonal

## Green Screen Requirements

Background packs are separate from templates so events can mix and match:

- one border/template
- one color palette
- one or more background packs
- green screen enabled/disabled per event

## Capture Countdown

Each event stores countdown settings:

- countdown seconds
- delay between strip photos
- smile message
- flash screen effect
- sound effects
- retake allowed

This release does not connect the Canon camera yet. It creates the data and folder foundation so the future camera integration can plug into a stable pipeline.

## Guest QR Delivery Rule

Guest-facing QR codes should link to the finished event-ready output, not the raw camera originals.

Default behavior:

```text
Guest QR
→ final bordered/composited session gallery
→ 2x6 strip or 4x6 grid with selected template, event text, date, and background
```

Operator-only storage still keeps originals and intermediate files:

```text
captures/original
captures/processed
captures/composited
captures/bordered
prints/strips
prints/reprints
gallery/final
gallery/qr
gallery/google_photos_exports
logs
```

## Google Photos Future Export

Google Photos should be treated as a delivery/export target, not the only source of storage.

Planned rule:

```text
Local MyBooth Server = source of truth
Google Photos event album = final guest-ready bordered outputs only
```

Raw originals should not be uploaded to Google Photos by default. A future operator-only export setting can allow originals to be exported when needed.

## Booth Mode Foundation

The guest-facing booth screen should remain a single simple flow:

```text
Start
→ Countdown
→ Capture photo sequence
→ Processing
→ Final bordered preview
→ QR code
→ Start next session
```

Operator setup screens can stay separate. Guests should not see server settings, templates, event configuration, or admin menus during Booth Mode.
