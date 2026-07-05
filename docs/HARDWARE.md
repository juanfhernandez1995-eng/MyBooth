# MyBooth Hardware

## Current Hardware Plan

### Main Computer

Gaming laptop

Role:

- Runs MyBooth Server
- Controls camera
- Controls printer
- Stores event files
- Processes photos
- Hosts local gallery
- Handles AI features

### Camera

Canon EOS R50

Role:

- Main photo capture camera
- Connected to laptop
- Used for high-quality booth photos
- Controlled by the MyBooth Server in a future release

### Tablet

Android tablet

Role:

- Customer/operator MyBooth interface
- Runs vertically
- Connects to the laptop over private Wi-Fi
- Starts events
- Shows countdown/status screens
- Shows gallery and QR screens in future releases
- Does not directly control camera or printer

### Printer

DNP DS-RX1HS

Role:

- High-volume event printing
- Supports 4x6 prints
- Supports 2x6 photo strips using compatible media/cutter setup
- Controlled by the MyBooth Server in a future release

### Network

Dedicated local Wi-Fi network

Role:

- Connects Android tablet to laptop
- Allows booth to work without venue Wi-Fi
- Keeps communication fast and reliable
- Supports local-first event workflows

## v0.10 Server Foundation

The Flutter app now includes status placeholders for:

- MyBooth Server laptop
- Android tablet client
- Private Wi-Fi network
- Canon EOS R50
- DNP DS-RX1HS printer
- AI background engine
- Local gallery storage

These are architecture placeholders. Hardware is not connected yet.

## Design Decision

The laptop replaces the Raspberry Pi.

Reason:

- More processing power
- Easier Canon camera support
- Easier printer driver support
- Better AI performance
- Easier development and troubleshooting
