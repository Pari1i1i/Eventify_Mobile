import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/app_colors.dart';

/// Interactive Neobrutalism Button with Physical Press Effect
class NeoButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double height;
  final bool fullWidth;
  final bool isLoading;
  final double shadowOffset;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const NeoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor = AppColors.yellow,
    this.textColor = AppColors.textBorder,
    this.borderColor = AppColors.textBorder,
    this.height = 48,
    this.fullWidth = true,
    this.isLoading = false,
    this.shadowOffset = 4.0,
    this.fontSize = 13,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveShadow = _isPressed ? 1.0 : widget.shadowOffset;
    final effectiveTranslation = _isPressed ? widget.shadowOffset - 1.0 : 0.0;

    Widget button = GestureDetector(
      onTapDown: widget.onPressed == null || widget.isLoading
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: widget.onPressed == null || widget.isLoading
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Transform.translate(
        offset: Offset(effectiveTranslation, effectiveTranslation),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 70),
          height: widget.height,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.onPressed == null
                ? widget.backgroundColor.withValues(alpha: 0.5)
                : widget.backgroundColor,
            border: Border.all(color: widget.borderColor, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: widget.borderColor,
                offset: Offset(effectiveShadow, effectiveShadow),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading) ...[
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: widget.textColor,
                  ),
                ),
                const SizedBox(width: 10),
              ] else if (widget.icon != null) ...[
                Icon(widget.icon, size: 18, color: widget.textColor),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w900,
                  color: widget.textColor,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return widget.fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Neobrutalism Outline Button
class NeoOutlineButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double height;
  final bool fullWidth;
  final double shadowOffset;
  final double fontSize;

  const NeoOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor = Colors.white,
    this.textColor = AppColors.textBorder,
    this.borderColor = AppColors.textBorder,
    this.height = 42,
    this.fullWidth = false,
    this.shadowOffset = 3.0,
    this.fontSize = 12,
  });

  @override
  State<NeoOutlineButton> createState() => _NeoOutlineButtonState();
}

class _NeoOutlineButtonState extends State<NeoOutlineButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveShadow = _isPressed ? 1.0 : widget.shadowOffset;
    final effectiveTranslation = _isPressed ? widget.shadowOffset - 1.0 : 0.0;

    Widget button = GestureDetector(
      onTapDown: widget.onPressed == null ? null : (_) => setState(() => _isPressed = true),
      onTapUp: widget.onPressed == null
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Transform.translate(
        offset: Offset(effectiveTranslation, effectiveTranslation),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 70),
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(color: widget.borderColor, width: 2.0),
            boxShadow: [
              BoxShadow(
                color: widget.borderColor,
                offset: Offset(effectiveShadow, effectiveShadow),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16, color: widget.textColor),
                const SizedBox(width: 6),
              ],
              Text(
                widget.text,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w800,
                  color: widget.textColor,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return widget.fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Neobrutalism Square Icon Button
class NeoIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final Color borderColor;
  final double size;
  final double iconSize;
  final double shadowOffset;
  final String? tooltip;

  const NeoIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = AppColors.mint,
    this.iconColor = AppColors.textBorder,
    this.borderColor = AppColors.textBorder,
    this.size = 40,
    this.iconSize = 18,
    this.shadowOffset = 3.0,
    this.tooltip,
  });

  @override
  State<NeoIconButton> createState() => _NeoIconButtonState();
}

class _NeoIconButtonState extends State<NeoIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveShadow = _isPressed ? 1.0 : widget.shadowOffset;
    final effectiveTranslation = _isPressed ? widget.shadowOffset - 1.0 : 0.0;

    Widget btn = GestureDetector(
      onTapDown: widget.onPressed == null ? null : (_) => setState(() => _isPressed = true),
      onTapUp: widget.onPressed == null
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Transform.translate(
        offset: Offset(effectiveTranslation, effectiveTranslation),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 70),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(color: widget.borderColor, width: 2.0),
            boxShadow: [
              BoxShadow(
                color: widget.borderColor,
                offset: Offset(effectiveShadow, effectiveShadow),
                blurRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Icon(widget.icon, size: widget.iconSize, color: widget.iconColor),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: btn);
    }
    return btn;
  }
}

