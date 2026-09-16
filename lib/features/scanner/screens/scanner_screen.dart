import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../../organizer/providers/organizer_provider.dart';
import '../models/scan_result_model.dart';
import '../services/scanner_api_service.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  late final MobileScannerController _scannerController;
  bool _isProcessing = false;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final code = barcode.rawValue;
      if (code != null && code.isNotEmpty) {
        _processCheckIn(code);
        break;
      }
    }
  }

  Future<void> _processCheckIn(String code) async {
    setState(() => _isProcessing = true);
    await _scannerController.stop();

    try {
      final user = ref.read(authStateProvider).user;
      final myEvents = ref.read(organizerProvider).events;

      final result = await ref.read(scannerApiServiceProvider).checkIn(code);

      // Panitia Ownership Validation Check (Only for Organizer, not Admin)
      final userRole = user?.role.toLowerCase() ?? '';
      if (userRole == 'organizer') {
        final isMyEvent = myEvents.any((e) =>
            (result.eventId != null && result.eventId! > 0 && e.id == result.eventId) ||
            (result.eventTitle != null &&
                result.eventTitle!.isNotEmpty &&
                e.title.toLowerCase().trim() == result.eventTitle!.toLowerCase().trim()));

        // Only block if we actually have eventId or eventTitle to compare and it definitely doesn't match
        final hasEventInfo = (result.eventId != null && result.eventId! > 0) ||
            (result.eventTitle != null && result.eventTitle!.isNotEmpty);

        if (hasEventInfo && !isMyEvent && myEvents.isNotEmpty) {
          if (mounted) {
            _showResultDialog(
              ScanResultModel(
                status: ScanStatus.invalid,
                message: 'AKSES DITOLAK: Anda bukan panitia dari event "${result.eventTitle ?? 'ini'}"!',
                ticketCode: code,
                eventTitle: result.eventTitle,
                attendeeName: result.attendeeName,
              ),
            );
          }
          return;
        }
      }

      if (mounted) {
        _showResultDialog(result);
      }
    } catch (e) {
      if (mounted) {
        _showResultDialog(
          ScanResultModel(
            status: ScanStatus.invalid,
            message: e.toString(),
            ticketCode: code,
          ),
        );
      }
    }
  }

  void _showResultDialog(ScanResultModel result) {
    Color headerBg = AppColors.mint;
    IconData icon = LucideIcons.checkCircle2;
    String title = 'CHECK-IN SUKSES!';

    if (result.isDuplicate) {
      headerBg = AppColors.orange;
      icon = LucideIcons.alertTriangle;
      title = 'SUDAH CHECK-IN!';
    } else if (result.isInvalid) {
      headerBg = AppColors.pink;
      icon = LucideIcons.xCircle;
      title = 'KODE TIDAK VALID!';
    }

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.textBorder, width: 3.5),
          boxShadow: const [
            BoxShadow(
              color: AppColors.textBorder,
              offset: Offset(0, -6),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Big Status Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: headerBg,
                border: Border.all(color: AppColors.textBorder, width: 2),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 28, color: AppColors.textBorder),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textBorder,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          result.message,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBorder,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Ticket Details Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.textBorder, width: 2),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'KODE TIKET',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        result.ticketCode,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textBorder,
                        ),
                      ),
                    ],
                  ),
                  if (result.attendeeName != null) ...[
                    const Divider(color: AppColors.divider, thickness: 1, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PENGUNJUNG',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          result.attendeeName!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textBorder,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (result.tierName != null) ...[
                    const Divider(color: AppColors.divider, thickness: 1, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TIER TIKET',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          result.tierName!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textBorder,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (result.checkInTime != null) ...[
                    const Divider(color: AppColors.divider, thickness: 1, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'WAKTU CHECK-IN',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          Formatters.formatTime(result.checkInTime),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBorder,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Big CTA to Resume Scanning
            NeoButton(
              text: 'PINDAI TIKET BERIKUTNYA',
              icon: LucideIcons.scanLine,
              backgroundColor: AppColors.yellow,
              height: 48,
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _isProcessing = false);
                _scannerController.start();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showManualInputDialog() {
    final manualCodeCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: AppColors.textBorder, width: 3),
        ),
        title: Row(
          children: [
            const Icon(LucideIcons.keyboard, color: AppColors.textBorder),
            const SizedBox(width: 8),
            Text(
              'INPUT MANUAL TIKET',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.textBorder,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NeoFormLabel('MASUKKAN KODE TIKET'),
            NeoTextField(
              controller: manualCodeCtrl,
              hint: 'Contoh: EVT-992384-01',
              prefixIcon: const Icon(LucideIcons.ticket, size: 18, color: AppColors.textBorder),
            ),
          ],
        ),
        actions: [
          NeoOutlineButton(
            text: 'BATAL',
            onPressed: () => Navigator.pop(ctx),
          ),
          NeoButton(
            text: 'CHECK-IN',
            backgroundColor: AppColors.mint,
            height: 38,
            fontSize: 11,
            fullWidth: false,
            onPressed: () {
              final code = manualCodeCtrl.text.trim();
              if (code.isNotEmpty) {
                Navigator.pop(ctx);
                _processCheckIn(code);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'SCANNER GATE',
        actions: [
          NeoIconButton(
            icon: _isTorchOn ? LucideIcons.flashlight : LucideIcons.flashlightOff,
            backgroundColor: _isTorchOn ? AppColors.yellow : Colors.white,
            size: 38,
            iconSize: 18,
            tooltip: 'Senter',
            onPressed: () {
              _scannerController.toggleTorch();
              setState(() => _isTorchOn = !_isTorchOn);
            },
          ),
          const SizedBox(width: 6),
          NeoIconButton(
            icon: LucideIcons.camera,
            backgroundColor: AppColors.mint,
            size: 38,
            iconSize: 18,
            tooltip: 'Ganti Kamera',
            onPressed: () => _scannerController.switchCamera(),
          ),
          const SizedBox(width: 6),
          NeoIconButton(
            icon: LucideIcons.keyboard,
            backgroundColor: AppColors.orange,
            size: 38,
            iconSize: 18,
            tooltip: 'Input Manual',
            onPressed: _showManualInputDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera Preview
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: NeoCard(
                    backgroundColor: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.cameraOff, size: 40, color: AppColors.textBorder),
                        const SizedBox(height: 12),
                        Text(
                          'AKSES KAMERA DITOLAK',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textBorder,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Izinkan izin kamera pada pengaturan perangkat Anda untuk menggunakan scanner barcode.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        NeoButton(
                          text: 'INPUT KODE MANUAL',
                          icon: LucideIcons.keyboard,
                          backgroundColor: AppColors.yellow,
                          onPressed: _showManualInputDialog,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Custom Neobrutalism Viewfinder Overlay
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: AppColors.yellow, width: 4),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.textBorder, width: 3),
                          left: BorderSide(color: AppColors.textBorder, width: 3),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.textBorder, width: 3),
                          right: BorderSide(color: AppColors.textBorder, width: 3),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.textBorder, width: 3),
                          left: BorderSide(color: AppColors.textBorder, width: 3),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.textBorder, width: 3),
                          right: BorderSide(color: AppColors.textBorder, width: 3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Instruction Bottom Banner
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: NeoCard(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      border: Border.all(color: AppColors.textBorder, width: 1.5),
                    ),
                    child: const Icon(LucideIcons.qrCode, size: 18, color: AppColors.textBorder),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ARAHKAN KAMERA KE QR CODE TIKET',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textBorder,
                          ),
                        ),
                        Text(
                          'Sistem otomatis memverifikasi dan mencatat presensi',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
