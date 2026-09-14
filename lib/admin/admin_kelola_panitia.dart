import 'dart:math';
import 'package:flutter/material.dart';
import 'data/admin_mock_data.dart';
import 'models/admin_models.dart';
import 'widgets/admin_shared_widgets.dart';

class AdminKelolaPanitiaPage extends StatefulWidget {
  final String? preselectedEventId;

  const AdminKelolaPanitiaPage({super.key, this.preselectedEventId});

  @override
  State<AdminKelolaPanitiaPage> createState() => _AdminKelolaPanitiaPageState();
}

class _AdminKelolaPanitiaPageState extends State<AdminKelolaPanitiaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedEventId;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _selectedEventId = widget.preselectedEventId;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _generateRandomPassword() {
    const chars = 'abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789!@#%*';
    final random = Random();
    final generated = List.generate(10, (index) => chars[random.nextInt(chars.length)]).join();
    setState(() {
      _passwordController.text = generated;
      _obscurePassword = false;
    });
    showAdminSnackBar(context, 'Password otomatis dibuat: $generated');
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedEventId == null) {
      showAdminSnackBar(context, 'Silakan pilih event yang akan ditugaskan!', isError: true);
      return;
    }

    final dataService = AdminMockDataService();
    final event = dataService.getEventById(_selectedEventId!);
    final eventJudul = event?.judul ?? 'Event';

    final success = dataService.tambahPanitia(
      nama: _namaController.text,
      email: _emailController.text,
      password: _passwordController.text,
      eventId: _selectedEventId!,
    );

    if (success) {
      showAdminSnackBar(
        context,
        'Akun panitia berhasil dibuat & ditugaskan ke $eventJudul',
      );

      // Reset form
      _namaController.clear();
      _emailController.clear();
      _passwordController.clear();
      setState(() {
        _selectedEventId = null;
        _obscurePassword = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataService = AdminMockDataService();

    return ListenableBuilder(
      listenable: dataService,
      builder: (context, _) {
        final events = dataService.events;
        final recentPanitia = dataService.panitiaList.take(3).toList();

        // Validasi jika preselectedEventId ada di list
        if (_selectedEventId != null && !events.any((e) => e.id == _selectedEventId)) {
          _selectedEventId = null;
        }

        return Scaffold(
          backgroundColor: AdminColors.background,
          appBar: const AdminAppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Page
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: AdminColors.textBorder,
                        child: const Text(
                          'PANITIA MANAGEMENT PORTAL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'BUAT AKUN PANITIA',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AdminColors.textBorder,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Satu akun panitia bertindak sebagai penanggung jawab operasional untuk satu event spesifik.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AdminColors.textBorder, width: 3),
                    boxShadow: const [
                      BoxShadow(color: AdminColors.textBorder, offset: Offset(4, 4)),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'FORMULIR PENUGASAN PANITIA',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: AdminColors.textBorder,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              color: AdminColors.pink,
                              child: const Text(
                                'ROLE: PANITIA',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: AdminColors.textBorder,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Field 1: Pilih Event (Dropdown)
                        const AdminFormLabel('PILIH EVENT YANG AKAN DIKELOLA', isRequired: true),
                        Container(
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: AdminColors.textBorder, offset: Offset(2, 2)),
                            ],
                          ),
                          child: DropdownButtonFormField<String>(
                            key: ValueKey(_selectedEventId),
                            value: _selectedEventId,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: AdminColors.textBorder, width: 2),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: AdminColors.textBorder, width: 2),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.red, width: 2),
                              ),
                            ),
                            hint: Text(
                              '-- Pilih Event --',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            items: events.map((event) {
                              final bool hasPanitia = event.panitiaEmail != null;
                              return DropdownMenuItem<String>(
                                value: event.id,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${event.nomorEvent} - ${event.judul}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AdminColors.textBorder,
                                        ),
                                      ),
                                    ),
                                    if (hasPanitia)
                                      Container(
                                        margin: const EdgeInsets.only(left: 6),
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                        color: AdminColors.mint,
                                        child: const Text(
                                          'Ada Panitia',
                                          style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedEventId = val;
                              });
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'Event wajib dipilih';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Field 2: Nama Panitia
                        const AdminFormLabel('NAMA LENGKAP PANITIA', isRequired: true),
                        AdminTextField(
                          controller: _namaController,
                          hint: 'Contoh: Rian Pratama',
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Nama panitia wajib diisi';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Field 3: Email Panitia
                        const AdminFormLabel('ALAMAT EMAIL RESMI PANITIA', isRequired: true),
                        AdminTextField(
                          controller: _emailController,
                          hint: 'panitia.event@eventify.id',
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Email wajib diisi';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                              return 'Format email tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Field 4: Password + Generate Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AdminFormLabel('PASSWORD AKUN', isRequired: true),
                            InkWell(
                              onTap: _generateRandomPassword,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_awesome, size: 12, color: Colors.blue.shade900),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Generate Password Acak',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.blue.shade900,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        AdminTextField(
                          controller: _passwordController,
                          hint: 'Minimal 6 karakter',
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              size: 18,
                              color: AdminColors.textBorder,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Password wajib diisi';
                            if (val.length < 6) return 'Password minimal 6 karakter';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Tombol Submit CTA
                        AdminButton(
                          label: 'Buat Akun & Tugaskan ke Event',
                          icon: Icons.person_add_alt_1,
                          backgroundColor: AdminColors.pink,
                          onPressed: _submitForm,
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'Akun panitia akan langsung aktif dan terhubung ke event.',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Ringkasan akun panitia yang baru dibuat
                const Text(
                  'Akun Panitia Terbaru',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AdminColors.textBorder,
                  ),
                ),
                const SizedBox(height: 10),

                if (recentPanitia.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AdminColors.textBorder, width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        'Belum ada akun panitia yang dibuat.',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...recentPanitia.map((p) => _buildRecentPanitiaItem(p)),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentPanitiaItem(PanitiaAccountModel p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AdminColors.textBorder, width: 2),
        boxShadow: const [
          BoxShadow(color: AdminColors.textBorder, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AdminColors.mintLight,
              border: Border.all(color: AdminColors.textBorder, width: 1.5),
            ),
            child: const Icon(Icons.badge, size: 18, color: AdminColors.textBorder),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: AdminColors.textBorder,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Event: ${p.eventJudul}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            color: AdminColors.yellowHero,
            child: const Text(
              'AKTIF',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w900,
                color: AdminColors.textBorder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
