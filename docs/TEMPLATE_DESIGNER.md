# MyBooth Template Designer

MyBooth templates are event-ready border/layout definitions. They are not just thin frames. A template controls the final guest-facing output style for 2x6 strips and 4x6 prints.

## Template designer goals

- Choose a category: Wedding, Baptism, Birthday, Corporate, or Seasonal.
- Choose a 2x6 or 4x6 template.
- Edit the event title.
- Edit the person, honoree, couple, child, company, or host name.
- Edit a subtitle, age, blessing, or custom line.
- Choose an interchangeable color palette.
- Choose the event background pack.
- Save the selected template design to the event profile.

## Guest output rule

Guests should receive the final bordered/composited output through QR, gallery, Google Photos export, or printing. Raw Canon originals stay operator-only.

## Future rendering plan

The current v0.18 designer saves template metadata. Later releases will render the actual final PNG/JPEG files by combining:

1. original Canon captures,
2. optional green screen/background processing,
3. selected template geometry,
4. selected color palette,
5. editable event text,
6. final print/gallery export settings.

## Starter categories

- Weddings: Floral and Luxury families.
- Baptisms: Classic and Angel families.
- Birthdays: Confetti and Neon families.
- Corporate: Modern and Gala families.
- Seasonal: Beach Party family.

## Supported layouts

- 2x6 Strip
- 4x6 Print

## Required data saved per event

- `templateId`
- `templateName`
- `templateCategory`
- `templatePaletteId`
- `templatePaletteName`
- `eventName`
- `honoreeName`
- `eventSubtitle`
- `backgroundPackId`
- `backgroundPackName`
- `greenScreenEnabled`
