import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/event.dart';
import '../widgets/app_page.dart';
import '../widgets/primary_button.dart';
import 'guest_gallery_screen.dart';

class BoothModeScreen extends StatefulWidget {
  final BoothEvent event;

  const BoothModeScreen({
    super.key,
    required this.event,
  });

  @override
  State<BoothModeScreen> createState() => _BoothModeScreenState();
}

class _BoothModeScreenState extends State<BoothModeScreen> {
  Timer? _timer;
  int _currentPhoto = 0;
  int _countdown = 0;
  int _selectedPrintCopies = 1;
  bool _skipPrint = false;
  _BoothStep _step = _BoothStep.ready;

  int get _totalPhotos => widget.event.photoLayout.toLowerCase().contains('4') ? 4 : 3;

  String get _layoutLabel {
    final layout = widget.event.photoLayout.trim();
    if (layout.isEmpty) {
      return widget.event.templateName.contains('4x6') ? '4x6 Photo Grid' : '2x6 Photo Strip';
    }
    return layout;
  }

  String get _guestGalleryUrl {
    final cleanId = widget.event.id.trim().isEmpty ? 'demo-session' : widget.event.id.trim();
    return 'http://192.168.4.1:8080/gallery/session/$cleanId';
  }

  @override
  void initState() {
    super.initState();
    _selectedPrintCopies = math.max(1, widget.event.printCopies);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSession() {
    _timer?.cancel();
    setState(() {
      _currentPhoto = 0;
      _step = _BoothStep.countdown;
      _countdown = widget.event.captureSettings.countdownSeconds;
      _selectedPrintCopies = math.max(1, widget.event.printCopies);
      _skipPrint = false;
    });
    _runCountdown();
  }

  void _runCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_countdown > 1) {
        setState(() => _countdown--);
        return;
      }

