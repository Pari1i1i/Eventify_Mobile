import 'package:flutter/material.dart';

/// Palet warna Neobrutalism Eventify (sesuai standar di Beranda & detail)
class AdminColors {
  static const Color textBorder = Color(0xFF2B2630);
  static const Color background = Color(0xFFFFF7FF);
  static const Color purpleSeed = Color(0xFF615983);
  static const Color yellowHero = Color(0xFFFFF176);
  static const Color yellowLight = Color(0xFFFFF275);
  static const Color mint = Color(0xFFA8E6CF);
  static const Color mintLight = Color(0xFFB8E8C3);
  static const Color pink = Color(0xFFFF9EB1);
  static const Color pinkLight = Color(0xFFFFAAA5);
  static const Color orange = Color(0xFFFFD3B6);
  static const Color toska = Color(0xFFC7F9EE);
  static const Color purpleLight = Color(0xFFC3B8E8);
  static const Color peach = Color(0xFFE8C3B8);
  static const Color divider = Color(0xFFE0E0E0);
}

/// AppBar Khusus Admin dengan gaya Neobrutalism
class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const AdminAppBar({
    super.key,
    this.title = 'EVENTIFY',
    this.showBackButton = false,
    this.onBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AdminColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AdminColors.textBorder),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AdminColors.textBorder,
              letterSpacing: 1.2,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AdminColors.textBorder,
              border: Border.all(color: AdminColors.textBorder, width: 1.5),
            ),
            child: const Text(
              'ADMIN PANEL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
      actions: actions ??
          [
            const CircleAvatar(
              backgroundColor: AdminColors.purpleSeed,
              radius: 16,
              child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 16),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Container dengan Border Tebal & Solid Offset Shadow khas Neobrutalism
class AdminCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double borderWidth;
  final double shadowOffset;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadius? borderRadius;

  const AdminCard({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderWidth = 3,
    this.shadowOffset = 4,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        border: Border.all(color: AdminColors.textBorder, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: AdminColors.textBorder,
            offset: Offset(shadowOffset, shadowOffset),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Tombol CTA Neobrutalism (Border tegas, shadow offset, sudut kotak)
class AdminButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final bool fullWidth;
  final double shadowOffset;

  const AdminButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor = AdminColors.pink,
    this.textColor = AdminColors.textBorder,
    this.height = 46,
    this.fullWidth = true,
    this.shadowOffset = 3,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = Container(
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AdminColors.textBorder,
            offset: Offset(shadowOffset, shadowOffset),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: const BorderSide(color: AdminColors.textBorder, width: 2),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: textColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: buttonContent) : buttonContent;
  }
}

/// Tombol Outlined Neobrutalism
class AdminOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final double height;

  const AdminOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor = Colors.white,
    this.textColor = AdminColors.textBorder,
    this.height = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: AdminColors.textBorder, offset: Offset(2, 2)),
        ],
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: const BorderSide(color: AdminColors.textBorder, width: 1.5),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: textColor),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Label Field Form
class AdminFormLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const AdminFormLabel(this.text, {super.key, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        isRequired ? '$text *' : text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: AdminColors.textBorder,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Text Field Neobrutalism
class AdminTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;

  const AdminTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: AdminColors.textBorder, offset: Offset(2, 2)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AdminColors.textBorder,
        ),
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade400,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}

/// Stat Card Neobrutalism (Meniru pola _buildStatCard di Beranda.dart)
class AdminStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const AdminStatCard({
    super.key,
    required this.value,
    required this.label,
    this.valueColor = AdminColors.textBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AdminColors.textBorder, width: 2),
        boxShadow: const [
          BoxShadow(color: AdminColors.textBorder, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: AdminColors.textBorder,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge Pill Neobrutalism
class AdminBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final bool hasBorder;

  const AdminBadge({
    super.key,
    required this.label,
    this.backgroundColor = AdminColors.textBorder,
    this.textColor = Colors.white,
    this.fontSize = 9,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: hasBorder ? Border.all(color: AdminColors.textBorder, width: 1.5) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Info Row dengan Icon Box Berwarna Pastel (Meniru pola _buildInfoRow di Beranda.dart)
class AdminInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconBgColor;

  const AdminInfoRow({
    super.key,
    required this.icon,
    required this.text,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: iconBgColor,
            border: Border.all(color: AdminColors.textBorder, width: 1.5),
          ),
          child: Icon(icon, size: 16, color: AdminColors.textBorder),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AdminColors.textBorder,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom Dot Pattern Painter untuk Header Card
class DotPatternPainter extends CustomPainter {
  final Color color;

  DotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final dotPaint = Paint()
      ..color = AdminColors.textBorder.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    const double spacing = 12.0;
    const double radius = 1.2;

    for (double x = 6; x < size.width; x += spacing) {
      for (double y = 6; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// SnackBar Neobrutalism Helper
void showAdminSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isError ? AdminColors.pink : AdminColors.mint,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: AdminColors.textBorder, width: 2),
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: AdminColors.textBorder,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    ),
  );
}
