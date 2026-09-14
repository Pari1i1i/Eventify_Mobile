import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../../orders/models/order_model.dart';
import '../providers/admin_provider.dart';

class AdminOrdersScreen extends ConsumerStatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends ConsumerState<AdminOrdersScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _selectedStatus = 'Semua';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showOrderDetailModal(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.textBorder, width: 3),
          boxShadow: const [
            BoxShadow(color: AppColors.textBorder, offset: Offset(0, -4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DETAIL TRANSAKSI',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textBorder,
                  ),
                ),
                NeoIconButton(
                  icon: LucideIcons.x,
                  size: 32,
                  iconSize: 16,
                  backgroundColor: AppColors.pink,
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 14),
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
                      Text('KODE ORDER', style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                      Text(order.orderCode, style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const Divider(color: AppColors.divider, thickness: 1, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('STATUS', style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                      NeoBadge(label: order.status.toUpperCase(), backgroundColor: order.isPaid ? AppColors.mint : AppColors.orange, textColor: AppColors.textBorder),
                    ],
                  ),
                  const Divider(color: AppColors.divider, thickness: 1, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TOTAL AMOUNT', style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                      Text(Formatters.formatCurrency(order.totalAmount), style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.magenta)),
                    ],
                  ),
                  if (order.eventTitle != null) ...[
                    const Divider(color: AppColors.divider, thickness: 1, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('EVENT', style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                        Expanded(child: Text(order.eventTitle!, textAlign: TextAlign.right, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700))),
                      ],
                    ),
                  ],
                  if (order.paymentMethod != null) ...[
                    const Divider(color: AppColors.divider, thickness: 1, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('METODE', style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                        Text(order.paymentMethod!, style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                  const Divider(color: AppColors.divider, thickness: 1, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('WAKTU TRANSAKSI', style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                      Text(Formatters.formatDateTime(order.createdAt), style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            NeoButton(
              text: 'TUTUP',
              backgroundColor: AppColors.yellow,
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(adminOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'MONITOR ORDER',
        showBackButton: true,
        actions: [
          NeoIconButton(
            icon: LucideIcons.refreshCw,
            backgroundColor: AppColors.mint,
            size: 38,
            iconSize: 18,
            onPressed: () => ref.refresh(adminOrdersProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: NeoCard(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  NeoTextField(
                    controller: _searchCtrl,
                    hint: 'Cari kode order...',
                    prefixIcon: const Icon(LucideIcons.search, size: 18, color: AppColors.textBorder),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Semua', 'Paid', 'Pending', 'Cancelled'].map((st) {
                        final isSel = _selectedStatus.toLowerCase() == st.toLowerCase();
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedStatus = st),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: isSel ? AppColors.textBorder : Colors.white,
                                border: Border.all(color: AppColors.textBorder, width: 1.5),
                              ),
                              child: Text(
                                st.toUpperCase(),
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: isSel ? Colors.white : AppColors.textBorder,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Orders List
          Expanded(
            child: ordersAsync.when(
              loading: () => const NeoLoadingIndicator(text: 'Memuat semua transaksi order...'),
              error: (err, _) => NeoErrorState(
                message: err.toString(),
                onRetry: () => ref.refresh(adminOrdersProvider),
              ),
              data: (orders) {
                final filtered = orders.where((o) {
                  final matchesSearch = _searchCtrl.text.isEmpty ||
                      o.orderCode.toLowerCase().contains(_searchCtrl.text.toLowerCase());
                  final matchesStatus = _selectedStatus == 'Semua' ||
                      o.status.toLowerCase() == _selectedStatus.toLowerCase();
                  return matchesSearch && matchesStatus;
                }).toList();

                if (filtered.isEmpty) {
                  return const NeoEmptyState(
                    title: 'TIDAK ADA ORDER',
                    message: 'Tidak ditemukan transaksi sesuai kriteria.',
                  );
                }

                return RefreshIndicator(
                  color: AppColors.textBorder,
                  backgroundColor: AppColors.yellow,
                  onRefresh: () async {
                    ref.invalidate(adminOrdersProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final order = filtered[index];
                      Color statusBg = AppColors.mint;
                      if (order.isPending) statusBg = AppColors.orange;
                      if (order.isCancelled || order.isExpired) statusBg = AppColors.pink;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.textBorder, width: 2),
                          boxShadow: const [
                            BoxShadow(color: AppColors.textBorder, offset: Offset(2.5, 2.5)),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => _showOrderDetailModal(order),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.orderCode,
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textBorder,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    Formatters.formatDateTime(order.createdAt),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    Formatters.formatCurrency(order.totalAmount),
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.magenta,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  NeoBadge(
                                    label: order.status.toUpperCase(),
                                    backgroundColor: statusBg,
                                    textColor: AppColors.textBorder,
                                    hasBorder: true,
                                  ),
                                  const SizedBox(height: 8),
                                  const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textBorder),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
