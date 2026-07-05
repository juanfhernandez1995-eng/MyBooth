import 'package:flutter/material.dart';

import '../models/booth_asset.dart';

class TemplateLibraryService {
  List<BoothTemplate> loadStarterTemplates() {
    return const [
      BoothTemplate(
        id: 'wedding_floral_2x6',
        familyId: 'wedding_floral',
        name: 'Wedding Floral Strip',
        category: TemplateCategory.wedding,
        layout: BoothPrintLayout.strip2x6,
        description: 'Romantic floral frame with editable couple name, date, and subtitle.',
        photoSlots: 3,
        supportsGreenScreen: true,
        palettes: _weddingPalettes,
        textSlots: _eventTextSlots,
      ),
      BoothTemplate(
        id: 'wedding_floral_4x6',
        familyId: 'wedding_floral',
        name: 'Wedding Floral 4x6',
        category: TemplateCategory.wedding,
        layout: BoothPrintLayout.print4x6,
        description: 'Single-photo wedding print with premium floral border and editable text.',
        photoSlots: 1,
        supportsGreenScreen: true,
        palettes: _weddingPalettes,
        textSlots: _eventTextSlots,
      ),
      BoothTemplate(
        id: 'baptism_classic_2x6',
        familyId: 'baptism_classic',
        name: 'Baptism Classic Strip',
        category: TemplateCategory.baptism,
        layout: BoothPrintLayout.strip2x6,
        description: 'Soft baptism strip template with editable child name and blessing subtitle.',
        photoSlots: 3,
        supportsGreenScreen: true,
        palettes: _baptismPalettes,
        textSlots: _honoreeTextSlots,
      ),
      BoothTemplate(
        id: 'baptism_classic_4x6',
        familyId: 'baptism_classic',
        name: 'Baptism Classic 4x6',
        category: TemplateCategory.baptism,
        layout: BoothPrintLayout.print4x6,
        description: 'Elegant baptism print frame for a single photo and custom name/date.',
        photoSlots: 1,
        supportsGreenScreen: true,
        palettes: _baptismPalettes,
        textSlots: _honoreeTextSlots,
      ),
      BoothTemplate(
        id: 'birthday_confetti_2x6',
        familyId: 'birthday_confetti',
        name: 'Birthday Confetti Strip',
        category: TemplateCategory.birthday,
        layout: BoothPrintLayout.strip2x6,
        description: 'Bright birthday strip with editable name, title, date, and colorway.',
        photoSlots: 3,
        supportsGreenScreen: true,
        palettes: _birthdayPalettes,
        textSlots: _birthdayTextSlots,
      ),
      BoothTemplate(
        id: 'birthday_confetti_4x6',
        familyId: 'birthday_confetti',
        name: 'Birthday Confetti 4x6',
        category: TemplateCategory.birthday,
        layout: BoothPrintLayout.print4x6,
        description: 'Fun full-print birthday layout for parties, kids, and adult celebrations.',
        photoSlots: 1,
        supportsGreenScreen: true,
        palettes: _birthdayPalettes,
        textSlots: _birthdayTextSlots,
      ),
      BoothTemplate(
        id: 'corporate_modern_2x6',
        familyId: 'corporate_modern',
        name: 'Corporate Modern Strip',
        category: TemplateCategory.corporate,
        layout: BoothPrintLayout.strip2x6,
        description: 'Clean event strip with editable company/event name and brand-style colors.',
        photoSlots: 3,
        supportsGreenScreen: false,
        palettes: _corporatePalettes,
        textSlots: _corporateTextSlots,
      ),
      BoothTemplate(
        id: 'corporate_modern_4x6',
        familyId: 'corporate_modern',
        name: 'Corporate Modern 4x6',
        category: TemplateCategory.corporate,
        layout: BoothPrintLayout.print4x6,
        description: 'Professional 4x6 event print foundation for galas, activations, and conferences.',
        photoSlots: 1,
        supportsGreenScreen: false,
        palettes: _corporatePalettes,
        textSlots: _corporateTextSlots,
      ),
      BoothTemplate(
        id: 'wedding_luxury_2x6',
        familyId: 'wedding_luxury',
        name: 'Wedding Luxury Strip',
        category: TemplateCategory.wedding,
        layout: BoothPrintLayout.strip2x6,
        description: 'Premium formal strip with elegant corners, couple name, date, and color palette.',
        photoSlots: 3,
        supportsGreenScreen: true,
        palettes: _weddingPalettes,
        textSlots: _eventTextSlots,
      ),
      BoothTemplate(
        id: 'wedding_luxury_4x6',
        familyId: 'wedding_luxury',
        name: 'Wedding Luxury 4x6',
        category: TemplateCategory.wedding,
        layout: BoothPrintLayout.print4x6,
        description: 'Upscale 4x6 wedding layout with editable title, names, date, and subtitle.',
        photoSlots: 1,
        supportsGreenScreen: true,
        palettes: _weddingPalettes,
        textSlots: _eventTextSlots,
      ),
      BoothTemplate(
        id: 'baptism_angel_2x6',
        familyId: 'baptism_angel',
        name: 'Baptism Angel Strip',
        category: TemplateCategory.baptism,
        layout: BoothPrintLayout.strip2x6,
        description: 'Soft baptism strip with gentle light, child name, blessing, and date fields.',
        photoSlots: 3,
        supportsGreenScreen: true,
        palettes: _baptismPalettes,
        textSlots: _honoreeTextSlots,
      ),
      BoothTemplate(
        id: 'baptism_angel_4x6',
        familyId: 'baptism_angel',
        name: 'Baptism Angel 4x6',
        category: TemplateCategory.baptism,
        layout: BoothPrintLayout.print4x6,
        description: 'Elegant 4x6 baptism layout with editable child name, date, and blessing line.',
        photoSlots: 1,
        supportsGreenScreen: true,
        palettes: _baptismPalettes,
        textSlots: _honoreeTextSlots,
      ),
      BoothTemplate(
        id: 'birthday_neon_2x6',
        familyId: 'birthday_neon',
        name: 'Birthday Neon Strip',
        category: TemplateCategory.birthday,
        layout: BoothPrintLayout.strip2x6,
        description: 'High-energy party strip with editable birthday person, title, age, and colors.',
        photoSlots: 3,
        supportsGreenScreen: true,
        palettes: _birthdayPalettes,
        textSlots: _birthdayTextSlots,
      ),
      BoothTemplate(
        id: 'birthday_neon_4x6',
        familyId: 'birthday_neon',
        name: 'Birthday Neon 4x6',
        category: TemplateCategory.birthday,
        layout: BoothPrintLayout.print4x6,
        description: 'Bold 4x6 birthday design for kids, adults, and milestone birthdays.',
        photoSlots: 1,
        supportsGreenScreen: true,
        palettes: _birthdayPalettes,
        textSlots: _birthdayTextSlots,
      ),
      BoothTemplate(
        id: 'corporate_gala_2x6',
        familyId: 'corporate_gala',
        name: 'Corporate Gala Strip',
        category: TemplateCategory.corporate,
        layout: BoothPrintLayout.strip2x6,
        description: 'Polished corporate strip with company, event title, and brand-style colorway.',
        photoSlots: 3,
        supportsGreenScreen: false,
        palettes: _corporatePalettes,
        textSlots: _corporateTextSlots,
      ),
      BoothTemplate(
        id: 'corporate_gala_4x6',
        familyId: 'corporate_gala',
        name: 'Corporate Gala 4x6',
        category: TemplateCategory.corporate,
        layout: BoothPrintLayout.print4x6,
        description: 'Clean 4x6 corporate event layout for conferences, galas, and activations.',
        photoSlots: 1,
        supportsGreenScreen: false,
        palettes: _corporatePalettes,
        textSlots: _corporateTextSlots,
      ),
      BoothTemplate(
        id: 'beach_party_2x6',
        familyId: 'beach_party',
        name: 'Beach Party Strip',
        category: TemplateCategory.seasonal,
        layout: BoothPrintLayout.strip2x6,
        description: 'Summer strip inspired by beach party borders, editable title, name, and date.',
        photoSlots: 3,
        supportsGreenScreen: true,
        palettes: _beachPalettes,
        textSlots: _eventTextSlots,
      ),
      BoothTemplate(
        id: 'beach_party_4x6',
        familyId: 'beach_party',
        name: 'Beach Party 4x6',
        category: TemplateCategory.seasonal,
        layout: BoothPrintLayout.print4x6,
        description: '4x6 tropical border foundation for summer parties and destination events.',
        photoSlots: 1,
        supportsGreenScreen: true,
        palettes: _beachPalettes,
        textSlots: _eventTextSlots,
      ),
    ];
  }

