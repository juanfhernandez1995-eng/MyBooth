from __future__ import annotations

from dataclasses import asdict, dataclass
from typing import Any


@dataclass(frozen=True)
class PhotoStoragePlan:
    root: str
    event_folder_pattern: str
    event_folders: list[str]
    asset_folders: list[str]
    original_preservation_rule: str

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


class PhotoStorageService:
    def storage_plan(self) -> PhotoStoragePlan:
        return PhotoStoragePlan(
            root='mybooth_data',
            event_folder_pattern='events/{event_date}_{event_slug}',
            event_folders=[
                'event.json',
                'captures/original',
                'captures/processed',
                'captures/composited',
                'captures/bordered',
                'captures/thumbnails',
                'prints/strips',
                'prints/reprints',
                'gallery/final',
                'gallery/qr',
                'gallery/google_photos_exports',
                'logs',
            ],
            asset_folders=[
                'assets/backgrounds/wedding',
                'assets/backgrounds/baptism',
                'assets/backgrounds/birthday',
                'assets/backgrounds/corporate',
                'assets/backgrounds/seasonal',
                'assets/templates/wedding',
                'assets/templates/baptism',
                'assets/templates/birthday',
                'assets/templates/corporate',
                'assets/templates/seasonal',
                'assets/borders/2x6',
                'assets/borders/4x6',
            ],
            original_preservation_rule='Original Canon captures are never overwritten. Guest QR codes and Google Photos exports point to final bordered/composited outputs, while raw originals remain operator-only backups.',
        )
