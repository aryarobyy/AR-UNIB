part of 'add.dart';

class AddBuilding extends ConsumerStatefulWidget {

  const AddBuilding({
    super.key
  });

  @override
  ConsumerState createState() => _AddBuildingState();
}

class _AddBuildingState extends ConsumerState<AddBuilding> {
  final ImagesService _imageService = ImagesService();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _imageUrlController = TextEditingController();
  late StateController<File?> _localImageNotifier;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    ref.invalidate(localImageProvider);
    super.deactivate();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: MyAppbar(
          title: 'Tambahkan Gedung'
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
              _buildDescriptionField(),
              const SizedBox(height: 24),

              Text(
                'Lokasi',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildLatitudeField()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildLongitudeField()),
                ],
              ),
              const SizedBox(height: 8),
              _buildLocationHelper(),
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
                : SizedBox.expand(child: _buildImagePlaceholder()),

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
          if (selectedImage != null)
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
        labelText: 'Nama Gedung *',
        hintText: 'Contoh: Gedung Rektorat',
        prefixIcon: const Icon(Icons.business),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama gedung harus diisi';
        }
        if (value.trim().length < 3) {
          return 'Nama gedung minimal 3 karakter';
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
        hintText: 'Deskripsi tentang gedung ini...',
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

  Widget _buildLatitudeField() {
    return TextFormField(
      controller: _latitudeController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Latitude',
        hintText: '-3.789731',
        prefixIcon: const Icon(Icons.location_on),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final lat = double.tryParse(value);
          if (lat == null) {
            return 'Format tidak valid';
          }
          if (lat < -90 || lat > 90) {
            return 'Harus -90 hingga 90';
          }
        }
        return null;
      },
    );
  }

  Widget _buildLongitudeField() {
    return TextFormField(
      controller: _longitudeController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Longitude',
        hintText: '89.261688',
        prefixIcon: const Icon(Icons.location_on),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final lng = double.tryParse(value);
          if (lng == null) {
            return 'Format tidak valid';
          }
          if (lng < -90 || lng > 90) {
            return 'Harus -90 hingga 90';
          }
        }
        return null;
      },
    );
  }

  Widget _buildLocationHelper() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.blue[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tips: Gunakan Google Maps untuk mendapatkan koordinat yang akurat',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[700],
              ),
            ),
          ),
          TextButton(
            onPressed: _getCurrentLocation,
            child: Text(
              'Lokasi Saat Ini',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
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
            onPressed: _isLoading ? null : _saveBuilding,
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

  Future<void> _getCurrentLocation() async {
    mySnackbar(context, 'Fitur lokasi saat ini akan segera tersedia', Type.warning);
  }

  Future<void> _saveBuilding() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final notifier = ref.read(buildingNotifierProvider.notifier);
    final imgUrl = ref.read(imageUrlProvider);
    ref.read(loadingProvider.notifier).state = true;

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final longitude = double.parse(_longitudeController.text.trim());
    final latitude = double.parse(_latitudeController.text.trim());
    final id = Uuid().v4();

    try {
      await notifier.addBuilding(
          BuildingModel(
            id: id,
            name: name,
            description: description,
            imageUrl: imgUrl,
            location: GeoPoint(
                latitude,
                longitude
            ),
          )
      );

      mySnackbar(
        context,
        'Gedung berhasil diperbarui',
        Type.success,
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
}