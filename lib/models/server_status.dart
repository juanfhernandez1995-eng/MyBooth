import 'server_module.dart';

class ServerStatus {
  final String serverName;
  final String connectionMode;
  final String serverAddress;
  final DateTime lastChecked;
  final List<ServerModule> modules;

  const ServerStatus({
    required this.serverName,
    required this.connectionMode,
    required this.serverAddress,
    required this.lastChecked,
    required this.modules,
  });

  int get readyModuleCount {
    return modules.where((module) => module.isReady).length;
  }

  int get totalModuleCount => modules.length;

  double get readinessPercent {
    if (modules.isEmpty) {
      return 0;
    }

    return readyModuleCount / modules.length;
  }

  String get readinessLabel {
    return '$readyModuleCount of $totalModuleCount modules ready';
  }

  bool get hasAttentionItems {
    return modules.any((module) => module.needsAttention);
  }

  ServerModule moduleByType(ServerModuleType type) {
    return modules.firstWhere((module) => module.type == type);
  }
}