  List<BackgroundPack> loadStarterBackgroundPacks() {
    return const [
      BackgroundPack(
        id: 'bg_wedding_romance',
        name: 'Wedding Romance',
        category: 'Wedding',
        description: 'Elegant florals, arches, soft champagne tones, and reception-style scenes.',
        backgroundCount: 0,
        greenScreenReady: true,
      ),
      BackgroundPack(
        id: 'bg_baptism_soft_light',
        name: 'Baptism Soft Light',
        category: 'Baptism',
        description: 'Soft blue, pink, ivory, and neutral scenes for baptism and blessing events.',
        backgroundCount: 0,
        greenScreenReady: true,
      ),
      BackgroundPack(
        id: 'bg_birthday_party',
        name: 'Birthday Party',
        category: 'Birthday',
        description: 'Confetti, balloons, neon, and colorful scenes for kids and adult birthdays.',
        backgroundCount: 0,
        greenScreenReady: true,
      ),
      BackgroundPack(
        id: 'bg_corporate_clean',
        name: 'Corporate Clean',
        category: 'Corporate',
        description: 'Modern branded looks for corporate events, galas, and activations.',
        backgroundCount: 0,
        greenScreenReady: false,
      ),
      BackgroundPack(
        id: 'bg_beach_summer',
        name: 'Beach Summer',
        category: 'Seasonal',
        description: 'Tropical, beach, sunset, water, and vacation-style scenes.',
        backgroundCount: 0,
        greenScreenReady: true,
      ),
    ];
  }

