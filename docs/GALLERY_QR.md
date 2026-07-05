# MyBooth Gallery + QR Foundation

MyBooth guest QR codes should always point to the finished guest-facing gallery, not raw Canon originals.

## Guest QR Rule

Guest QR links expose:

- final bordered/composited 2x6 strips
- final bordered/composited 4x6 grids
- future download/share actions
- future Google Photos export copies

Guest QR links do **not** expose:

- raw/original Canon captures
- intermediate processed files
- green screen masks
- print job logs
- error logs

## Folder Plan

```text
mybooth_data/
└── events/
    └── event_slug/
        ├── captures/
        │   ├── original/        # operator-only
        │   ├── processed/       # operator-only
        │   ├── composited/      # operator-only/final source
        │   ├── bordered/        # final render source
        │   └── thumbnails/
        ├── prints/
        │   ├── strips/
        │   └── reprints/
        ├── gallery/
        │   ├── final/           # guest-visible final outputs
        │   ├── qr/              # generated QR codes
        │   └── google_photos_exports/
        └── logs/                # operator-only
```

## Local Server Routes

v0.19 prepares these routes:

```text
GET /gallery/qr-plan
GET /gallery/session/demo
GET /gallery/session/<session_id>
```

The current routes return JSON planning payloads. Later releases will return real gallery HTML/files or a lightweight web page that the tablet QR can open.

## Google Photos Planning

Google Photos export should be treated as delivery, not primary storage.

Default behavior:

```text
Google Photos event album = final guest-ready outputs only
Local laptop storage = source of truth for originals and all processing files
```

A later release can add:

- Google sign-in/authorization
- event album creation
- final-output upload queue
- retry failed uploads
- operator-only original export toggle

## v0.19 Status

v0.19 adds the app-side gallery preview and server-side route foundation. It does not yet generate real JPEG/PNG output files from camera captures.
