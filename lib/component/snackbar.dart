import 'package:flutter/material.dart';

enum Type { error, success, warning }

void mySnackbar(BuildContext context, String text, Type type) {
  final overlay = Overlay.of(context);
  final color = {
    Type.error: Colors.red,
    Type.success: Colors.green,
    Type.warning: Colors.orange,
  }[type]!;

  final icon = {
    Type.error: Icons.error,
    Type.success: Icons.check_circle,
    Type.warning: Icons.warning,
  }[type]!;

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return _SnackbarAnimation(
        text: text,
        color: color,
        icon: icon,
        onDismissed: () => entry.remove(),
      );
    },
  );

  overlay.insert(entry);
}

class _SnackbarAnimation extends StatefulWidget {
  final String text;
  final Color color;
  final IconData icon;
  final VoidCallback onDismissed;

  const _SnackbarAnimation({
    required this.text,
    required this.color,
    required this.icon,
    required this.onDismissed,
  });

  @override
  State<_SnackbarAnimation> createState() => _SnackbarAnimationState();
}

class _SnackbarAnimationState extends State<_SnackbarAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // Auto dismiss after 3s
    Future.delayed(const Duration(seconds: 3), () async {
      await _controller.reverse();
      widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(12),
            color: widget.color,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