  static const List<TemplateTextSlot> _eventTextSlots = [
    TemplateTextSlot(key: 'eventTitle', label: 'Event Title', placeholder: 'Beach Party', required: true),
    TemplateTextSlot(key: 'honoreeName', label: 'Name / Honoree', placeholder: 'Sophia'),
    TemplateTextSlot(key: 'eventDate', label: 'Date', placeholder: 'June 25, 2026'),
    TemplateTextSlot(key: 'subtitle', label: 'Subtitle', placeholder: 'Thanks for celebrating with us'),
  ];

  static const List<TemplateTextSlot> _honoreeTextSlots = [
    TemplateTextSlot(key: 'eventTitle', label: 'Event Title', placeholder: 'Holy Baptism', required: true),
    TemplateTextSlot(key: 'honoreeName', label: 'Child / Honoree Name', placeholder: 'Baby Lucas', required: true),
    TemplateTextSlot(key: 'eventDate', label: 'Date', placeholder: 'May 4, 2026'),
    TemplateTextSlot(key: 'subtitle', label: 'Subtitle', placeholder: 'God bless you'),
  ];

  static const List<TemplateTextSlot> _birthdayTextSlots = [
    TemplateTextSlot(key: 'eventTitle', label: 'Event Title', placeholder: 'Birthday Party', required: true),
    TemplateTextSlot(key: 'honoreeName', label: 'Birthday Person', placeholder: 'Emily', required: true),
    TemplateTextSlot(key: 'eventDate', label: 'Date', placeholder: 'June 25, 2026'),
    TemplateTextSlot(key: 'subtitle', label: 'Subtitle / Age', placeholder: '10th Birthday'),
  ];

