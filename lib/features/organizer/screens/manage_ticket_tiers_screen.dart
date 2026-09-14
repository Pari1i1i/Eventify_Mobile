import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../../events/models/event_model.dart';
import '../../events/models/ticket_tier_model.dart';
import '../providers/organizer_provider.dart';
import '../services/organizer_api_service.dart';

class ManageTicketTiersScreen extends ConsumerStatefulWidget {
  final int eventId;
  final EventModel? initialEvent;

  const ManageTicketTiersScreen({
    super.key,
    required this.eventId,
    this.initialEvent,
  });

  @override
  ConsumerState<ManageTicketTiersScreen> createState() => _ManageTicketTiersScreenState();
}

class _ManageTicketTiersScreenState extends ConsumerState<ManageTicketTiersScreen> {
  List<TicketTierModel> _tiers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialEvent != null) {
      _tiers = List.from(widget.initialEvent!.ticketTiers);
    }
  }

  void _showAddEditTierModal({TicketTierModel? tierToEdit}) {
    final isEditing = tierToEdit != null;
    final nameCtrl = TextEditingController(text: tierToEdit?.name ?? '');
    final descCtrl = TextEditingController(text: tierToEdit?.description ?? '');
    final priceCtrl = TextEditingController(text: tierToEdit != null ? tierToEdit.price.toString() : '0');
    final quotaCtrl = TextEditingController(text: tierToEdit != null ? tierToEdit.quota.toString() : '100');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.textBorder, width: 3),
            boxShadow: const [
              BoxShadow(color: AppColors.textBorder, offset: Offset(0, -4)),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'EDIT TIER TIKET' : 'TAMBAH TIER TIKET',
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
                const SizedBox(height: 16),
                const NeoFormLabel('NAMA TIER TIKET', isRequired: true),
                NeoTextField(
                  controller: nameCtrl,
                  hint: 'Contoh: Early Bird / VIP / Regular',
                  prefixIcon: const Icon(LucideIcons.ticket, size: 18, color: AppColors.textBorder),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Nama tier wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                const NeoFormLabel('DESKRIPSI TIER (OPSIONAL)'),
                NeoTextField(
                  controller: descCtrl,
                  hint: 'Contoh: Termasuk Jersey & Medali Finisher',
                  prefixIcon: const Icon(LucideIcons.info, size: 18, color: AppColors.textBorder),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const NeoFormLabel('HARGA (RP)', isRequired: true),
                          NeoTextField(
                            controller: priceCtrl,
                            hint: '0',
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'Harga wajib diisi';
                              if (num.tryParse(val) == null) return 'Harus angka';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const NeoFormLabel('KUOTA TIKET', isRequired: true),
                          NeoTextField(
                            controller: quotaCtrl,
                            hint: '100',
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'Kuota wajib diisi';
                              if (int.tryParse(val) == null) return 'Harus angka';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                NeoButton(
                  text: isEditing ? 'SIMPAN PERUBAHAN TIER' : 'TAMBAHKAN TIER',
                  backgroundColor: AppColors.yellow,
                  icon: LucideIcons.check,
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    Navigator.pop(ctx);
                    setState(() => _isLoading = true);

                    final tierData = <String, dynamic>{
                      'event_id': widget.eventId,
                      'name': nameCtrl.text.trim(),
                      'description': descCtrl.text.trim(),
                      'price': num.parse(priceCtrl.text),
                      'quota': int.parse(quotaCtrl.text),
                    };

                    try {
                      final orgApi = ref.read(organizerApiServiceProvider);
                      if (isEditing) {
                        final updated = await orgApi.updateTicketTier(tierToEdit.id, tierData);
                        if (mounted) {
                          setState(() {
                            final idx = _tiers.indexWhere((t) => t.id == tierToEdit.id);
                            if (idx >= 0) _tiers[idx] = updated;
                            _isLoading = false;
                          });
                          showNeoSnackBar(context, 'Tier tiket berhasil diperbarui!', isSuccess: true);
                        }
                      } else {
                        final created = await orgApi.createTicketTier(tierData);
                        if (mounted) {
                          setState(() {
                            _tiers.add(created);
                            _isLoading = false;
                          });
                          showNeoSnackBar(context, 'Tier tiket berhasil ditambahkan!', isSuccess: true);
                        }
                      }
                      ref.read(organizerProvider.notifier).loadMyEvents();
                    } catch (e) {
                      if (mounted) {
                        setState(() => _isLoading = false);
                        showNeoSnackBar(context, e.toString(), isError: true);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteTier(TicketTierModel tier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: AppColors.textBorder, width: 3),
        ),
        title: Text(
          'HAPUS TIER TIKET',
          style: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textBorder),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus tier "${tier.name}"?',
          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textBorder),
        ),
        actions: [
          NeoOutlineButton(text: 'BATAL', onPressed: () => Navigator.pop(ctx)),
          NeoButton(
            text: 'HAPUS',
            backgroundColor: AppColors.pink,
            height: 38,
            fontSize: 11,
            fullWidth: false,
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() => _isLoading = true);
              try {
                await ref.read(organizerApiServiceProvider).deleteTicketTier(tier.id);
                if (mounted) {
                  setState(() {
                    _tiers.removeWhere((t) => t.id == tier.id);
                    _isLoading = false;
                  });
                  showNeoSnackBar(context, 'Tier berhasil dihapus', isSuccess: true);
                }
                ref.read(organizerProvider.notifier).loadMyEvents();
              } catch (e) {
                if (mounted) {
                  setState(() => _isLoading = false);
                  showNeoSnackBar(context, e.toString(), isError: true);
                }
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
      backgroundColor: AppColors.background,
      appBar: const NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'KELOLA TIER TIKET',
        showBackButton: true,
      ),
      body: _isLoading
          ? const NeoLoadingIndicator(text: 'Menyimpan data tier tiket...')
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  NeoCard(
                    backgroundColor: AppColors.toska,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DAFTAR TIER TIKET',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textBorder,
                                ),
                              ),
                              Text(
                                'Atur harga & kuota tiket peserta event',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        NeoButton(
                          text: '+ TIKET BARU',
                          backgroundColor: AppColors.yellow,
                          height: 38,
                          fontSize: 11,
                          fullWidth: false,
                          onPressed: () => _showAddEditTierModal(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (_tiers.isEmpty)
                    NeoEmptyState(
                      title: 'BELUM ADA TIER TIKET',
                      message: 'Tambahkan minimal 1 tier tiket agar pengunjung bisa melakukan pemesanan.',
                      actionText: '+ TAMBAHKAN TIER TIKET',
                      onAction: () => _showAddEditTierModal(),
                    )
                  else
                    ..._tiers.map((tier) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.textBorder, width: 2.5),
                          boxShadow: const [
                            BoxShadow(color: AppColors.textBorder, offset: Offset(3.5, 3.5)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    tier.name,
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textBorder,
                                    ),
                                  ),
                                ),
                                NeoBadge(
                                  label: 'KUOTA: ${tier.quota}',
                                  backgroundColor: AppColors.mint,
                                  textColor: AppColors.textBorder,
                                  hasBorder: true,
                                ),
                              ],
                            ),
                            if (tier.description != null && tier.description!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                tier.description!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),
                            const Divider(color: AppColors.divider, thickness: 1),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Formatters.formatCurrency(tier.price),
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: tier.price == 0 ? AppColors.purpleSeed : AppColors.magenta,
                                  ),
                                ),
                                Row(
                                  children: [
                                    NeoOutlineButton(
                                      text: 'EDIT',
                                      icon: LucideIcons.edit,
                                      height: 32,
                                      fontSize: 10,
                                      onPressed: () => _showAddEditTierModal(tierToEdit: tier),
                                    ),
                                    const SizedBox(width: 6),
                                    NeoIconButton(
                                      icon: LucideIcons.trash2,
                                      backgroundColor: AppColors.pink,
                                      size: 32,
                                      iconSize: 14,
                                      tooltip: 'Hapus Tier',
                                      onPressed: () => _confirmDeleteTier(tier),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
