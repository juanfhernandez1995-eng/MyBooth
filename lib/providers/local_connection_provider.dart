import 'package:flutter/foundation.dart';

import '../models/local_connection.dart';
import '../services/local_connection_service.dart';

class LocalConnectionProvider extends ChangeNotifier {
  final LocalConnectionService _service;

  LocalConnection? _connection;
  bool _isLoading = false;

  LocalConnectionProvider([
    this._service = const LocalConnectionService(),
  ]);

  LocalConnection? get connection => _connection;
  bool get isLoading => _isLoading;

  Future<void> loadConnection() async {
    _isLoading = true;
    notifyListeners();

    _connection = await _service.loadConnection();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateSettings({
    required String serverIp,
    required int serverPort,
  }) async {
    _isLoading = true;
    notifyListeners();

    _connection = await _service.saveConnection(
      serverIp: serverIp,
      serverPort: serverPort,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> applyPreset(LocalConnectionPreset preset) async {
    await updateSettings(
      serverIp: preset.serverIp,
      serverPort: preset.serverPort,
    );
  }

  Future<void> useLocalhostDefaults() async {
    await applyPreset(LocalConnection.laptopTestPreset);
  }

  Future<void> useBoothNetworkDefaults() async {
    await applyPreset(LocalConnection.boothRouterPreset);
  }


  Future<void> useLastSuccessfulServerAddress() async {
    final currentConnection = _connection ?? LocalConnection.defaultConnection();

    _isLoading = true;
    notifyListeners();

    _connection = await _service.useLastSuccessfulServerAddress(currentConnection);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> testConnection() async {
    final currentConnection = _connection ?? LocalConnection.defaultConnection();

    _connection = currentConnection.copyWith(
      state: LocalConnectionState.checking,
      message: 'Pairing with the laptop MyBooth Server...',
      clearServerMetadata: true,
      clearLastError: true,
    );
    notifyListeners();

    _connection = await _service.runServerHandshake(_connection!);
    notifyListeners();
  }

  Future<void> runMockFallback() async {
    final currentConnection = _connection ?? LocalConnection.defaultConnection();

    _connection = currentConnection.copyWith(
      state: LocalConnectionState.checking,
      message: 'Running mock fallback handshake...',
      clearServerMetadata: true,
      clearLastError: true,
    );
    notifyListeners();

    _connection = await _service.runMockHandshake(_connection!);
    notifyListeners();
  }
}
