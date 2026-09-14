import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../../events/models/event_model.dart';
import '../../events/models/ticket_tier_model.dart';
import '../services/order_api_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final EventModel event;
  final List<Map<String, dynamic>> selectedTiers; // [{'tier': TicketTierModel, 'quantity': int}]
  final num totalAmount;

  const CheckoutScreen({
    super.key,
    required this.event,
    required this.selectedTiers,
    required this.totalAmount,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  String _selectedPaymentMethod = 'QRIS';
  bool _isLoading = false;

  final List<Map<String, String>> _paymentOptions = [
    {'id': 'QRIS', 'name': 'QRIS (Gopay / OVO / Dana / ShopeePay / All Bank)', 'desc': 'Scan QRIS nasional resmi untuk semua aplikasi E-Wallet & M-Banking'},
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleCheckout() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final items = widget.selectedTiers.map((item) {
        final tier = item['tier'] as TicketTierModel;
        final qty = item['quantity'] as int;
        return {
          'ticket_tier_id': tier.id,
          'quantity': qty,
        };
      }).toList();

      final orderApi = ref.read(orderApiServiceProvider);
      final createdOrder = await orderApi.createOrder(
        eventId: widget.event.id,
        items: items,
        attendeeName: _nameController.text.trim(),
        attendeeEmail: _emailController.text.trim(),
        attendeePhone: _phoneController.text.trim(),
        paymentMethod: widget.totalAmount > 0 ? _selectedPaymentMethod : 'FREE',
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (createdOrder.isPaid || widget.totalAmount == 0) {
        showNeoSnackBar(context, 'Pemesanan tiket berhasil!', isSuccess: true);
        context.go('/tickets');
      } else {
        showNeoSnackBar(context, 'Pesanan dibuat. Silakan selesaikan pembayaran.', isSuccess: true);
        context.push('/payment/${createdOrder.orderCode}', extra: createdOrder);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showNeoSnackBar(context, e.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'CHECKOUT',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Recap
              NeoCard(
                backgroundColor: AppColors.yellow,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RINGKASAN EVENT',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textBorder,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.event.title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textBorder,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(LucideIcons.calendar, size: 14, color: AppColors.textBorder),
                        const SizedBox(width: 6),
                        Text(
                          Formatters.formatDateTime(widget.event.startTime),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBorder,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Selected Tickets Breakdown
              NeoCard(
                backgroundColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RINCIAN TIKET DIPILIH',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textBorder,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...widget.selectedTiers.map((item) {
                      final tier = item['tier'] as TicketTierModel;
                      final qty = item['quantity'] as int;
                      final subtotal = tier.price * qty;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${tier.name} ($qty x ${Formatters.formatCurrency(tier.price)})',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBorder,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              Formatters.formatCurrency(subtotal),
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textBorder,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(color: AppColors.divider, thickness: 1.5),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL TAGIHAN',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textBorder,
                          ),
                        ),
                        Text(
                          Formatters.formatCurrency(widget.totalAmount),
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: widget.totalAmount == 0 ? AppColors.purpleSeed : AppColors.magenta,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Attendee Info Form
              NeoCard(
                backgroundColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INFORMASI PENGUNJUNG / PESERTA',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textBorder,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const NeoFormLabel('NAMA LENGKAP PENERIMA TIKET', isRequired: true),
                    NeoTextField(
                      controller: _nameController,
                      hint: 'Nama Lengkap',
                      prefixIcon: const Icon(LucideIcons.user, size: 18, color: AppColors.textBorder),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    const NeoFormLabel('EMAIL UNTUK PENGIRIMAN E-TIKET', isRequired: true),
                    NeoTextField(
                      controller: _emailController,
                      hint: 'nama@email.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(LucideIcons.mail, size: 18, color: AppColors.textBorder),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Email wajib diisi';
                        if (!Formatters.isValidEmail(val)) return 'Format email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    const NeoFormLabel('NOMOR TELEPON / WA (OPSIONAL)'),
                    NeoTextField(
                      controller: _phoneController,
                      hint: '081234567890',
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(LucideIcons.phone, size: 18, color: AppColors.textBorder),
                    ),
                  ],
                ),
              ),

              // Payment Method Choice (only if paid)
              if (widget.totalAmount > 0) ...[
                const SizedBox(height: 16),
                Text(
                  'METODE PEMBAYARAN',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textBorder,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                ..._paymentOptions.map((opt) {
                  final isSelected = _selectedPaymentMethod == opt['id'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPaymentMethod = opt['id']!),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.toska : Colors.white,
                        border: Border.all(
                          color: AppColors.textBorder,
                          width: isSelected ? 2.5 : 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textBorder,
                            offset: isSelected ? const Offset(3, 3) : const Offset(1.5, 1.5),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? LucideIcons.checkCircle2 : LucideIcons.circle,
                            size: 20,
                            color: isSelected ? AppColors.textBorder : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  opt['name']!,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textBorder,
                                  ),
                                ),
                                Text(
                                  opt['desc']!,
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
                  );
                }),
              ],
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.textBorder, width: 3)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL BAYAR',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      Formatters.formatCurrency(widget.totalAmount),
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: widget.totalAmount == 0 ? AppColors.purpleSeed : AppColors.magenta,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              NeoButton(
                text: widget.totalAmount == 0 ? 'DAPATKAN TIKET' : 'BAYAR SEKARANG',
                icon: widget.totalAmount == 0 ? LucideIcons.ticket : LucideIcons.creditCard,
                backgroundColor: AppColors.yellow,
                height: 46,
                fontSize: 12,
                fullWidth: false,
                isLoading: _isLoading,
                onPressed: _handleCheckout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
