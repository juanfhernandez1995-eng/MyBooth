import '../models/server_module.dart';
import '../models/server_status.dart';

class ServerStatusService {
  const ServerStatusService();

  Future<ServerStatus> loadStatus() async {
    return ServerStatus(
      serverName: 'MyBooth Server',
      connectionMode: 'Private Wi-Fi + real server handshake foundation',
      serverAddress: 'Default server endpoint: http://192.168.4.1:8080',
      lastChecked: DateTime.now(),
      modules: const [
        ServerModule(
          type: ServerModuleType.myBoothServer,
          title: 'MyBooth Server',
          description: 'Gaming laptop that will control booth hardware, AI tools, gallery storage, and event data.',
          status: ServerModuleStatus.ready,
          statusLabel: 'Foundation ready',
          detail: 'Flutter client has a server status model and provider ready for future API wiring.',
        ),
        ServerModule(
          type: ServerModuleType.tabletClient,
          title: 'Android Tablet Client',
          description: 'Vertical operator/customer interface connected to the laptop over private Wi-Fi.',
          status: ServerModuleStatus.ready,
          statusLabel: 'Client UI ready',
          detail: 'Tablet workflow is represented in the app architecture; real server handshake is available in Local Connection.',
        ),
        ServerModule(
          type: ServerModuleType.privateNetwork,
          title: 'Private Wi-Fi Network',
          description: 'Local booth network that keeps tablet-to-laptop communication isolated from venue internet.',
          status: ServerModuleStatus.attention,
          statusLabel: 'Connection foundation',
          detail: 'Server IP and port settings can now test the real laptop /health and /status API.',
        ),
        ServerModule(
          type: ServerModuleType.camera,
          title: 'Canon EOS R50',
          description: 'Camera capture module controlled by the MyBooth Server laptop.',
          status: ServerModuleStatus.planned,
          statusLabel: 'Integration planned',
          detail: 'This release only creates the module boundary; camera control is not connected yet.',
        ),
        ServerModule(
          type: ServerModuleType.printer,
          title: 'DNP DS-RX1HS',
          description: 'Photo print module and queue controlled by the MyBooth Server laptop.',
          status: ServerModuleStatus.planned,
          statusLabel: 'Integration planned',
          detail: 'Printer queue, print counts, and job status will be wired in a later release.',
        ),
        ServerModule(
          type: ServerModuleType.aiEngine,
          title: 'AI Background Engine',
          description: 'Local or connected AI workflow for background replacement and booth effects.',
          status: ServerModuleStatus.planned,
          statusLabel: 'Integration planned',
          detail: 'The architecture now has a dedicated AI module placeholder.',
        ),
        ServerModule(
          type: ServerModuleType.galleryStorage,
          title: 'Local Gallery Storage',
          description: 'Event photos, QR galleries, generated assets, and customer delivery data.',
          status: ServerModuleStatus.ready,
          statusLabel: 'Storage foundation',
          detail: 'Event storage exists locally; photo/gallery asset storage comes in a future release.',
        ),
      ],
    );
  }
}
