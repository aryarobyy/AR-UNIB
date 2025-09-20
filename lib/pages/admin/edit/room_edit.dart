import 'package:ar_unib/component/appbar.dart';
import 'package:ar_unib/component/button.dart';
import 'package:ar_unib/component/snackbar.dart';
import 'package:ar_unib/model/index.dart';
import 'package:ar_unib/notifier/room_notifier.dart';
import 'package:ar_unib/pages/admin/add/add.dart';
import 'package:ar_unib/services/image_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

class RoomEdit extends ConsumerStatefulWidget {
  final RoomModel room;

  const RoomEdit({
    required this.room,
    super.key
  });

  @override
  ConsumerState createState() => _RoomEditState();
}

class _RoomEditState extends ConsumerState<RoomEdit> {
  final ImagesService _imageService = ImagesService();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _floorController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _buildingIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final room = widget.room!;
    _nameController.text = room.name;
    _roomCodeController.text = room.roomCode ?? '';
    _descriptionController.text = room.description ?? '';
    _floorController.text = room.floor?.toString() ?? '';
    _imageUrlController.text = room.image_url ?? '';
    _buildingIdController.text = room.buildingId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomCodeController.dispose();
    _descriptionController.dispose();
    _floorController.dispose();
    _imageUrlController.dispose();
    _buildingIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: MyAppbar(
        title: 'Edit Ruangan'
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(),
              const SizedBox(height: 24),

              Text(
                'Informasi Dasar',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildNameField(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(flex: 2, child: _buildRoomCodeField()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFloorField()),
                ],
              ),
              const SizedBox(height: 16),
              _buildBuildingIdField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 24),

              _buildActionButtons(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    final File? selectedImage = ref.watch(localImageProvider);

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: selectedImage != null
                ? Image.file(
              selectedImage,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            )
                : (widget.room.image_url?.isNotEmpty == true)
                ? Image.network(
              widget.room.image_url!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
            )
                : _buildImagePlaceholder(),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                onPressed: _pickImage,
              ),
            ),
          ),
          if (selectedImage != null || widget.room.image_url?.isNotEmpty == true)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: _removeImage,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[100],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Tap untuk pilih gambar',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Nama Ruangan *',
        hintText: 'Contoh: Ruang Kuliah A101',
        prefixIcon: const Icon(Icons.meeting_room),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama ruangan harus diisi';
        }
        if (value.trim().length < 2) {
          return 'Nama ruangan minimal 2 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildRoomCodeField() {
    return TextFormField(
      controller: _roomCodeController,
      decoration: InputDecoration(
        labelText: 'Kode Ruangan',
        hintText: 'A101',
        prefixIcon: const Icon(Icons.tag),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      textCapitalization: TextCapitalization.characters,
    );
  }

  Widget _buildFloorField() {
    return TextFormField(
      controller: _floorController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
      ],
      decoration: InputDecoration(
        labelText: 'Lantai',
        hintText: '1',
        prefixIcon: const Icon(Icons.layers),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final floor = int.tryParse(value);
          if (floor == null || floor < 0) {
            return 'Lantai harus angka positif';
          }
        }
        return null;
      },
    );
  }

  Widget _buildBuildingIdField() {
    return TextFormField(
      controller: _buildingIdController,
      decoration: InputDecoration(
        labelText: 'ID Gedung *',
        hintText: 'Pilih atau masukkan ID gedung',
        prefixIcon: const Icon(Icons.business),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: _searchBuilding,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'ID gedung harus diisi';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Deskripsi',
        hintText: 'Deskripsi tentang ruangan ini...',
        prefixIcon: const Icon(Icons.description),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildActionButtons() {
    final _isLoading = ref.watch(loadingProvider);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: MyButton(
            onPressed: _isLoading ? null : _saveRoom,
            text: "Simpan Perubahan",
            variant: ButtonVariant.primary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: MyButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            text: "Batal",
            variant: ButtonVariant.outline,
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final file = await _imageService.pickImage();
    if (file != null) {
      ref.read(localImageProvider.notifier).state = file;
      ref.read(imageUrlProvider.notifier).state = null;
    }
  }

  void _removeImage() {
    ref.read(localImageProvider.notifier).state = null;
    _imageUrlController.clear();
  }

  void _searchBuilding() {
    mySnackbar(context, 'Fitur pencarian gedung akan segera tersedia', Type.warning);
  }

  Future<void> _saveRoom() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final notifier = ref.read(roomNotifierProvider.notifier);
    final imgUrl = ref.read(imageUrlProvider);
    ref.read(loadingProvider.notifier).state = true;

    try {
      await notifier.updateRoom(
        RoomModel(
          buildingId: _buildingIdController.text,
          name: _nameController.text,
          roomCode: _roomCodeController.text,
          description: _descriptionController.text,
          floor: _floorController.text.isNotEmpty ? int.parse(_floorController.text) : null,
          image_url: imgUrl,
          id: widget.room.id
        )
      );

      mySnackbar(
        context,
        'Ruangan berhasil diperbarui',
        Type.success
      );

      Navigator.of(context).pop(true);

    } catch (e) {
      mySnackbar(context, 'Gagal menyimpan: $e', Type.error);
    } finally {
      if (mounted) {
        ref.read(loadingProvider.notifier).state = false;
      }
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Ruangan'),
          content: Text(
            'Apakah Anda yakin ingin menghapus "${widget.room!.name}"? '
                'Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteRoom();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRoom() async {
    final notifier = ref.read(roomNotifierProvider.notifier);

    ref.read(loadingProvider.notifier).state = true;

    try {
      await notifier.deleteRoom(widget.room.id!);

      mySnackbar(context, 'Ruangan berhasil dihapus', Type.success);
      Navigator.of(context).pop(true);
    } catch (e) {
      mySnackbar(context, 'Gagal menghapus: $e', Type.error);
    } finally {
      if (mounted) {
        ref.read(loadingProvider.notifier).state = false;
      }
    }
  }

}