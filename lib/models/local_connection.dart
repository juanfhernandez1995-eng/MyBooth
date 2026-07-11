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
  final String? lastSuccessfulServerIp;
  final int? lastSuccessfulServerPort;

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
    this.lastSuccessfulServerIp,
    this.lastSuccessfulServerPort,
  });

  factory LocalConnection.defaultConnection() {
    return const LocalConnection(
      serverIp: '192.168.4.1',
      serverPort: 8080,
      state: LocalConnectionState.configured,
      message: 'Booth router preset prepared. This is only a starting point. Use the laptop IPv4 address from ipconfig if your router assigns a different address.',
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
    name: 'Booth Router Example',
    description: 'Starter preset only. Your real router may assign the laptop a different IPv4 address.',
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

  bool get hasLastSuccessfulServerAddress {
    return lastSuccessfulServerIp != null &&
        lastSuccessfulServerIp!.trim().isNotEmpty &&
        lastSuccessfulServerPort != null &&
        lastSuccessfulServerPort! > 0;
  }

  String get lastSuccessfulEndpoint {
    if (!hasLastSuccessfulServerAddress) {
      return 'No successful booth server address saved yet.';
    }
    return 'http://$lastSuccessfulServerIp:$lastSuccessfulServerPort';
  }

  bool get isUsingLastSuccessfulAddress {
    return hasLastSuccessfulServerAddress &&
        serverIp == lastSuccessfulServerIp &&
        serverPort == lastSuccessfulServerPort;
  }

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
    if (isUsingLastSuccessfulAddress) {
      return 'Last Successful';
    }

    switch (activePresetType) {
      case LocalConnectionPresetType.laptopTest:
        return 'Laptop Test';
      case LocalConnectionPresetType.boothRouter:
        return 'Booth Router Example';
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

  String get routerPairingTip {
    if (isConnected) {
      return 'This address worked. MyBooth will remember it as the last successful server address.';
    }
    if (hasLastSuccessfulServerAddress) {
      return 'Last successful address: $lastSuccessfulEndpoint. Use it if the router has not changed the laptop IP.';
    }
    return 'Run ipconfig on the laptop and use the Wi-Fi IPv4 Address. The router preset is only an example.';
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
    String? lastSuccessfulServerIp,
    int? lastSuccessfulServerPort,
    bool clearServerMetadata = false,
    bool clearLastError = false,
    bool clearLastSuccessfulServerAddress = false,
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
      lastSuccessfulServerIp: clearLastSuccessfulServerAddress
          ? null
          : lastSuccessfulServerIp ?? this.lastSuccessfulServerIp,
      lastSuccessfulServerPort: clearLastSuccessfulServerAddress
          ? null
          : lastSuccessfulServerPort ?? this.lastSuccessfulServerPort,
    );
  }
}
