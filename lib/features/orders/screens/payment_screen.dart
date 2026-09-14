import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../models/order_model.dart';
import '../services/order_api_service.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String orderCode;
  final OrderModel? initialOrder;

  const PaymentScreen({
    super.key,
    required this.orderCode,
    this.initialOrder,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  Timer? _pollingTimer;
  OrderModel? _currentOrder;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.initialOrder;
    _fetchOrderStatus();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_currentOrder == null || !_currentOrder!.isPaid) {
        _fetchOrderStatus(silent: true);
      } else {
        _pollingTimer?.cancel();
      }
    });
  }

  Future<void> _fetchOrderStatus({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);

    try {
      final order = await ref.read(orderApiServiceProvider).getOrderByCode(widget.orderCode);
      if (mounted) {
        setState(() {
          _currentOrder = order;
          _isLoading = false;
        });

        if (order.isPaid) {
          _pollingTimer?.cancel();
        }
      }
    } catch (_) {
      if (mounted && !silent) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    showNeoSnackBar(context, '$label berhasil disalin ke clipboard!', isSuccess: true);
  }

  @override
  Widget build(BuildContext context) {
    final order = _currentOrder;

    if (order == null && _isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: NeoAppBar(title: 'EVENTIFY', subtitleTag: 'PEMBAYARAN', showBackButton: true),
        body: NeoLoadingIndicator(text: 'Memuat data pembayaran...'),
      );
    }

    if (order == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const NeoAppBar(title: 'EVENTIFY', subtitleTag: 'PEMBAYARAN', showBackButton: true),
        body: NeoErrorState(
          message: 'Gagal memuat informasi pesanan.',
          onRetry: () => _fetchOrderStatus(),
        ),
      );
    }

    if (order.isPaid) {
      // Payment Success View
      return Scaffold(
        backgroundColor: AppColors.mint,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: NeoCard(
                backgroundColor: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.mint,
                        border: Border.all(color: AppColors.textBorder, width: 3),
                        boxShadow: const [
                          BoxShadow(color: AppColors.textBorder, offset: Offset(4, 4)),
                        ],
                      ),
                      child: const Icon(LucideIcons.checkCircle2, size: 40, color: AppColors.textBorder),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'PEMBAYARAN SUKSES!',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textBorder,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tiket Anda telah terbit dan siap digunakan untuk check-in event.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        border: Border.all(color: AppColors.textBorder, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'KODE PESANAN',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textBorder,
                            ),
                          ),
                          Text(
                            order.orderCode,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textBorder,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    NeoButton(
                      text: 'LIHAT TIKET SAYA',
                      icon: LucideIcons.ticket,
                      backgroundColor: AppColors.yellow,
                      onPressed: () => context.go('/tickets'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Pending Payment Instructions View
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'PEMBAYARAN',
        showBackButton: true,
        actions: [
          NeoIconButton(
            icon: LucideIcons.refreshCw,
            backgroundColor: AppColors.yellow,
            size: 38,
            iconSize: 18,
            onPressed: () => _fetchOrderStatus(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Banner (Polling indicator)
            NeoCard(
              backgroundColor: AppColors.orange,
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.textBorder),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MENUNGGU PEMBAYARAN',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textBorder,
                          ),
                        ),
                        Text(
                          'Halaman akan update otomatis setelah pembayaran diterima.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order Code & Total Amount
            NeoCard(
              backgroundColor: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'KODE PESANAN',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _copyToClipboard(order.orderCode, 'Kode Pesanan'),
                        child: Row(
                          children: [
                            Text(
                              order.orderCode,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textBorder,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(LucideIcons.copy, size: 14, color: AppColors.textBorder),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.divider, thickness: 1.5, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL HARGA',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textBorder,
                        ),
                      ),
                      Text(
                        Formatters.formatCurrency(order.totalAmount),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.magenta,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Payment Instructions (QRIS / VA)
            NeoCard(
              backgroundColor: Colors.white,
              child: Column(
                children: [
                  Text(
                    'INSTRUKSI PEMBAYARAN',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textBorder,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // QRIS Code display
                  if (order.paymentMethod?.toUpperCase().contains('QRIS') ?? true) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.textBorder, width: 2.5),
                        boxShadow: const [
                          BoxShadow(color: AppColors.textBorder, offset: Offset(3, 3)),
                        ],
                      ),
                      child: QrImageView(
                        data: order.qrCodeUrl ?? 'EVENTIFY-${order.orderCode}-${order.totalAmount}',
                        version: QrVersions.auto,
                        size: 200.0,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: AppColors.textBorder,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: AppColors.textBorder,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pindai QRIS menggunakan aplikasi E-Wallet atau Mobile Banking Anda',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ] else ...[
                    // Virtual Account Number Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.toska,
                        border: Border.all(color: AppColors.textBorder, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            order.paymentMethod ?? 'VIRTUAL ACCOUNT',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textBorder,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                order.vaNumber ?? '880192837461928',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textBorder,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(LucideIcons.copy, size: 18, color: AppColors.textBorder),
                                onPressed: () => _copyToClipboard(
                                  order.vaNumber ?? '880192837461928',
                                  'Nomor Virtual Account',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            NeoButton(
              text: 'CEK STATUS PEMBAYARAN',
              icon: LucideIcons.refreshCw,
              backgroundColor: AppColors.yellow,
              isLoading: _isLoading,
              onPressed: () => _fetchOrderStatus(),
            ),
            const SizedBox(height: 10),
            NeoOutlineButton(
              text: 'KEMBALI KE BERANDA',
              icon: LucideIcons.home,
              fullWidth: true,
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }
}
