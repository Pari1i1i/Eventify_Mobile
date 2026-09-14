import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../../auth/models/user_model.dart';
import '../providers/admin_provider.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showRoleChangeModal(UserModel user) {
    showModalBottomSheet(
      context: context,
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
                  'UBAH ROLE PENGGUNA',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 15,
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
            const SizedBox(height: 12),
            Text(
              'Pilih role baru untuk: ${user.name} (${user.email})',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ...['customer', 'organizer', 'admin'].map((role) {
              final isCurrent = user.role.toLowerCase() == role;
              Color roleColor = AppColors.toska;
              if (role == 'admin') roleColor = AppColors.pink;
              if (role == 'organizer') roleColor = AppColors.yellow;

              return GestureDetector(
                onTap: () async {
                  Navigator.pop(ctx);
                  final success = await ref.read(adminUsersProvider.notifier).changeUserRole(user.id, role);
                  if (mounted) {
                    if (success) {
                      showNeoSnackBar(context, 'Role pengguna berhasil diubah ke: ${role.toUpperCase()}', isSuccess: true);
                    } else {
                      showNeoSnackBar(context, 'Gagal mengubah role pengguna', isError: true);
                    }
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrent ? roleColor : Colors.white,
                    border: Border.all(color: AppColors.textBorder, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        role.toUpperCase(),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textBorder,
                        ),
                      ),
                      if (isCurrent)
                        const NeoBadge(
                          label: 'AKTIF SAAT INI',
                          backgroundColor: AppColors.textBorder,
                          textColor: Colors.white,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminUsersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'KELOLA USER',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Search & Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: NeoCard(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  NeoTextField(
                    controller: _searchCtrl,
                    hint: 'Cari nama atau email pengguna...',
                    prefixIcon: const Icon(LucideIcons.search, size: 18, color: AppColors.textBorder),
                    onChanged: (val) {
                      ref.read(adminUsersProvider.notifier).setSearch(val);
                    },
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Semua', null, state.selectedRole),
                        const SizedBox(width: 6),
                        _buildFilterChip('Customer', 'customer', state.selectedRole),
                        const SizedBox(width: 6),
                        _buildFilterChip('Panitia', 'organizer', state.selectedRole),
                        const SizedBox(width: 6),
                        _buildFilterChip('Admin', 'admin', state.selectedRole),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User List
          Expanded(
            child: RefreshIndicator(
              color: AppColors.textBorder,
              backgroundColor: AppColors.yellow,
              onRefresh: () async {
                await ref.read(adminUsersProvider.notifier).loadUsers();
              },
              child: state.isLoading
                  ? const NeoLoadingIndicator(text: 'Memuat data pengguna...')
                  : state.errorMessage != null
                      ? NeoErrorState(
                          message: state.errorMessage!,
                          onRetry: () => ref.read(adminUsersProvider.notifier).loadUsers(),
                        )
                      : state.users.isEmpty
                          ? const NeoEmptyState(
                              title: 'TIDAK ADA PENGGUNA',
                              message: 'Tidak ditemukan pengguna sesuai pencarian.',
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: state.users.length,
                              itemBuilder: (context, index) {
                                final user = state.users[index];
                                Color roleColor = AppColors.mint;
                                if (user.isAdmin) roleColor = AppColors.pink;
                                if (user.isOrganizer) roleColor = AppColors.yellow;

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
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: roleColor,
                                          border: Border.all(color: AppColors.textBorder, width: 1.5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.textBorder,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.name,
                                              style: GoogleFonts.spaceGrotesk(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900,
                                                color: AppColors.textBorder,
                                              ),
                                            ),
                                            Text(
                                              user.email,
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 11,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      NeoButton(
                                        text: user.role.toUpperCase(),
                                        backgroundColor: roleColor,
                                        height: 32,
                                        fontSize: 9,
                                        fullWidth: false,
                                        onPressed: () => _showRoleChangeModal(user),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? roleValue, String? activeRole) {
    final isSelected = roleValue == activeRole;
    return GestureDetector(
      onTap: () => ref.read(adminUsersProvider.notifier).setRole(roleValue),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textBorder : Colors.white,
          border: Border.all(color: AppColors.textBorder, width: 1.5),
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: isSelected ? Colors.white : AppColors.textBorder,
          ),
        ),
      ),
    );
  }
}
