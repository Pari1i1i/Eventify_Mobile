import 'package:flutter/material.dart';
import 'data/admin_mock_data.dart';
import 'models/admin_models.dart';
import 'widgets/admin_shared_widgets.dart';

class AdminDaftarPanitiaPage extends StatefulWidget {
  const AdminDaftarPanitiaPage({super.key});

  @override
  State<AdminDaftarPanitiaPage> createState() => _AdminDaftarPanitiaPageState();
}

class _AdminDaftarPanitiaPageState extends State<AdminDaftarPanitiaPage> {
  final Map<String, bool> _visiblePasswords = {};

  @override
  Widget build(BuildContext context) {
    final dataService = AdminMockDataService();

    return ListenableBuilder(
      listenable: dataService,
      builder: (context, _) {
        final panitiaList = dataService.panitiaList;

        return Scaffold(
          backgroundColor: AdminColors.background,
          appBar: const AdminAppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AdminColors.yellowHero,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AdminColors.textBorder, width: 3),
                    boxShadow: const [
                      BoxShadow(color: AdminColors.textBorder, offset: Offset(4, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AdminBadge(label: 'MANAJEMEN PENGGUNA', backgroundColor: AdminColors.textBorder),
                      const SizedBox(height: 8),
                      const Text(
                        'DAFTAR AKUN PANITIA',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AdminColors.textBorder,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Daftar akun panitia yang memiliki hak akses untuk memindai tiket QR dan mengelola check-in pada event tertentu.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AdminStatCard(
                              value: '${panitiaList.length}',
                              label: 'TOTAL PANITIA',
                              valueColor: AdminColors.purpleSeed,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: AdminStatCard(
                              value: '${dataService.totalEvent}',
                              label: 'TOTAL EVENT',
                              valueColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Title list
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Semua Akun (${panitiaList.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AdminColors.textBorder,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // List panitia cards
                if (panitiaList.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AdminColors.textBorder, width: 2),
                      boxShadow: const [
                        BoxShadow(color: AdminColors.textBorder, offset: Offset(3, 3)),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.group_off_outlined, size: 48, color: AdminColors.textBorder),
                        const SizedBox(height: 12),
                        const Text(
                          'Belum Ada Akun Panitia',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Buat akun panitia baru melalui menu "Kelola Panitia".',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ...panitiaList.map((panitia) => _buildPanitiaCard(context, panitia, dataService)),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPanitiaCard(
    BuildContext context,
    PanitiaAccountModel panitia,
    AdminMockDataService dataService,
  ) {
    final bool isPasswordVisible = _visiblePasswords[panitia.id] ?? false;
    final formattedDate =
        '${panitia.tanggalDibuat.day.toString().padLeft(2, '0')}/${panitia.tanggalDibuat.month.toString().padLeft(2, '0')}/${panitia.tanggalDibuat.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AdminColors.textBorder, width: 2.5),
        boxShadow: const [
          BoxShadow(color: AdminColors.textBorder, offset: Offset(3, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card Panitia
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: AdminColors.toska,
              border: Border(bottom: BorderSide(color: AdminColors.textBorder, width: 2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: AdminColors.textBorder,
                      child: Icon(Icons.person, color: Colors.white, size: 14),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      panitia.nama.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        color: AdminColors.textBorder,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: Colors.white,
                  child: Text(
                    'DIBUAT: $formattedDate',
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textBorder,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Detail Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AdminColors.yellowLight,
                        border: Border.all(color: AdminColors.textBorder, width: 1.5),
                      ),
                      child: const Icon(Icons.email, size: 14, color: AdminColors.textBorder),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ALAMAT EMAIL',
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          Text(
                            panitia.email,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AdminColors.textBorder,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Event Ditugaskan
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AdminColors.mintLight,
                        border: Border.all(color: AdminColors.textBorder, width: 1.5),
                      ),
                      child: const Icon(Icons.event, size: 14, color: AdminColors.textBorder),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'EVENT YANG DIKELOLA',
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          Text(
                            panitia.eventJudul,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AdminColors.textBorder,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Password dummy box (dengan toggle hide/show)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: AdminColors.textBorder, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Password: ',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          Text(
                            isPasswordVisible ? panitia.password : '••••••••••••',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AdminColors.textBorder,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          size: 16,
                          color: AdminColors.textBorder,
                        ),
                        onPressed: () {
                          setState(() {
                            _visiblePasswords[panitia.id] = !isPasswordVisible;
                          });
                        },
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(color: AdminColors.divider, height: 1),
                const SizedBox(height: 10),

                // Tombol Aksi: Reset Password & Hapus Akun
                Row(
                  children: [
                    Expanded(
                      child: AdminOutlineButton(
                        label: 'Reset Password',
                        icon: Icons.lock_reset,
                        onPressed: () => _showResetPasswordDialog(context, panitia, dataService),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 36,
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: AdminColors.textBorder, offset: Offset(2, 2)),
                          ],
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFCDD2),
                            foregroundColor: Colors.red.shade900,
                            side: const BorderSide(color: AdminColors.textBorder, width: 1.5),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            elevation: 0,
                          ),
                          onPressed: () => _showHapusAkunDialog(context, panitia, dataService),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_outline, size: 14, color: Colors.red),
                              SizedBox(width: 4),
                              Text(
                                'Hapus Akun',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dialog Reset Password Neobrutalism
  void _showResetPasswordDialog(
    BuildContext context,
    PanitiaAccountModel panitia,
    AdminMockDataService dataService,
  ) {
    final passwordController = TextEditingController(text: 'Baru${DateTime.now().millisecondsSinceEpoch % 10000}!');

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: AdminColors.textBorder, width: 3),
          ),
          title: const Text(
            'RESET PASSWORD',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: AdminColors.textBorder,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Masukkan password baru untuk akun ${panitia.nama}:',
                style: const TextStyle(fontSize: 12, color: AdminColors.textBorder),
              ),
              const SizedBox(height: 12),
              AdminTextField(
                controller: passwordController,
                hint: 'Password baru',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(color: AdminColors.textBorder, offset: Offset(2, 2)),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminColors.mint,
                  foregroundColor: AdminColors.textBorder,
                  side: const BorderSide(color: AdminColors.textBorder, width: 2),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  elevation: 0,
                ),
                onPressed: () {
                  final newPass = passwordController.text.trim();
                  if (newPass.isNotEmpty) {
                    dataService.resetPassword(panitia.id, newPass);
                    Navigator.pop(dialogCtx);
                    showAdminSnackBar(context, 'Password panitia ${panitia.nama} berhasil di-reset!');
                  }
                },
                child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        );
      },
    );
  }

  // Dialog Konfirmasi Hapus Akun Neobrutalism
  void _showHapusAkunDialog(
    BuildContext context,
    PanitiaAccountModel panitia,
    AdminMockDataService dataService,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: AdminColors.textBorder, width: 3),
          ),
          title: const Text(
            'HAPUS AKUN PANITIA?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus akun panitia "${panitia.nama}" (${panitia.email})?\n\nPenugasan pada event "${panitia.eventJudul}" akan dilepas dan statusnya menjadi "Belum Ada Panitia".',
            style: const TextStyle(fontSize: 12, height: 1.4, color: AdminColors.textBorder),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(color: AdminColors.textBorder, offset: Offset(2, 2)),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminColors.pink,
                  foregroundColor: AdminColors.textBorder,
                  side: const BorderSide(color: AdminColors.textBorder, width: 2),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  elevation: 0,
                ),
                onPressed: () {
                  dataService.hapusPanitia(panitia.id);
                  Navigator.pop(dialogCtx);
                  showAdminSnackBar(context, 'Akun panitia ${panitia.nama} berhasil dihapus!');
                },
                child: const Text('Ya, Hapus', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        );
      },
    );
  }
}
