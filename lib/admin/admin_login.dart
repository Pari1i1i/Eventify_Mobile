import 'package:flutter/material.dart';
import 'admin_main_navigation.dart';
import 'widgets/admin_shared_widgets.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@eventify.id');
  final _passwordController = TextEditingController(text: 'admin123');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    // Dummy validation: email harus berisi "admin" atau kredensial valid
    if (email.contains('admin') && password.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminMainNavigation(),
        ),
      );
    } else {
      showAdminSnackBar(
        context,
        'Login gagal. Masukkan email admin yang valid (contoh: admin@eventify.id)',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      appBar: AppBar(
        backgroundColor: AdminColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AdminColors.textBorder),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text(
          'EVENTIFY',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: AdminColors.textBorder,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container Login Neobrutalism (Mirip Section SUDAH MENDAFTAR)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AdminColors.yellowHero,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AdminColors.textBorder, width: 3),
                    boxShadow: const [
                      BoxShadow(color: AdminColors.textBorder, offset: Offset(5, 5)),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge Admin
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              color: AdminColors.textBorder,
                              child: const Text(
                                'PORTAL ADMINISTRATOR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const CircleAvatar(
                              radius: 12,
                              backgroundColor: AdminColors.textBorder,
                              child: Icon(Icons.lock, size: 12, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Title
                        const Text(
                          'MASUK SEBAGAI ADMIN',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AdminColors.textBorder,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Akses kontrol penuh untuk manajemen event dan penugasan akun panitia penyelenggara.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AdminColors.textBorder,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Field 1: Email
                        const AdminFormLabel('ALAMAT EMAIL ADMIN', isRequired: true),
                        AdminTextField(
                          controller: _emailController,
                          hint: 'admin@eventify.id',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined, size: 18, color: AdminColors.textBorder),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Wajib diisi';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Field 2: Password
                        const AdminFormLabel('PASSWORD', isRequired: true),
                        AdminTextField(
                          controller: _passwordController,
                          hint: '••••••••',
                          obscureText: _obscurePassword,
                          prefixIcon: const Icon(Icons.lock_outline, size: 18, color: AdminColors.textBorder),
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
                            if (val == null || val.isEmpty) return 'Wajib diisi';
                            return null;
                          },
                        ),
                        const SizedBox(height: 22),

                        // Tombol Submit CTA (Pink neobrutalism)
                        AdminButton(
                          label: 'Masuk sebagai Admin',
                          icon: Icons.login,
                          backgroundColor: AdminColors.pink,
                          onPressed: _handleLogin,
                        ),
                        const SizedBox(height: 12),

                        // Demo Helper Info
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AdminColors.textBorder, width: 1.5),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outline, size: 13, color: AdminColors.textBorder),
                                  SizedBox(width: 4),
                                  Text(
                                    'Kredensial Demo MVP:',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: AdminColors.textBorder,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Email: admin@eventify.id | Pass: admin123',
                                style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol Kembali ke Sisi User (jika dibuka dari app)
                if (Navigator.canPop(context))
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 16, color: AdminColors.textBorder),
                    label: const Text(
                      'Kembali ke Beranda User',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AdminColors.textBorder,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
