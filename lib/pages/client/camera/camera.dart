import 'package:ar_unib/component/appbar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class Camera extends ConsumerStatefulWidget {
  const Camera({super.key});

  @override
  ConsumerState createState() => _CameraState();
}

class _CameraState extends ConsumerState<Camera> {
  List<CameraDescription> cameras = [];
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    bool permissionGranted = await _requestPermissions();
    if (!permissionGranted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Izin Diperlukan"),
          content: const Text("Izin kamera diperlukan untuk menggunakan fitur ini."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        controller = CameraController(
          _cameras.first,
          ResolutionPreset.max,
        );
      });

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      await controller?.initialize();
      setState(() {});
    }
  }

  Future<bool> _requestPermissions() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: "Kamera"),
      body: _buildCameraView(),
    );
  }

  Widget _buildCameraView() {
    if (controller == null || controller!.value.isInitialized == false) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget cameraPreview = CameraPreview(controller!);
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            child: ClipRect(
              child: FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                child: SizedBox(
                  width: controller!.value.aspectRatio < 1
                      ? MediaQuery.of(context).size.width / controller!.value.aspectRatio
                      : MediaQuery.of(context).size.width,
                  height: controller!.value.aspectRatio < 1
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width * controller!.value.aspectRatio,
                  child: cameraPreview,
                ),
              ),
            ),
          ),
        ),

        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F0F23),
                Color(0xFF1A1A2E),
                Color(0xFF16213E),
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4ECDC4),
                      Color(0xFF44A08D),
                      Color(0xFF667EEA),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF4ECDC4).withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          CupertinoIcons.location_solid,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Ruang A.101',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            Text(
                                              'Gedung A - Lantai 1',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white.withOpacity(0.8),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.15),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'Ruang kuliah dengan kapasitas 40 mahasiswa. Dilengkapi dengan proyektor dan AC.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 16),

                            Container(
                              width: 85,
                              height: 85,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF667EEA).withOpacity(0.9),
                                    const Color(0xFF764BA2).withOpacity(0.9),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF667EEA).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                CupertinoIcons.photo_fill,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF667EEA).withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.location_circle_fill,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      '400m',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    Text(
                                      'Jarak',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF11998E).withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.clock_fill,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      '2 min',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    Text(
                                      'Estimasi',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF6B6B).withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {

                                  },
                                  child: const Icon(
                                    CupertinoIcons.arrow_right_circle_fill,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: const Color(0xFF4ECDC4).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4ECDC4),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4ECDC4).withOpacity(0.5),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'AR Navigation Active',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}