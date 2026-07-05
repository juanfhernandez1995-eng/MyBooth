from __future__ import annotations

from dataclasses import asdict, dataclass
from typing import Any


@dataclass(frozen=True)
class AssetTemplate:
    template_id: str
    name: str
    category: str
    layout: str
    photo_slots: int
    editable_text_fields: list[str]
    color_palettes: list[str]
    supports_green_screen: bool
    status: str = 'metadata_ready'

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


@dataclass(frozen=True)
class BackgroundPack:
    background_pack_id: str
    name: str
    category: str
    green_screen_ready: bool
    status: str = 'folder_ready'

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


class AssetLibraryService:
    def templates(self) -> list[AssetTemplate]:
        text_fields = ['eventTitle', 'honoreeName', 'eventDate', 'subtitle']
        return [
            AssetTemplate('wedding_floral_2x6', 'Wedding Floral Strip', 'Wedding', '2x6', 3, text_fields, ['Rose Gold', 'Sage + Ivory', 'Dusty Blue'], True),
            AssetTemplate('wedding_floral_4x6', 'Wedding Floral 4x6', 'Wedding', '4x6', 1, text_fields, ['Rose Gold', 'Sage + Ivory', 'Dusty Blue'], True),
            AssetTemplate('wedding_luxury_2x6', 'Wedding Luxury Strip', 'Wedding', '2x6', 3, text_fields, ['Rose Gold', 'Sage + Ivory', 'Dusty Blue'], True),
            AssetTemplate('wedding_luxury_4x6', 'Wedding Luxury 4x6', 'Wedding', '4x6', 1, text_fields, ['Rose Gold', 'Sage + Ivory', 'Dusty Blue'], True),
            AssetTemplate('baptism_classic_2x6', 'Baptism Classic Strip', 'Baptism', '2x6', 3, text_fields, ['Soft Blue', 'Soft Pink', 'Neutral Ivory'], True),
            AssetTemplate('baptism_classic_4x6', 'Baptism Classic 4x6', 'Baptism', '4x6', 1, text_fields, ['Soft Blue', 'Soft Pink', 'Neutral Ivory'], True),
            AssetTemplate('baptism_angel_2x6', 'Baptism Angel Strip', 'Baptism', '2x6', 3, text_fields, ['Soft Blue', 'Soft Pink', 'Neutral Ivory'], True),
            AssetTemplate('baptism_angel_4x6', 'Baptism Angel 4x6', 'Baptism', '4x6', 1, text_fields, ['Soft Blue', 'Soft Pink', 'Neutral Ivory'], True),
            AssetTemplate('birthday_confetti_2x6', 'Birthday Confetti Strip', 'Birthday', '2x6', 3, text_fields, ['Confetti Bright', 'Neon Party', 'Pastel Fun'], True),
            AssetTemplate('birthday_confetti_4x6', 'Birthday Confetti 4x6', 'Birthday', '4x6', 1, text_fields, ['Confetti Bright', 'Neon Party', 'Pastel Fun'], True),
            AssetTemplate('birthday_neon_2x6', 'Birthday Neon Strip', 'Birthday', '2x6', 3, text_fields, ['Confetti Bright', 'Neon Party', 'Pastel Fun'], True),
            AssetTemplate('birthday_neon_4x6', 'Birthday Neon 4x6', 'Birthday', '4x6', 1, text_fields, ['Confetti Bright', 'Neon Party', 'Pastel Fun'], True),
            AssetTemplate('corporate_modern_2x6', 'Corporate Modern Strip', 'Corporate', '2x6', 3, text_fields, ['Navy + Cyan', 'Charcoal + Gold', 'White + Magenta'], False),
            AssetTemplate('corporate_modern_4x6', 'Corporate Modern 4x6', 'Corporate', '4x6', 1, text_fields, ['Navy + Cyan', 'Charcoal + Gold', 'White + Magenta'], False),
            AssetTemplate('corporate_gala_2x6', 'Corporate Gala Strip', 'Corporate', '2x6', 3, text_fields, ['Navy + Cyan', 'Charcoal + Gold', 'White + Magenta'], False),
            AssetTemplate('corporate_gala_4x6', 'Corporate Gala 4x6', 'Corporate', '4x6', 1, text_fields, ['Navy + Cyan', 'Charcoal + Gold', 'White + Magenta'], False),
            AssetTemplate('beach_party_2x6', 'Beach Party Strip', 'Seasonal', '2x6', 3, text_fields, ['Aqua + Sand', 'Sunset Pink', 'Tropical Green'], True),
            AssetTemplate('beach_party_4x6', 'Beach Party 4x6', 'Seasonal', '4x6', 1, text_fields, ['Aqua + Sand', 'Sunset Pink', 'Tropical Green'], True),
        ]

    def template_designer_plan(self) -> dict[str, Any]:
        return {
            'editableFields': ['eventTitle', 'honoreeName', 'eventDate', 'subtitle'],
            'supportedCategories': ['Wedding', 'Baptism', 'Birthday', 'Corporate', 'Seasonal'],
            'supportedLayouts': ['2x6', '4x6'],
            'renderingRule': 'Template Designer saves metadata first. Later rendering will generate final bordered PNG/JPEG outputs for QR, gallery, Google Photos, and print files.',
            'guestDeliveryRule': 'Guests receive final bordered/composited outputs only. Raw originals remain operator-only.',
        }

    def background_packs(self) -> list[BackgroundPack]:
        return [
            BackgroundPack('bg_wedding_romance', 'Wedding Romance', 'Wedding', True),
            BackgroundPack('bg_baptism_soft_light', 'Baptism Soft Light', 'Baptism', True),
            BackgroundPack('bg_birthday_party', 'Birthday Party', 'Birthday', True),
            BackgroundPack('bg_corporate_clean', 'Corporate Clean', 'Corporate', False),
            BackgroundPack('bg_beach_summer', 'Beach Summer', 'Seasonal', True),
        ]
