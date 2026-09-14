import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/order_model.dart';
import '../providers/orders_provider.dart';

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersProvider.notifier).loadOrders();
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return AppColors.mint;
      case 'pending':
        return AppColors.orange;
      case 'cancelled':
      case 'expired':
        return AppColors.pink;
      default:
        return AppColors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final ordersState = ref.watch(ordersProvider);

    if (!authState.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const NeoAppBar(title: 'EVENTIFY', subtitleTag: 'PESANAN SAYA'),
        body: NeoEmptyState(
          title: 'BELUM MASUK AKUN',
          message: 'Silakan masuk akun untuk melihat riwayat pesanan tiket Anda.',
          actionText: 'MASUK SEKARANG',
          onAction: () => context.push('/login'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'PESANAN SAYA',
        actions: [
          NeoIconButton(
            icon: LucideIcons.refreshCw,
            backgroundColor: AppColors.mint,
            size: 38,
            iconSize: 18,
            onPressed: () => ref.read(ordersProvider.notifier).loadOrders(),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.textBorder,
        backgroundColor: AppColors.yellow,
        onRefresh: () async {
          await ref.read(ordersProvider.notifier).loadOrders();
        },
        child: ordersState.isLoading
            ? const NeoLoadingIndicator(text: 'Memuat riwayat pesanan...')
            : ordersState.errorMessage != null
                ? NeoErrorState(
                    message: ordersState.errorMessage!,
                    onRetry: () => ref.read(ordersProvider.notifier).loadOrders(),
                  )
                : ordersState.orders.isEmpty
                    ? NeoEmptyState(
                        title: 'BELUM ADA PESANAN',
                        message: 'Anda belum memiliki transaksi pemesanan tiket.',
                        actionText: 'JELAJAHI EVENT',
                        onAction: () => context.go('/home'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: ordersState.orders.length,
                        itemBuilder: (context, index) {
                          final order = ordersState.orders[index];
                          final statusColor = _getStatusColor(order.status);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppColors.textBorder, width: 2.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.textBorder,
                                  offset: Offset(3.5, 3.5),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if (order.isPending) {
                                    context.push('/payment/${order.orderCode}', extra: order);
                                  } else if (order.isPaid) {
                                    context.go('/tickets');
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            order.orderCode,
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.textBorder,
                                            ),
                                          ),
                                          NeoBadge(
                                            label: order.status.toUpperCase(),
                                            backgroundColor: statusColor,
                                            textColor: AppColors.textBorder,
                                            hasBorder: true,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      if (order.eventTitle != null) ...[
                                        Text(
                                          order.eventTitle!,
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.textBorder,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                      Text(
                                        Formatters.formatDateTime(order.createdAt),
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Divider(color: AppColors.divider, thickness: 1),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'TOTAL TAGIHAN',
                                                style: GoogleFonts.spaceGrotesk(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                              Text(
                                                Formatters.formatCurrency(order.totalAmount),
                                                style: GoogleFonts.spaceGrotesk(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors.textBorder,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (order.isPending)
                                            NeoButton(
                                              text: 'BAYAR SEKARANG',
                                              backgroundColor: AppColors.yellow,
                                              height: 34,
                                              fontSize: 10,
                                              fullWidth: false,
                                              onPressed: () {
                                                context.push('/payment/${order.orderCode}', extra: order);
                                              },
                                            )
                                          else if (order.isPaid)
                                            NeoOutlineButton(
                                              text: 'LIHAT TIKET',
                                              icon: LucideIcons.ticket,
                                              height: 34,
                                              fontSize: 10,
                                              onPressed: () => context.go('/tickets'),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
