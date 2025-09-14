import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ButtonVariant {
  primary,
  secondary,
  tertiary,
}

class MyButton extends ConsumerWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double height;
  final bool isRounded;
  final bool isTapped;
  final ButtonVariant variant;

  const MyButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.height = 40.0,
    this.isRounded = true,
    this.isTapped = true,
    this.variant = ButtonVariant.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicWidth(
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _getBackgroundColor(),
            foregroundColor: _getForegroundColor(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius()),
              side: _getBorderSide(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            elevation: variant == ButtonVariant.primary
                ? 2
                : (variant == ButtonVariant.tertiary ? 1 : 0),
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.blue.withOpacity(0.2); // warna efek klik
                }
                return null;
              },
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8.0),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return isTapped ? Colors.blue : Colors.grey.shade300;
      case ButtonVariant.secondary:
        return isTapped ? Colors.blue.withOpacity(0.1) : Colors.transparent;
      case ButtonVariant.tertiary:
        return isTapped ? Colors.green : Colors.grey.shade100;
    }
  }

  Color _getForegroundColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return isTapped ? Colors.white : Colors.grey.shade600;
      case ButtonVariant.secondary:
        return isTapped ? Colors.blue : Colors.grey.shade700;
      case ButtonVariant.tertiary:
        return isTapped ? Colors.white : Colors.black87;
    }
  }

  double _getBorderRadius() {
    switch (variant) {
      case ButtonVariant.primary:
        return isRounded ? 20.0 : 8.0;
      case ButtonVariant.secondary:
        return 8.0;
      case ButtonVariant.tertiary:
        return 12.0;
    }
  }

  BorderSide _getBorderSide() {
    switch (variant) {
      case ButtonVariant.primary:
        return BorderSide.none;
      case ButtonVariant.secondary:
        return BorderSide(
          color: isTapped ? Colors.blue : Colors.grey.withOpacity(0.5),
          width: 1.0,
        );
      case ButtonVariant.tertiary:
        return BorderSide(
          color: isTapped ? Colors.green : Colors.grey.withOpacity(0.3),
          width: 2.0,
        );
    }
  }
}