  static const List<TemplateTextSlot> _corporateTextSlots = [
    TemplateTextSlot(key: 'eventTitle', label: 'Event Title', placeholder: 'Holiday Gala', required: true),
    TemplateTextSlot(key: 'honoreeName', label: 'Company / Host', placeholder: 'Acme Inc.'),
    TemplateTextSlot(key: 'eventDate', label: 'Date', placeholder: 'December 12, 2026'),
    TemplateTextSlot(key: 'subtitle', label: 'Subtitle', placeholder: 'Annual celebration'),
  ];

  static const List<TemplateColorPalette> _weddingPalettes = [
    TemplateColorPalette(id: 'rose_gold', name: 'Rose Gold', primary: Color(0xFFB76E79), secondary: Color(0xFFFFF1F3), accent: Color(0xFFD4AF37)),
    TemplateColorPalette(id: 'sage_ivory', name: 'Sage + Ivory', primary: Color(0xFF6F8F72), secondary: Color(0xFFFFFBF0), accent: Color(0xFFD6C7A1)),
    TemplateColorPalette(id: 'dusty_blue', name: 'Dusty Blue', primary: Color(0xFF607D9A), secondary: Color(0xFFF2F6FA), accent: Color(0xFFC9A66B)),
  ];

  static const List<TemplateColorPalette> _baptismPalettes = [
    TemplateColorPalette(id: 'soft_blue', name: 'Soft Blue', primary: Color(0xFF77A8D8), secondary: Color(0xFFF4FAFF), accent: Color(0xFFD9B66F)),
    TemplateColorPalette(id: 'soft_pink', name: 'Soft Pink', primary: Color(0xFFE7A7B7), secondary: Color(0xFFFFF6F8), accent: Color(0xFFD8C07B)),
    TemplateColorPalette(id: 'neutral_ivory', name: 'Neutral Ivory', primary: Color(0xFFB29B7F), secondary: Color(0xFFFFFCF4), accent: Color(0xFFE0C68A)),
  ];

  static const List<TemplateColorPalette> _birthdayPalettes = [
    TemplateColorPalette(id: 'confetti_bright', name: 'Confetti Bright', primary: Color(0xFF7C3AED), secondary: Color(0xFFFFF7ED), accent: Color(0xFFEC4899)),
    TemplateColorPalette(id: 'neon_party', name: 'Neon Party', primary: Color(0xFF111827), secondary: Color(0xFFEFF6FF), accent: Color(0xFF22D3EE)),
    TemplateColorPalette(id: 'pastel_fun', name: 'Pastel Fun', primary: Color(0xFF8B5CF6), secondary: Color(0xFFFFF7FB), accent: Color(0xFFFBBF24)),
  ];

  static const List<TemplateColorPalette> _corporatePalettes = [
    TemplateColorPalette(id: 'navy_cyan', name: 'Navy + Cyan', primary: Color(0xFF101827), secondary: Color(0xFFF8FAFC), accent: Color(0xFF06B6D4)),
    TemplateColorPalette(id: 'charcoal_gold', name: 'Charcoal + Gold', primary: Color(0xFF1F2937), secondary: Color(0xFFF9FAFB), accent: Color(0xFFD4AF37)),
    TemplateColorPalette(id: 'white_magenta', name: 'White + Magenta', primary: Color(0xFF111827), secondary: Color(0xFFFFFFFF), accent: Color(0xFFEC4899)),
  ];

  static const List<TemplateColorPalette> _beachPalettes = [
    TemplateColorPalette(id: 'aqua_sand', name: 'Aqua + Sand', primary: Color(0xFF06B6D4), secondary: Color(0xFFFFF1D6), accent: Color(0xFFF97316)),
    TemplateColorPalette(id: 'sunset_pink', name: 'Sunset Pink', primary: Color(0xFFFB7185), secondary: Color(0xFFFFF7ED), accent: Color(0xFFFACC15)),
    TemplateColorPalette(id: 'tropical_green', name: 'Tropical Green', primary: Color(0xFF059669), secondary: Color(0xFFECFEFF), accent: Color(0xFF0EA5E9)),
  ];
}
