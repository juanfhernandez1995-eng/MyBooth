import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/local_connection.dart';
import '../providers/local_connection_provider.dart';
import '../widgets/app_page.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_card.dart';

class LocalConnectionScreen extends StatefulWidget {
  const LocalConnectionScreen({super.key});

  @override
  State<LocalConnectionScreen> createState() => _LocalConnectionScreenState();
}

class _LocalConnectionScreenState extends State<LocalConnectionScreen> {
  final TextEditingController _serverIpController = TextEditingController();
  final TextEditingController _serverPortController = TextEditingController();
  bool _controllersInitialized = false;

  @override
  void dispose() {
    _serverIpController.dispose();
    _serverPortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocalConnectionProvider>();
    final connection = provider.connection ?? LocalConnection.defaultConnection();

    if (!_controllersInitialized) {
      _syncControllers(connection);
      _controllersInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Server Pairing')),
      body: AppPage(
        maxWidth: 920,
        child: ListView(
          children: [
            _ConnectionHero(
              connection: connection,
              onCopyEndpoint: () => _copyEndpoint(connection.endpoint),
            ),
            const SizedBox(height: 18),
            _RealWorldRouterCard(connection: connection),
            const SizedBox(height: 18),
            _PresetPickerCard(
              activeType: connection.activePresetType,
              isLoading: provider.isLoading || connection.isChecking,
              onPresetSelected: _applyPreset,
            ),
            const SizedBox(height: 18),
            _LastSuccessfulAddressCard(
              connection: connection,
              isLoading: provider.isLoading || connection.isChecking,
              onUseLastSuccessful: _useLastSuccessfulAddress,
              onCopyLastSuccessful: connection.hasLastSuccessfulServerAddress
                  ? () => _copyEndpoint(connection.lastSuccessfulEndpoint)
                  : null,
            ),
            const SizedBox(height: 18),
            _ConnectionSettingsCard(
              serverIpController: _serverIpController,
              serverPortController: _serverPortController,
              isLoading: provider.isLoading || connection.isChecking,
              onSave: _saveSettings,
              onRealHandshake: _pairWithServer,
              onMockFallback: _testMockFallback,
            ),
            const SizedBox(height: 18),
            _LaptopIpDiscoveryCard(connection: connection),
            const SizedBox(height: 18),
            _FieldTestChecklistCard(connection: connection),
            const SizedBox(height: 18),
            _TroubleshootingCard(connection: connection),
            const SizedBox(height: 18),
            const _RouterSetupCard(),
            const SizedBox(height: 18),
            const _ApiContractCard(),
          ],
        ),
      ),
    );
  }

  void _syncControllers(LocalConnection connection) {
    _serverIpController.text = connection.serverIp;
    _serverPortController.text = connection.serverPort.toString();
  }

  int? _parsedPort() {
    final parsedPort = int.tryParse(_serverPortController.text.trim());
    if (parsedPort == null || parsedPort <= 0) {
      return null;
    }
    return parsedPort;
  }

  Future<void> _saveSettings() async {
    final provider = context.read<LocalConnectionProvider>();
    final parsedPort = _parsedPort();

    if (parsedPort == null) {
      _showMessage('Enter a valid server port.');
      return;
    }

    await provider.updateSettings(
      serverIp: _serverIpController.text,
      serverPort: parsedPort,
    );

    if (!mounted) {
      return;
    }

    _showMessage('Connection settings saved.');
  }

  Future<void> _pairWithServer() async {
    final provider = context.read<LocalConnectionProvider>();
    final parsedPort = _parsedPort();

    if (parsedPort == null) {
      _showMessage('Enter a valid server port before pairing.');
      return;
    }

    await provider.updateSettings(
      serverIp: _serverIpController.text,
      serverPort: parsedPort,
    );
    await provider.testConnection();

    if (!mounted) {
      return;
    }

    final connection = provider.connection;
    _showMessage(connection?.isConnected == true
        ? 'Server pairing passed. This address was saved.'
        : 'Server pairing needs attention.');
  }

  Future<void> _testMockFallback() async {
    final provider = context.read<LocalConnectionProvider>();
    await provider.runMockFallback();

    if (!mounted) {
      return;
    }

    _showMessage('Mock fallback complete.');
  }