/// Neobrutalism Card with Hard Offset Shadow and Thick Border
class NeoCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double shadowOffset;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  const NeoCard({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderColor = AppColors.textBorder,
    this.borderWidth = 2.5,
    this.shadowOffset = 4.0,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: borderColor,
            offset: Offset(shadowOffset, shadowOffset),
            blurRadius: 0,
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}

/// Neobrutalism Form Label
class NeoFormLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const NeoFormLabel(this.text, {super.key, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: AppColors.textBorder,
            letterSpacing: 0.6,
          ),
          children: isRequired
              ? [
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}

/// Neobrutalism Text Input Field
class NeoTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;

  const NeoTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.textBorder,
            offset: Offset(2.5, 2.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textBorder,
        ),
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade400,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: AppColors.textBorder, width: 2.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: AppColors.textBorder, width: 2.5),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Colors.red, width: 2.5),
          ),
        ),
      ),
    );
  }
}

/// Neobrutalism Badge / Tag
class NeoBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final bool hasBorder;
  final IconData? icon;

  const NeoBadge({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.textBorder,
    this.textColor = Colors.white,
    this.fontSize = 9,
    this.hasBorder = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: hasBorder
            ? Border.all(color: AppColors.textBorder, width: 1.5)
            : Border.all(color: AppColors.textBorder, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// Neobrutalism Stat Card
class NeoStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color backgroundColor;
  final Color valueColor;
  final IconData? icon;

  const NeoStatCard({
    super.key,
    required this.value,
    required this.label,
    this.backgroundColor = Colors.white,
    this.valueColor = AppColors.textBorder,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: AppColors.textBorder, width: 2.0),
        boxShadow: const [
          BoxShadow(
            color: AppColors.textBorder,
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 20, color: AppColors.textBorder),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Neobrutalism App Bar
class NeoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitleTag;
  final Color tagColor;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const NeoAppBar({
    super.key,
    required this.title,
    this.subtitleTag,
    this.tagColor = AppColors.yellow,
    this.showBackButton = false,
    this.onBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Center(
                child: NeoIconButton(
                  icon: LucideIcons.arrowLeft,
                  size: 36,
                  iconSize: 18,
                  backgroundColor: Colors.white,
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                ),
              ),
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.textBorder,
              border: Border.all(color: AppColors.textBorder, width: 2.0),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.textBorder,
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
          ),
          if (subtitleTag != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: tagColor,
                border: Border.all(color: AppColors.textBorder, width: 1.5),
              ),
              child: Text(
                subtitleTag!,
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.textBorder,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (actions != null) ...actions!,
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Neobrutalism Empty State Widget
class NeoEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  const NeoEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = LucideIcons.inbox,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: NeoCard(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  border: Border.all(color: AppColors.textBorder, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.textBorder,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Icon(icon, size: 32, color: AppColors.textBorder),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textBorder,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              if (actionText != null && onAction != null) ...[
                const SizedBox(height: 16),
                NeoButton(
                  text: actionText!,
                  onPressed: onAction,
                  backgroundColor: AppColors.mint,
                  height: 40,
                  fontSize: 12,
                  fullWidth: false,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Neobrutalism Error State Widget
class NeoErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const NeoErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: NeoCard(
          backgroundColor: AppColors.pinkLight.withValues(alpha: 0.3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.pink,
                  border: Border.all(color: AppColors.textBorder, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.textBorder,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(LucideIcons.alertTriangle, size: 28, color: AppColors.textBorder),
              ),
              const SizedBox(height: 12),
              Text(
                'Terjadi Masalah',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textBorder,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textBorder,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                NeoButton(
                  text: 'Coba Lagi',
                  icon: LucideIcons.refreshCw,
                  onPressed: onRetry,
                  backgroundColor: AppColors.yellow,
                  height: 40,
                  fontSize: 12,
                  fullWidth: false,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Neobrutalism Loading Card
class NeoLoadingIndicator extends StatelessWidget {
  final String? text;

  const NeoLoadingIndicator({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: NeoCard(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.textBorder,
            ),
            if (text != null) ...[
              const SizedBox(height: 14),
              Text(
                text!,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textBorder,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Neobrutalism SnackBar Helper
void showNeoSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
  bool isSuccess = false,
  IconData? icon,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  
  Color bg = AppColors.yellow;
  if (isError) bg = AppColors.pink;
  if (isSuccess) bg = AppColors.mint;

  IconData leadIcon = icon ?? (isError ? LucideIcons.alertCircle : (isSuccess ? LucideIcons.checkCircle2 : LucideIcons.info));

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: bg,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: AppColors.textBorder, width: 2.5),
      ),
      content: Row(
        children: [
          Icon(leadIcon, size: 20, color: AppColors.textBorder),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textBorder,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
