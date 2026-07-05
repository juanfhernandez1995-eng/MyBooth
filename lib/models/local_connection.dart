enum LocalConnectionState {
  notConfigured,
  configured,
  checking,
  connected,
  failed,
}

enum LocalConnectionPresetType {
  laptopTest,
  boothRouter,
  custom,
}

class LocalConnectionPreset {
  final LocalConnectionPresetType type;
  final String name;
  final String description;
  final String serverIp;
  final int serverPort;

  const LocalConnectionPreset({
    required this.type,
    required this.name,
    required this.description,
    required this.serverIp,
    required this.serverPort,
  });

  String get endpoint => 'http://$serverIp:$serverPort';
}

class LocalConnection {
  final String serverIp;
  final int serverPort;
  final LocalConnectionState state;
  final String message;
  final DateTime? lastChecked;
  final String? serverName;
  final String? serverVersion;
  final int? moduleCount;
  final int? responseTimeMs;
  final String? lastError;

  const LocalConnection({
    required this.serverIp,
    required this.serverPort,
    required this.state,
    required this.message,
    this.lastChecked,
    this.serverName,
    this.serverVersion,
    this.moduleCount,
    this.responseTimeMs,
    this.lastError,
  });

  factory LocalConnection.defaultConnection() {
    return const LocalConnection(
      serverIp: '192.168.4.1',
      serverPort: 8080,
      state: LocalConnectionState.configured,
      message: 'Booth router preset prepared. Start the laptop server and run a real handshake.',
    );
  }

  factory LocalConnection.localhostConnection() {
    return const LocalConnection(
      serverIp: '127.0.0.1',
      serverPort: 8080,
      state: LocalConnectionState.configured,
      message: 'Laptop test preset prepared. Use this when Flutter and the server run on the same computer.',
    );
  }

  static const LocalConnectionPreset laptopTestPreset = LocalConnectionPreset(
    type: LocalConnectionPresetType.laptopTest,
    name: 'Laptop Test',
    description: 'Use while developing on the same laptop with Chrome and the Python server.',
    serverIp: '127.0.0.1',
    serverPort: 8080,
  );

  static const LocalConnectionPreset boothRouterPreset = LocalConnectionPreset(
    type: LocalConnectionPresetType.boothRouter,
    name: 'Booth Router',
    description: 'Use for the private MyBooth Wi-Fi router once the laptop server is on the booth network.',
    serverIp: '192.168.4.1',
    serverPort: 8080,
  );

  static const List<LocalConnectionPreset> presets = [
    laptopTestPreset,
    boothRouterPreset,
  ];

  String get endpoint => 'http://$serverIp:$serverPort';

  bool get isConfigured => serverIp.trim().isNotEmpty && serverPort > 0;

  bool get isConnected => state == LocalConnectionState.connected;

  bool get isChecking => state == LocalConnectionState.checking;

  LocalConnectionPresetType get activePresetType {
    if (serverIp == laptopTestPreset.serverIp && serverPort == laptopTestPreset.serverPort) {
      return LocalConnectionPresetType.laptopTest;
    }
    if (serverIp == boothRouterPreset.serverIp && serverPort == boothRouterPreset.serverPort) {
      return LocalConnectionPresetType.boothRouter;
    }
    return LocalConnectionPresetType.custom;
  }

  String get activePresetLabel {
    switch (activePresetType) {
      case LocalConnectionPresetType.laptopTest:
        return 'Laptop Test';
      case LocalConnectionPresetType.boothRouter:
        return 'Booth Router';
      case LocalConnectionPresetType.custom:
        return 'Custom Address';
    }
  }

  String get stateLabel {
    switch (state) {
      case LocalConnectionState.notConfigured:
        return 'Not configured';
      case LocalConnectionState.configured:
        return 'Ready to pair';
      case LocalConnectionState.checking:
        return 'Checking';
      case LocalConnectionState.connected:
        return 'Paired';
      case LocalConnectionState.failed:
        return 'Needs attention';
    }
  }

  String get serverSummary {
    final name = serverName ?? 'MyBooth Server';
    final version = serverVersion;
    if (version == null || version.isEmpty) {
      return name;
    }
    return '$name $version';
  }

  String get diagnosticsSummary {
    final parts = <String>[];
    if (responseTimeMs != null) {
      parts.add('${responseTimeMs}ms');
    }
    if (moduleCount != null) {
      parts.add('$moduleCount modules');
    }
    return parts.join(' • ');
  }

  String get pairingSummary {
    if (isConnected) {
      final diagnostics = diagnosticsSummary;
      if (diagnostics.isEmpty) {
        return '$serverSummary paired at $endpoint';
      }
      return '$serverSummary paired at $endpoint • $diagnostics';
    }
    return '$activePresetLabel • $endpoint';
  }

  LocalConnection copyWith({
    String? serverIp,
    int? serverPort,
    LocalConnectionState? state,
    String? message,
    DateTime? lastChecked,
    String? serverName,
    String? serverVersion,
    int? moduleCount,
    int? responseTimeMs,
    String? lastError,
    bool clearServerMetadata = false,
    bool clearLastError = false,
  }) {
    return LocalConnection(
      serverIp: serverIp ?? this.serverIp,
      serverPort: serverPort ?? this.serverPort,
      state: state ?? this.state,
      message: message ?? this.message,
      lastChecked: lastChecked ?? this.lastChecked,
      serverName: clearServerMetadata ? null : serverName ?? this.serverName,
      serverVersion: clearServerMetadata ? null : serverVersion ?? this.serverVersion,
      moduleCount: clearServerMetadata ? null : moduleCount ?? this.moduleCount,
      responseTimeMs: clearServerMetadata ? null : responseTimeMs ?? this.responseTimeMs,
      lastError: clearLastError ? null : lastError ?? this.lastError,
    );
  }
}