      timer.cancel();
      _capturePlaceholderPhoto();
    });
  }

  void _capturePlaceholderPhoto() {
    setState(() {
      _step = _BoothStep.captured;
      _currentPhoto++;
    });

    _timer = Timer(Duration(seconds: widget.event.captureSettings.delayBetweenPhotosSeconds), () {
      if (!mounted) {
        return;
      }

      if (_currentPhoto >= _totalPhotos) {
        _showProcessing();
      } else {
        setState(() {
          _step = _BoothStep.countdown;
          _countdown = widget.event.captureSettings.countdownSeconds;
        });
        _runCountdown();
      }
    });
  }

  void _showProcessing() {
    setState(() => _step = _BoothStep.processing);
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      setState(() => _step = _BoothStep.review);
    });
  }

  void _approveSession() {
    setState(() => _step = _BoothStep.readyForQr);
  }

  void _retakeLastPhoto() {
    _timer?.cancel();
    setState(() {
      _currentPhoto = math.max(0, _currentPhoto - 1);
      _step = _BoothStep.countdown;
      _countdown = widget.event.captureSettings.countdownSeconds;
    });
    _runCountdown();
  }

  void _setPrintCopies(int copies) {
    setState(() {
      _selectedPrintCopies = copies.clamp(1, 6).toInt();
      if (_skipPrint) {
        _skipPrint = false;
      }
    });
  }

  void _setSkipPrint(bool value) {
    setState(() => _skipPrint = value);
  }

  void _resetSession() {
    _timer?.cancel();
    setState(() {
      _currentPhoto = 0;
      _countdown = 0;
      _selectedPrintCopies = math.max(1, widget.event.printCopies);
      _skipPrint = false;
      _step = _BoothStep.ready;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FF),
      appBar: AppBar(
        title: const Text('Booth Mode'),
        actions: [
          TextButton.icon(
            onPressed: _resetSession,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset'),
          ),
        ],
      ),
      body: AppPage(
        maxWidth: 900,
        padding: const EdgeInsets.all(20),
        child: _buildCurrentStep(context),
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context) {
    switch (_step) {
      case _BoothStep.ready:
        return _ReadyStep(
          event: widget.event,
          layoutLabel: _layoutLabel,
          totalPhotos: _totalPhotos,
          onStart: _startSession,
        );
      case _BoothStep.countdown:
        return _CountdownStep(
          countdown: _countdown,
          photoNumber: _currentPhoto + 1,
          totalPhotos: _totalPhotos,
          showSmileMessage: widget.event.captureSettings.showSmileMessage,
        );
      case _BoothStep.captured:
        return _CapturedStep(
          photoNumber: _currentPhoto,
          totalPhotos: _totalPhotos,
        );
      case _BoothStep.processing:
        return _ProcessingStep(event: widget.event);
      case _BoothStep.review:
        return _ReviewStep(
          event: widget.event,
          layoutLabel: _layoutLabel,
          totalPhotos: _totalPhotos,
          selectedPrintCopies: _selectedPrintCopies,
          skipPrint: _skipPrint,
          onApprove: _approveSession,
          onRetakeLast: _retakeLastPhoto,
          onStartOver: _resetSession,
          onPrintCopiesChanged: _setPrintCopies,
          onSkipPrintChanged: _setSkipPrint,
        );
      case _BoothStep.readyForQr:
        return _QrResultStep(
          event: widget.event,
          layoutLabel: _layoutLabel,
          guestGalleryUrl: _guestGalleryUrl,
          selectedPrintCopies: _selectedPrintCopies,
          skipPrint: _skipPrint,
          onStartNext: _resetSession,
        );
    }
  }
}

enum _BoothStep {
  ready,
  countdown,
  captured,
  processing,
  review,
  readyForQr,
}

class _ReadyStep extends StatelessWidget {
  final BoothEvent event;
  final String layoutLabel;
  final int totalPhotos;
  final VoidCallback onStart;

  const _ReadyStep({
    required this.event,
    required this.layoutLabel,
    required this.totalPhotos,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return _BoothPanel(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_camera_front, size: 88, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 18),
          Text(
            event.displayName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            event.displayHonoree.isEmpty ? 'Get ready for your photo session.' : 'Celebrating ${event.displayHonoree}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 22),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip(icon: Icons.filter_frames, label: event.templateSummary),
              _InfoChip(icon: Icons.photo_size_select_actual, label: layoutLabel),
              _InfoChip(icon: Icons.timer, label: '$totalPhotos photos'),
            ],
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            text: 'Start Photo Session',
            icon: Icons.play_arrow,
            onPressed: onStart,
          ),
          const SizedBox(height: 12),
          const Text(
            'After capture, guests can approve, retake, choose print copies, then scan the final QR gallery.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CountdownStep extends StatelessWidget {
  final int countdown;
  final int photoNumber;
  final int totalPhotos;
  final bool showSmileMessage;

  const _CountdownStep({
    required this.countdown,
    required this.photoNumber,
    required this.totalPhotos,
    required this.showSmileMessage,
  });

  @override
  Widget build(BuildContext context) {
    return _BoothPanel(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Photo $photoNumber of $totalPhotos',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              countdown.toString(),
              key: ValueKey(countdown),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 132,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            showSmileMessage ? 'Smile!' : 'Get ready',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _CapturedStep extends StatelessWidget {
  final int photoNumber;
  final int totalPhotos;

  const _CapturedStep({
    required this.photoNumber,
    required this.totalPhotos,
  });

  @override
  Widget build(BuildContext context) {
    return _BoothPanel(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 96, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 18),
          Text(
            'Photo $photoNumber captured',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(photoNumber >= totalPhotos ? 'Building your review preview...' : 'Get ready for the next photo.'),
        ],
      ),
    );
  }
}

class _ProcessingStep extends StatelessWidget {
  final BoothEvent event;

  const _ProcessingStep({required this.event});

  @override
  Widget build(BuildContext context) {
    return _BoothPanel(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 74,
            height: 74,
            child: CircularProgressIndicator(strokeWidth: 7),
          ),
          const SizedBox(height: 24),
          Text(
            'Creating your review preview',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            event.greenScreenEnabled
                ? 'Preparing background, border, event text, and approval options.'
                : 'Preparing border, event text, print layout, and approval options.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ReviewStep extends StatelessWidget {
  final BoothEvent event;
  final String layoutLabel;
  final int totalPhotos;
  final int selectedPrintCopies;
  final bool skipPrint;
  final VoidCallback onApprove;
  final VoidCallback onRetakeLast;
  final VoidCallback onStartOver;
  final ValueChanged<int> onPrintCopiesChanged;
  final ValueChanged<bool> onSkipPrintChanged;

  const _ReviewStep({
    required this.event,
    required this.layoutLabel,
    required this.totalPhotos,
    required this.selectedPrintCopies,
    required this.skipPrint,
    required this.onApprove,
    required this.onRetakeLast,
    required this.onStartOver,
    required this.onPrintCopiesChanged,
    required this.onSkipPrintChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _BoothPanel(
          child: Column(
            children: [
              Icon(Icons.fact_check_rounded, size: 68, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                'Review your photos',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '$totalPhotos photos captured. Approve the final design, retake the last photo, or start over.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              _FinalPreviewCard(event: event, layoutLabel: layoutLabel),
              const SizedBox(height: 20),
              _PrintQuantityPanel(
                selectedPrintCopies: selectedPrintCopies,
                skipPrint: skipPrint,
                onPrintCopiesChanged: onPrintCopiesChanged,
                onSkipPrintChanged: onSkipPrintChanged,
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                text: skipPrint ? 'Approve + Show QR' : 'Approve + Queue Print',
                icon: Icons.check_circle,
                onPressed: onApprove,
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.replay_circle_filled),
                    label: const Text('Retake Last Photo'),
                    onPressed: onRetakeLast,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Start Over'),
                    onPressed: onStartOver,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrintQuantityPanel extends StatelessWidget {
  final int selectedPrintCopies;
  final bool skipPrint;
  final ValueChanged<int> onPrintCopiesChanged;
  final ValueChanged<bool> onSkipPrintChanged;

  const _PrintQuantityPanel({
    required this.selectedPrintCopies,
    required this.skipPrint,
    required this.onPrintCopiesChanged,
    required this.onSkipPrintChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.print_rounded, color: colorScheme.primary),
              const SizedBox(width: 10),
              Text(
                'Print options',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Material(
            color: Colors.transparent,
            child: SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: skipPrint,
              onChanged: onSkipPrintChanged,
              title: const Text('Skip printing for this session'),
              subtitle: const Text('The QR gallery will still be shown for final digital delivery.'),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: skipPrint ? 0.45 : 1,
            child: Row(
              children: [
                const Expanded(child: Text('Print copies')),
                IconButton.outlined(
                  tooltip: 'Decrease print copies',
                  onPressed: skipPrint || selectedPrintCopies <= 1 ? null : () => onPrintCopiesChanged(selectedPrintCopies - 1),
                  icon: const Icon(Icons.remove),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    '$selectedPrintCopies',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton.outlined(
                  tooltip: 'Increase print copies',
                  onPressed: skipPrint || selectedPrintCopies >= 6 ? null : () => onPrintCopiesChanged(selectedPrintCopies + 1),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrResultStep extends StatelessWidget {
  final BoothEvent event;
  final String layoutLabel;
  final String guestGalleryUrl;
  final int selectedPrintCopies;
  final bool skipPrint;
  final VoidCallback onStartNext;

  const _QrResultStep({
    required this.event,
    required this.layoutLabel,
    required this.guestGalleryUrl,
    required this.selectedPrintCopies,
    required this.skipPrint,
    required this.onStartNext,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _BoothPanel(
          child: Column(
            children: [
              Icon(Icons.celebration, size: 72, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                'Your photos are ready!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                skipPrint
                    ? 'Printing was skipped. Scan the QR code to open the final bordered guest gallery.'
                    : 'Print job queued for $selectedPrintCopies ${selectedPrintCopies == 1 ? 'copy' : 'copies'}. Scan the QR code for digital delivery.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              _FinalPreviewCard(event: event, layoutLabel: layoutLabel),
              const SizedBox(height: 22),
              _QrPlaceholder(url: guestGalleryUrl),
              const SizedBox(height: 22),
              PrimaryButton(
                text: 'Open Guest Gallery Preview',
                icon: Icons.photo_library,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GuestGalleryScreen(event: event),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.replay),
                label: const Text('Start Next Session'),
                onPressed: onStartNext,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FinalPreviewCard extends StatelessWidget {
  final BoothEvent event;
  final String layoutLabel;

  const _FinalPreviewCard({
    required this.event,
    required this.layoutLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.14),
            colorScheme.secondary.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.20)),
      ),
      child: Column(
        children: [
          Text(
            layoutLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.35), width: 3),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 56, color: colorScheme.primary),
                const SizedBox(height: 10),
                Text(
                  event.templateName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(event.displayHonoree.isEmpty ? event.displayName : event.displayHonoree),
                Text(event.displayDate),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Preview placeholder: the approved version becomes the final bordered gallery and print output.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _QrPlaceholder extends StatelessWidget {
  final String url;

  const _QrPlaceholder({required this.url});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 210,
          height: 210,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.qr_code_2, size: 162, color: Colors.black),
        ),
        const SizedBox(height: 10),
        SelectableText(
          url,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    );
  }
}

class _BoothPanel extends StatelessWidget {
  final Widget child;

  const _BoothPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 600),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );
  }
}
