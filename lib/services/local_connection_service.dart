import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/local_connection.dart';

class LocalConnectionService {
  static const String _serverIpKey = 'mybooth_server_ip';
  static const String _serverPortKey = 'mybooth_server_port';
  static const String _lastSuccessfulServerIpKey = 'mybooth_last_successful_server_ip';
  static const String _lastSuccessfulServerPortKey = 'mybooth_last_successful_server_port';
  static const Duration _requestTimeout = Duration(seconds: 3);

  const LocalConnectionService();

  Future<LocalConnection> loadConnection() async {
    final preferences = await SharedPreferences.getInstance();
    final defaultConnection = LocalConnection.defaultConnection();

    final serverIp = preferences.getString(_serverIpKey) ?? defaultConnection.serverIp;
    final serverPort = preferences.getInt(_serverPortKey) ?? defaultConnection.serverPort;
    final lastSuccessfulServerIp = preferences.getString(_lastSuccessfulServerIpKey);
    final lastSuccessfulServerPort = preferences.getInt(_lastSuccessfulServerPortKey);

    return LocalConnection(
      serverIp: serverIp,
      serverPort: serverPort,
      state: serverIp.trim().isEmpty ? LocalConnectionState.notConfigured : LocalConnectionState.configured,
      message: serverIp.trim().isEmpty
          ? 'Enter the laptop server IP address before pairing.'
          : 'Server address saved. Use the laptop IPv4 address from ipconfig, then run Pair with Server.',
      lastSuccessfulServerIp: lastSuccessfulServerIp,
      lastSuccessfulServerPort: lastSuccessfulServerPort,
    );
  }

  Future<LocalConnection> saveConnection({
    required String serverIp,
    required int serverPort,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final trimmedIp = serverIp.trim();
    final lastSuccessfulServerIp = preferences.getString(_lastSuccessfulServerIpKey);
    final lastSuccessfulServerPort = preferences.getInt(_lastSuccessfulServerPortKey);

    await preferences.setString(_serverIpKey, trimmedIp);
    await preferences.setInt(_serverPortKey, serverPort);

    return LocalConnection(
      serverIp: trimmedIp,
      serverPort: serverPort,
      state: trimmedIp.isEmpty ? LocalConnectionState.notConfigured : LocalConnectionState.configured,
      message: trimmedIp.isEmpty
          ? 'Server address cleared. Enter the laptop IP address before pairing.'
          : 'Connection settings saved. Run Pair with Server to confirm the route.',
      lastError: null,
      lastSuccessfulServerIp: lastSuccessfulServerIp,
      lastSuccessfulServerPort: lastSuccessfulServerPort,
    );
  }

  Future<LocalConnection> useLastSuccessfulServerAddress(LocalConnection connection) async {
    if (!connection.hasLastSuccessfulServerAddress) {
      return connection.copyWith(
        state: LocalConnectionState.failed,
        message: 'No successful server address has been saved yet. Pair with the laptop server once first.',
        lastChecked: DateTime.now(),
        lastError: 'Missing last successful server address.',
        clearServerMetadata: true,
      );
    }

    return saveConnection(
      serverIp: connection.lastSuccessfulServerIp!,
      serverPort: connection.lastSuccessfulServerPort!,
    );
  }

  Future<LocalConnection> runServerHandshake(LocalConnection connection) async {
    if (!connection.isConfigured) {
      return connection.copyWith(
        state: LocalConnectionState.failed,
        message: 'Server IP and port are required before the tablet can pair with the laptop.',
        lastChecked: DateTime.now(),
        lastError: 'Missing server IP or invalid port.',
        clearServerMetadata: true,
      );
    }

    final stopwatch = Stopwatch()..start();

    try {
      final healthPayload = await _getJson('${connection.endpoint}/health');
      final statusPayload = await _getJson('${connection.endpoint}/status');
      stopwatch.stop();

      final healthOk = healthPayload['ok'] == true;
      final statusOk = statusPayload['ok'] == true;

      if (!healthOk || !statusOk) {
        return connection.copyWith(
          state: LocalConnectionState.failed,
          message: 'Server responded, but its health/status payload did not confirm readiness.',
          lastChecked: DateTime.now(),
          responseTimeMs: stopwatch.elapsedMilliseconds,
          lastError: 'Unexpected /health or /status payload.',
          clearServerMetadata: true,
        );
      }

      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_lastSuccessfulServerIpKey, connection.serverIp);
      await preferences.setInt(_lastSuccessfulServerPortKey, connection.serverPort);

      final modules = statusPayload['modules'];

      return connection.copyWith(
        state: LocalConnectionState.connected,
        message: 'Paired with the laptop server. MyBooth saved this as the last successful server address.',
        lastChecked: DateTime.now(),
        serverName: _stringValue(statusPayload['serverName']) ?? _stringValue(healthPayload['server_name']) ?? 'MyBooth Server',
        serverVersion: _stringValue(statusPayload['version']) ?? _stringValue(healthPayload['version']),
        moduleCount: modules is List ? modules.length : null,
        responseTimeMs: stopwatch.elapsedMilliseconds,
        lastSuccessfulServerIp: connection.serverIp,
        lastSuccessfulServerPort: connection.serverPort,
        clearLastError: true,
      );
    } on TimeoutException {
      stopwatch.stop();
      return connection.copyWith(
        state: LocalConnectionState.failed,
        message: 'Pairing timed out. Confirm the laptop server is running and both devices are on the same Wi-Fi.',
        lastChecked: DateTime.now(),
        responseTimeMs: stopwatch.elapsedMilliseconds,
        lastError: 'Request timeout after ${_requestTimeout.inSeconds} seconds.',
        clearServerMetadata: true,
      );
    } on FormatException catch (error) {
      stopwatch.stop();
      return connection.copyWith(
        state: LocalConnectionState.failed,
        message: 'Server responded, but the response was not valid JSON.',
        lastChecked: DateTime.now(),
        responseTimeMs: stopwatch.elapsedMilliseconds,
        lastError: error.message,
        clearServerMetadata: true,
      );
    } on Object catch (error) {
      stopwatch.stop();
      return connection.copyWith(
        state: LocalConnectionState.failed,
        message: 'Could not reach the MyBooth Server. Check the IP address, port, Wi-Fi, and Windows firewall.',
        lastChecked: DateTime.now(),
        responseTimeMs: stopwatch.elapsedMilliseconds,
        lastError: error.toString(),
        clearServerMetadata: true,
      );
    }
  }

  Future<LocalConnection> runMockHandshake(LocalConnection connection) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    if (!connection.isConfigured) {
      return connection.copyWith(
        state: LocalConnectionState.failed,
        message: 'Server IP and port are required before the tablet can connect.',
        lastChecked: DateTime.now(),
        lastError: 'Missing server IP or invalid port.',
        clearServerMetadata: true,
      );
    }

    return connection.copyWith(
      state: LocalConnectionState.connected,
      message: 'Mock fallback passed. Use real pairing when the laptop server is running.',
      lastChecked: DateTime.now(),
      serverName: 'Mock MyBooth Server',
      serverVersion: 'offline fallback',
      moduleCount: 0,
      responseTimeMs: 450,
      clearLastError: true,
    );
  }

  Future<Map<String, dynamic>> _getJson(String url) async {
    final response = await http.get(Uri.parse(url)).timeout(_requestTimeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('HTTP ${response.statusCode} from $url');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object response.');
    }

    return decoded;
  }

  String? _stringValue(Object? value) {
    if (value == null) {
      return null;
    }
    return value.toString();
  }
}
