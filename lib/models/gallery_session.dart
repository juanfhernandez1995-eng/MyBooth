import 'event.dart';

enum GalleryAssetKind {
  finalGuestOutput,
  qrCode,
  googlePhotosExport,
}

class GalleryAsset {
  final String id;
  final String title;
  final String fileName;
  final String relativePath;
  final GalleryAssetKind kind;
  final bool guestVisible;

  const GalleryAsset({
    required this.id,
    required this.title,
    required this.fileName,
    required this.relativePath,
    required this.kind,
    required this.guestVisible,
  });

  String get kindLabel {
    switch (kind) {
      case GalleryAssetKind.finalGuestOutput:
        return 'Final bordered guest photo';
      case GalleryAssetKind.qrCode:
        return 'QR code';
      case GalleryAssetKind.googlePhotosExport:
        return 'Google Photos export copy';
    }
  }
}

class GuestGallerySession {
  final String sessionId;
  final String eventId;
  final String eventName;
  final String honoreeName;
  final String eventDate;
  final String templateName;
  final String layoutName;
  final String guestGalleryUrl;
  final List<GalleryAsset> guestAssets;
  final List<String> operatorOnlyFolders;
  final String deliveryNote;

  const GuestGallerySession({
    required this.sessionId,
    required this.eventId,
    required this.eventName,
    required this.honoreeName,
    required this.eventDate,
    required this.templateName,
    required this.layoutName,
    required this.guestGalleryUrl,
    required this.guestAssets,
    required this.operatorOnlyFolders,
    required this.deliveryNote,
  });

  factory GuestGallerySession.fromEvent(BoothEvent event) {
    final sessionId = _sessionIdFromEvent(event);
    final layoutName = _layoutNameFromEvent(event);
    final outputName = layoutName.toLowerCase().contains('4x6') ? '4x6_grid_final.jpg' : '2x6_strip_final.jpg';

    return GuestGallerySession(
      sessionId: sessionId,
      eventId: event.id,
      eventName: event.displayName,
      honoreeName: event.displayHonoree,
      eventDate: event.displayDate,
      templateName: event.templateSummary,
      layoutName: layoutName,
      guestGalleryUrl: 'http://192.168.4.1:8080/gallery/session/$sessionId',
      guestAssets: [
        GalleryAsset(
          id: '${sessionId}_final',
          title: 'Final ${layoutName.toLowerCase()}',
          fileName: outputName,
          relativePath: 'gallery/final/$outputName',
          kind: GalleryAssetKind.finalGuestOutput,
          guestVisible: true,
        ),
        GalleryAsset(
          id: '${sessionId}_qr',
          title: 'Session QR code',
          fileName: 'session_qr.png',
          relativePath: 'gallery/qr/session_qr.png',
          kind: GalleryAssetKind.qrCode,
          guestVisible: true,
        ),
        GalleryAsset(
          id: '${sessionId}_google_photos',
          title: 'Future Google Photos album copy',
          fileName: outputName,
          relativePath: 'gallery/google_photos_exports/$outputName',
          kind: GalleryAssetKind.googlePhotosExport,
          guestVisible: false,
        ),
      ],
      operatorOnlyFolders: const [
        'captures/original',
        'captures/processed',
        'captures/composited',
        'prints/strips',
        'logs',
      ],
      deliveryNote: 'Guest QR links show final bordered/composited outputs only. Raw originals stay operator-only.',
    );
  }

  List<GalleryAsset> get visibleGuestAssets {
    return guestAssets.where((asset) => asset.guestVisible).toList();
  }

  static String _sessionIdFromEvent(BoothEvent event) {
    final clean = event.id.trim().isEmpty ? event.displayName : event.id;
    final slug = clean.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-|-$'), '');
    return slug.isEmpty ? 'demo-session' : 'session-$slug';
  }

  static String _layoutNameFromEvent(BoothEvent event) {
    if (event.photoLayout.toLowerCase().contains('4')) {
      return '4x6 Photo Grid';
    }
    if (event.templateName.toLowerCase().contains('4x6')) {
      return '4x6 Photo Grid';
    }
    return '2x6 Photo Strip';
  }
}