  Future<void> _applyPreset(LocalConnectionPreset preset) async {
    final provider = context.read<LocalConnectionProvider>();
    await provider.applyPreset(preset);

    if (!mounted) {
      return;
    }

    final connection = provider.connection ?? LocalConnection.defaultConnection();
    _syncControllers(connection);
    _showMessage('${preset.name} preset applied.');
  }

  Future<void> _useLastSuccessfulAddress() async {
    final provider = context.read<LocalConnectionProvider>();
    await provider.useLastSuccessfulServerAddress();

    if (!mounted) {
      return;
    }

    final connection = provider.connection ?? LocalConnection.defaultConnection();
    _syncControllers(connection);
    _showMessage(
      connection.hasLastSuccessfulServerAddress
          ? 'Last successful server address loaded.'
          : 'No successful server address saved yet.',
    );
  }

  Future<void> _copyEndpoint(String endpoint) async {
    await Clipboard.setData(ClipboardData(text: endpoint));

    if (!mounted) {
      return;
    }

    _showMessage('Copied $endpoint');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _ConnectionHero extends StatelessWidget {
  final LocalConnection connection;
  final VoidCallback onCopyEndpoint;

  const _ConnectionHero({
    required this.connection,
    required this.onCopyEndpoint,
  });

  @override
  Widget build(BuildContext context) {
    final color = _stateColor(connection.state);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withValues(alpha: 0.12),
                child: Icon(Icons.hub, color: color, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Server Pairing',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(connection.pairingSummary),
                  ],
                ),
              ),
              _StatePill(label: connection.stateLabel, color: color),
            ],
          ),
          const SizedBox(height: 16),
          Text(connection.message),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _EndpointChip(
                icon: Icons.router,
                label: connection.activePresetLabel,
              ),
              _EndpointChip(
                icon: Icons.link,
                label: connection.endpoint,
                onTap: onCopyEndpoint,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _TipBox(
            icon: Icons.lightbulb,
            color: Theme.of(context).colorScheme.primary,
            title: 'Router pairing tip',
            detail: connection.routerPairingTip,
          ),
          if (connection.isConnected) ...[
            const SizedBox(height: 14),
            _ServerDiagnostics(connection: connection),
          ],
          if (connection.lastError != null && connection.lastError!.isNotEmpty) ...[
            const SizedBox(height: 14),
            _ErrorDetails(error: connection.lastError!),
          ],
          if (connection.lastChecked != null) ...[
            const SizedBox(height: 8),
            Text(
              'Last checked: ${_formatDateTime(connection.lastChecked!)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _RealWorldRouterCard extends StatelessWidget {
  final LocalConnection connection;

  const _RealWorldRouterCard({required this.connection});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Real Router Setup',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your AX1500 router may assign the laptop an address like 192.168.0.95, 10.0.0.68, or another local IP. The app should use the laptop Wi-Fi IPv4 address, not a guessed preset.',
          ),
          const SizedBox(height: 14),
          _MiniStatusGrid(
            items: [
              _MiniStatusItem('Current target', connection.endpoint),
              _MiniStatusItem('Last successful', connection.lastSuccessfulEndpoint),
              _MiniStatusItem('Port', connection.serverPort.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

class _LastSuccessfulAddressCard extends StatelessWidget {
  final LocalConnection connection;
  final bool isLoading;
  final VoidCallback onUseLastSuccessful;
  final VoidCallback? onCopyLastSuccessful;

  const _LastSuccessfulAddressCard({
    required this.connection,
    required this.isLoading,
    required this.onUseLastSuccessful,
    this.onCopyLastSuccessful,
  });

  @override
  Widget build(BuildContext context) {
    final hasSavedAddress = connection.hasLastSuccessfulServerAddress;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last Successful Server Address',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            hasSavedAddress
                ? 'MyBooth remembers the last laptop address that passed a real handshake.'
                : 'After the first successful router handshake, MyBooth will save that laptop address here.',
          ),
          const SizedBox(height: 12),
          _TipBox(
            icon: hasSavedAddress ? Icons.verified : Icons.info,
            color: hasSavedAddress ? Colors.green : Theme.of(context).colorScheme.primary,
            title: hasSavedAddress ? 'Saved address ready' : 'No address saved yet',
            detail: connection.lastSuccessfulEndpoint,
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final useButton = OutlinedButton.icon(
                onPressed: hasSavedAddress && !isLoading ? onUseLastSuccessful : null,
                icon: const Icon(Icons.history),
                label: const Text('Use Last Successful'),
              );
              final copyButton = OutlinedButton.icon(
                onPressed: hasSavedAddress && !isLoading ? onCopyLastSuccessful : null,
                icon: const Icon(Icons.copy),
                label: const Text('Copy Address'),
              );

              if (constraints.maxWidth < 560) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    useButton,
                    const SizedBox(height: 10),
                    copyButton,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: useButton),
                  const SizedBox(width: 12),
                  Expanded(child: copyButton),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ConnectionSettingsCard extends StatelessWidget {
  final TextEditingController serverIpController;
  final TextEditingController serverPortController;
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onRealHandshake;
  final VoidCallback onMockFallback;

  const _ConnectionSettingsCard({
    required this.serverIpController,
    required this.serverPortController,
    required this.isLoading,
    required this.onSave,
    required this.onRealHandshake,
    required this.onMockFallback,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Server Address',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Enter the laptop Wi-Fi IPv4 address from ipconfig. Keep the port at 8080 unless the server config changes.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: serverIpController,
            decoration: const InputDecoration(
              labelText: 'Laptop Server IP Address',
              hintText: 'Example: 192.168.0.95',
              prefixIcon: Icon(Icons.router),
            ),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: serverPortController,
            decoration: const InputDecoration(
              labelText: 'Server Port',
              hintText: '8080',
              prefixIcon: Icon(Icons.numbers),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final buttons = [
                OutlinedButton.icon(
                  onPressed: isLoading ? null : onSave,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Address'),
                ),
                PrimaryButton(
                  text: isLoading ? 'Pairing...' : 'Pair with Server',
                  icon: Icons.sync,
                  onPressed: isLoading ? null : onRealHandshake,
                ),
              ];

              if (constraints.maxWidth < 560) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buttons[0],
                    const SizedBox(height: 10),
                    buttons[1],
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: buttons[0]),
                  const SizedBox(width: 12),
                  Expanded(child: buttons[1]),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: isLoading ? null : onMockFallback,
              icon: const Icon(Icons.offline_bolt),
              label: const Text('Run mock fallback only'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetPickerCard extends StatelessWidget {
  final LocalConnectionPresetType activeType;
  final bool isLoading;
  final ValueChanged<LocalConnectionPreset> onPresetSelected;

  const _PresetPickerCard({
    required this.activeType,
    required this.isLoading,
    required this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connection Presets',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          const Text('Presets are starting points. For the real router, the laptop IP from ipconfig is the source of truth.'),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 680;
              final cards = LocalConnection.presets.map((preset) {
                return _PresetTile(
                  preset: preset,
                  selected: activeType == preset.type,
                  enabled: !isLoading,
                  onSelected: () => onPresetSelected(preset),
                );
              }).toList();

              if (isWide) {
                return Row(
                  children: [
                    for (final card in cards) ...[
                      Expanded(child: card),
                      if (card != cards.last) const SizedBox(width: 12),
                    ],
                  ],
                );
              }

              return Column(
                children: [
                  for (final card in cards) ...[
                    card,
                    if (card != cards.last) const SizedBox(height: 12),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PresetTile extends StatelessWidget {
  final LocalConnectionPreset preset;
  final bool selected;
  final bool enabled;
  final VoidCallback onSelected;

  const _PresetTile({
    required this.preset,
    required this.selected,
    required this.enabled,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Theme.of(context).colorScheme.primary : const Color(0xFF64748B);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: enabled ? onSelected : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? Theme.of(context).colorScheme.primary : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
          color: selected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.06) : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  preset.type == LocalConnectionPresetType.laptopTest ? Icons.computer : Icons.router,
                  color: color,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    preset.name,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                ),
                if (selected) Icon(Icons.check_circle, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(preset.description),
            const SizedBox(height: 8),
            Text(
              preset.endpoint,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldTestChecklistCard extends StatelessWidget {
  final LocalConnection connection;

  const _FieldTestChecklistCard({required this.connection});

  @override
  Widget build(BuildContext context) {
    final hasCustomAddress = connection.activePresetType == LocalConnectionPresetType.custom ||
        connection.isUsingLastSuccessfulAddress;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Router Field Test Checklist',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          const Text('Use this checklist when the laptop and tablet are on the AX1500 booth router.'),
          const SizedBox(height: 14),
          _FieldTestStep(
            number: '1',
            title: 'Connect laptop and tablet to the same router Wi-Fi',
            detail: 'Both devices must be on the MyBooth router network, not separate home/guest networks.',
            complete: connection.isConnected,
          ),
          _FieldTestStep(
            number: '2',
            title: 'Start the MyBooth Server on the laptop',
            detail: 'PowerShell: cd C:\\Users\\juanf\\Documents\\MyBooth\\server, then run py -m mybooth_server.',
            complete: connection.isConnected,
          ),
          _FieldTestStep(
            number: '3',
            title: 'Find the laptop Wi-Fi IPv4 address',
            detail: 'Run ipconfig. Use the IPv4 Address under Wireless LAN adapter Wi-Fi, such as 192.168.0.95.',
            complete: hasCustomAddress || connection.isConnected,
          ),
          _FieldTestStep(
            number: '4',
            title: 'Enter that IPv4 address here',
            detail: 'Do not use 0.0.0.0 or 127.0.0.1 from the tablet. Use the laptop router IP.',
            complete: connection.isConfigured,
          ),
          _FieldTestStep(
            number: '5',
            title: 'Run Pair with Server',
            detail: 'Successful pairing confirms /health and /status over the booth network.',
            complete: connection.isConnected,
          ),
        ],
      ),
    );
  }
}

class _LaptopIpDiscoveryCard extends StatelessWidget {
  final LocalConnection connection;

  const _LaptopIpDiscoveryCard({required this.connection});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find the Laptop Server IP',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          const _InfoBullet('On the laptop, open PowerShell and run ipconfig.'),
          const _InfoBullet('Look under Wireless LAN adapter Wi-Fi.'),
          const _InfoBullet('Copy the IPv4 Address. Example: 192.168.0.95 or 10.0.0.68.'),
          const _InfoBullet('Enter that IPv4 address above with port 8080.'),
          const _InfoBullet('The router preset is only a starter example. Your real IP may be different.'),
          const SizedBox(height: 12),
          _TipBox(
            icon: Icons.link,
            color: Theme.of(context).colorScheme.primary,
            title: 'Current target',
            detail: connection.endpoint,
          ),
        ],
      ),
    );
  }
}

class _TroubleshootingCard extends StatelessWidget {
  final LocalConnection connection;

  const _TroubleshootingCard({required this.connection});

  @override
  Widget build(BuildContext context) {
    final headline = connection.isConnected ? 'Pairing Confirmed' : 'Connection Troubleshooting';

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headline,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _TroubleshootingStep(
            icon: Icons.terminal,
            title: 'Start the laptop server',
            detail: 'Open PowerShell in MyBooth/server and run: py -m mybooth_server',
            complete: connection.isConnected,
          ),
          _TroubleshootingStep(
            icon: Icons.wifi,
            title: 'Use the same router Wi-Fi',
            detail: 'The tablet and laptop must be on the same AX1500 router network.',
            complete: connection.isConnected,
          ),
          _TroubleshootingStep(
            icon: Icons.security,
            title: 'Allow firewall ports',
            detail: 'Allow Python/private networks for port 8080. If testing Flutter from the tablet, also allow port 5000.',
            complete: false,
          ),
          _TroubleshootingStep(
            icon: Icons.travel_explore,
            title: 'Test the endpoint in a browser',
            detail: 'Open http://LAPTOP-IP:8080/health on the tablet. It should show JSON.',
            complete: connection.isConnected,
          ),
          _TroubleshootingStep(
            icon: Icons.block,
            title: 'Avoid special addresses on the tablet',
            detail: 'Do not use 127.0.0.1 or 0.0.0.0 on the tablet. Use the laptop IPv4 address.',
            complete: connection.isConnected,
          ),
        ],
      ),
    );
  }
}

class _RouterSetupCard extends StatelessWidget {
  const _RouterSetupCard();

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booth Router Setup Notes',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          _InfoBullet('Use the AX1500 as the private booth Wi-Fi for the laptop and Android tablet.'),
          _InfoBullet('The router can use your home Wi-Fi as a host network for internet during setup.'),
          _InfoBullet('The host network is only the router internet source. The laptop and tablet should connect to the router Wi-Fi.'),
          _InfoBullet('If the tablet cannot reach the laptop, turn off AP/client/guest isolation in the router settings.'),
          _InfoBullet('The working server address can change after router restart unless you reserve the laptop IP later.'),
        ],
      ),
    );
  }
}

class _ApiContractCard extends StatelessWidget {
  const _ApiContractCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Real Local API Contract',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          const Text('v0.21 improves the real router pairing flow. Hardware control is still intentionally planned for later releases.'),
          const SizedBox(height: 12),
          const _InfoBullet('GET /health — confirms server online and version'),
          const _InfoBullet('GET /status — reads module boundaries and server metadata'),
          const _InfoBullet('GET /pairing/router-field-plan — documents router pairing rules'),
          const _InfoBullet('Mock fallback — kept for demos when the server is offline'),
        ],
      ),
    );
  }
}

class _FieldTestStep extends StatelessWidget {
  final String number;
  final String title;
  final String detail;
  final bool complete;

  const _FieldTestStep({
    required this.number,
    required this.title,
    required this.detail,
    required this.complete,
  });

  @override
  Widget build(BuildContext context) {
    final color = complete ? Colors.green : Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color.withValues(alpha: 0.12),
            child: complete
                ? Icon(Icons.check, color: color, size: 17)
                : Text(number, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(detail),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TroubleshootingStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final bool complete;

  const _TroubleshootingStep({
    required this.icon,
    required this.title,
    required this.detail,
    required this.complete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(complete ? Icons.check_circle : icon, color: complete ? Colors.green : Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(detail),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBullet extends StatelessWidget {
  final String text;

  const _InfoBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _EndpointChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _EndpointChip({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Flexible(child: Text(label)),
          if (onTap != null) ...[
            const SizedBox(width: 8),
            const Icon(Icons.copy, size: 16),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return chip;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: chip,
    );
  }
}

class _ServerDiagnostics extends StatelessWidget {
  final LocalConnection connection;

  const _ServerDiagnostics({required this.connection});

  @override
  Widget build(BuildContext context) {
    return _TipBox(
      icon: Icons.verified,
      color: Colors.green,
      title: connection.serverSummary,
      detail: connection.diagnosticsSummary.isEmpty
          ? 'Confirmed with real /health and /status requests.'
          : '${connection.diagnosticsSummary} • Confirmed with real /health and /status requests.',
    );
  }
}

class _ErrorDetails extends StatelessWidget {
  final String error;

  const _ErrorDetails({required this.error});

  @override
  Widget build(BuildContext context) {
    return _TipBox(
      icon: Icons.error,
      color: Colors.red,
      title: 'Technical detail',
      detail: error,
    );
  }
}

class _StatePill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatePill({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _TipBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String detail;

  const _TipBox({
    required this.icon,
    required this.color,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(detail),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatusGrid extends StatelessWidget {
  final List<_MiniStatusItem> items;

  const _MiniStatusGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 640;

        if (!isWide) {
          return Column(
            children: [
              for (final item in items) ...[
                _MiniStatusTile(item: item),
                if (item != items.last) const SizedBox(height: 10),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (final item in items) ...[
              Expanded(child: _MiniStatusTile(item: item)),
              if (item != items.last) const SizedBox(width: 10),
            ],
          ],
        );
      },
    );
  }
}

class _MiniStatusItem {
  final String label;
  final String value;

  const _MiniStatusItem(this.label, this.value);
}

class _MiniStatusTile extends StatelessWidget {
  final _MiniStatusItem item;

  const _MiniStatusTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(
            item.value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

String _formatDateTime(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');

  return '${dateTime.month}/${dateTime.day}/${dateTime.year} $hour:$minute';
}

Color _stateColor(LocalConnectionState state) {
  switch (state) {
    case LocalConnectionState.notConfigured:
      return Colors.orange;
    case LocalConnectionState.configured:
      return Colors.blue;
    case LocalConnectionState.checking:
      return Colors.purple;
    case LocalConnectionState.connected:
      return Colors.green;
    case LocalConnectionState.failed:
      return Colors.red;
  }
}
