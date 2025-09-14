import 'dart:io';
import 'package:ar_unib/component/button.dart';
import 'package:ar_unib/component/snackbar.dart';
import 'package:ar_unib/component/text_field.dart';
import 'package:ar_unib/model/room_model.dart';
import 'package:ar_unib/notifier/room_notifier.dart';
import 'package:ar_unib/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final localImageProvider = StateProvider<File?>((ref) => null);
final imageUrlProvider = StateProvider<String?>((ref) => null);
final loadingProvider = StateProvider<bool>((ref) => false);

class AddRoom extends ConsumerStatefulWidget {
  const AddRoom({super.key});

  @override
  ConsumerState createState() => _AddRoomState();
}

class _AddRoomState extends ConsumerState<AddRoom> {
  final ImagesService _imageService = ImagesService();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _roomCodeController = TextEditingController();
  final _floorController = TextEditingController();
  final _buildingIdController = TextEditingController();

  Future<void> _pickImage(WidgetRef ref) async {
    final file = await _imageService.pickImage();
    if (file != null) {
      ref.read(localImageProvider.notifier).state = file;
      ref.read(imageUrlProvider.notifier).state = null;
    }
  }

  Future<void> _submitHandler(
      BuildContext context,
      WidgetRef ref,
      RoomNotifier notifier,
      File? file,
      RoomState state
      ) async {
    final isLoading = ref.read(loadingProvider);
    if (isLoading) return;

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final roomCode = _roomCodeController.text.trim();
    final buildingId = _buildingIdController.text.trim();
    final floor = int.tryParse(_floorController.text.trim());

    if (name.isEmpty ||
        description.isEmpty ||
        floor == null ||
        buildingId.isEmpty ||
        file == null) {
      mySnackbar(context, "Please fill all the fields and select an image", Type.error);
      return;
    }

    ref.read(loadingProvider.notifier).state = true;

    try {
      final url = await _imageService.uploadImage(context, file);

      if (url == null) {
        mySnackbar(context, "Failed to upload image", Type.error);
        return;
      }

      ref.read(imageUrlProvider.notifier).state = url;

      await notifier.addRoom(
        RoomModel(
          name: name,
          description: description,
          image_url: url,
          roomCode: roomCode,
          floor: floor,
          buildingId: buildingId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final currentState = ref.read(roomNotifierProvider);
      if (currentState.error != null) {
        mySnackbar(context, "Failed to add room: ${currentState.error}", Type.error);
        print('Room notifier error: ${currentState.error}');
        return;
      }

      mySnackbar(context, "Room added successfully", Type.success);

      _clearForm(ref);

      if (mounted) {
        Navigator.pop(context);
      }

    } catch (e) {
      mySnackbar(context, "Failed to add room: $e", Type.error);
      print('Error in _submitHandler: $e');
    } finally {
      if (mounted) {
        ref.read(loadingProvider.notifier).state = false;
      }
    }
  }

  void _clearForm(WidgetRef ref) {
    _nameController.clear();
    _descriptionController.clear();
    _roomCodeController.clear();
    _floorController.clear();
    _buildingIdController.clear();
    ref.read(localImageProvider.notifier).state = null;
    ref.read(imageUrlProvider.notifier).state = null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _roomCodeController.dispose();
    _floorController.dispose();
    _buildingIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(roomNotifierProvider.notifier);
    final File? selectedImage = ref.watch(localImageProvider);
    final state = ref.watch(roomNotifierProvider);
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Room")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: isLoading ? null : () => _pickImage(ref),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: isLoading ? Colors.grey[300] : Colors.grey[200],
                ),
                child: selectedImage == null
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                          Icons.cloud_upload,
                          size: 50,
                          color: isLoading ? Colors.grey[400] : Colors.grey
                      ),
                      const SizedBox(height: 8),
                      Text(
                          isLoading ? "Uploading..." : "Tap to upload image",
                          style: TextStyle(
                              color: isLoading ? Colors.grey[400] : Colors.grey
                          )
                      ),
                    ],
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      Image.file(
                        selectedImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        cacheWidth: 800,
                      ),
                      if (isLoading)
                        Container(
                          color: Colors.black54,
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            MyTextField(
              controller: _nameController,
              name: "Name",
              inputType: TextInputType.text,
            ),
            MyTextField(
              controller: _descriptionController,
              name: "Description",
              inputType: TextInputType.text,
            ),
            MyTextField(
              controller: _roomCodeController,
              name: "Room Code",
              inputType: TextInputType.text,
            ),
            MyTextField(
              controller: _floorController,
              name: "Floor",
              inputType: TextInputType.number,
            ),
            MyTextField(
              controller: _buildingIdController,
              name: "Building Id",
              inputType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            MyButton(
              text: isLoading ? "Submitting..." : "Submit",
              onPressed: isLoading
                  ? null
                  : () => _submitHandler(context, ref, notifier, selectedImage, state),
            ),

            if (isLoading) ...[
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text("Processing your request..."),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}