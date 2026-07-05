enum ServerModuleType {
  myBoothServer,
  tabletClient,
  privateNetwork,
  camera,
  printer,
  aiEngine,
  galleryStorage,
}

enum ServerModuleStatus {
  ready,
  planned,
  offline,
  attention,
}

class ServerModule {
  final ServerModuleType type;
  final String title;
  final String description;
  final ServerModuleStatus status;
  final String statusLabel;
  final String detail;

  const ServerModule({
    required this.type,
    required this.title,
    required this.description,
    required this.status,
    required this.statusLabel,
    required this.detail,
  });

  bool get isReady => status == ServerModuleStatus.ready;
  bool get needsAttention => status == ServerModuleStatus.attention;
}
