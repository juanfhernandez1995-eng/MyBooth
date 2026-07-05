import 'package:flutter/foundation.dart';

import '../models/server_status.dart';
import '../services/server_status_service.dart';

class ServerStatusProvider extends ChangeNotifier {
  final ServerStatusService _service;

  ServerStatus? _status;
  bool _isLoading = false;

  ServerStatusProvider({
    this._service = const ServerStatusService(),
  });

  ServerStatus? get status => _status;
  bool get isLoading => _isLoading;

  Future<void> loadStatus() async {
    _isLoading = true;
    notifyListeners();

    _status = await _service.loadStatus();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshStatus() async {
    await loadStatus();
  }
}
