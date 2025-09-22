import 'package:ar_unib/pages/directory/directory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter/material.dart';

final exploreHoverProvider = StateProvider<bool>((ref) => false);

class Client extends ConsumerStatefulWidget {
  const Client({super.key});

  @override
  ConsumerState createState() => _ClientState();
}

class _ClientState extends ConsumerState<Client>
    with TickerProviderStateMixin {
  AnimationController? _fadeController;
  AnimationController? _slideController;
  AnimationController? _scaleController;
  AnimationController? _floatController;
  AnimationController? _shimmerController;

  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _scaleAnimation;
  Animation<double>? _floatAnimation;
  Animation<double>? _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController!,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController!,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController!,
      curve: Curves.bounceOut,
    ));

    _floatAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _floatController!,
      curve: Curves.easeInOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController!,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController?.forward();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _slideController?.forward();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      _scaleController?.forward();
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      _floatController?.repeat(reverse: true);
      _shimmerController?.repeat();
    });
  }

  @override
  void dispose() {
    _fadeController?.dispose();
    _slideController?.dispose();
    _scaleController?.dispose();
    _floatController?.dispose();
    _shimmerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _exploreHover = ref.watch(exploreHoverProvider);

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF0A0E21),
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _fadeController ?? const AlwaysStoppedAnimation(1.0),
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation ?? const AlwaysStoppedAnimation(1.0),
              child: SlideTransition(
                position: _slideAnimation ?? const AlwaysStoppedAnimation(Offset.zero),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0A0E21),
                        Color(0xFF1D1E33),
                        Color(0xFF111328),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _floatController ?? const AlwaysStoppedAnimation(0.0),
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _floatAnimation?.value ?? 0.0),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        gradient: const RadialGradient(
                                          colors: [
                                            Color(0xFF667EEA),
                                            Color(0xFF764BA2),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF667EEA).withOpacity(0.3),
                                            blurRadius: 20,
                                            spreadRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.compass_fill,
                                        size: 36,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 24),

                              ScaleTransition(
                                scale: _scaleAnimation ?? const AlwaysStoppedAnimation(1.0),
                                child: const Column(
                                  children: [
                                    Text(
                                      'Selamat Datang',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: CupertinoColors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'AR Navigation Fakultas Teknik',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF667EEA),
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Jelajahi gedung dan ruangan\ndengan teknologi augmented reality',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFBDC3C7),
                                        height: 1.3,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 3,
                          child: Center(
                            child: GestureDetector(
                              onTapDown: (_) {
                                ref.read(exploreHoverProvider.notifier).state = true;
                              },
                              onTapUp: (_) {
                                ref.read(exploreHoverProvider.notifier).state = false;
                                Navigator.push(context, MaterialPageRoute(builder: (_) => Directory(isAdmin: false,)));
                              },
                              onTapCancel: () {
                                ref.read(exploreHoverProvider.notifier).state = false;
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                width: 240,
                                height: 120,
                                transform: Matrix4.identity()
                                  ..scale(_exploreHover ? 0.96 : 1.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: _exploreHover
                                              ? [
                                            const Color(0xFF667EEA),
                                            const Color(0xFF764BA2),
                                            const Color(0xFF667EEA),
                                          ]
                                              : [
                                            const Color(0xFF4A90E2),
                                            const Color(0xFF7B68EE),
                                            const Color(0xFF4A90E2),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF4A90E2).withOpacity(_exploreHover ? 0.4 : 0.25),
                                            blurRadius: _exploreHover ? 30 : 20,
                                            spreadRadius: _exploreHover ? 5 : 2,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                    ),

                                    AnimatedBuilder(
                                      animation: _shimmerController ?? const AlwaysStoppedAnimation(0.0),
                                      builder: (context, child) {
                                        return Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              stops: [
                                                (_shimmerAnimation?.value ?? 0.0) - 0.3,
                                                (_shimmerAnimation?.value ?? 0.0),
                                                (_shimmerAnimation?.value ?? 0.0) + 0.3,
                                              ],
                                              colors: const [
                                                Colors.transparent,
                                                Color(0x20FFFFFF),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 300),
                                            transform: Matrix4.identity()
                                              ..rotateZ(_exploreHover ? 0.05 : 0),
                                            child: Icon(
                                              CupertinoIcons.map_fill,
                                              size: _exploreHover ? 40 : 36,
                                              color: CupertinoColors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          const Text(
                                            'EXPLORE',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: CupertinoColors.white,
                                              letterSpacing: 3,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: CupertinoColors.white.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Text(
                                              'Mulai Jelajahi',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: CupertinoColors.white,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: AnimatedBuilder(
                            animation: _floatController ?? const AlwaysStoppedAnimation(0.0),
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, (_floatAnimation?.value ?? 0.0) * 0.3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.up_arrow,
                                      color: CupertinoColors.white.withOpacity(0.5),
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Tap untuk memulai',
                                      style: TextStyle(
                                        color: CupertinoColors.white.withOpacity(0.5),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
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