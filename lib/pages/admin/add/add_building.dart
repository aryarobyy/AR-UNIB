part of 'add.dart';

class AddBuilding extends ConsumerStatefulWidget {
  const AddBuilding({super.key});

  @override
  ConsumerState createState() => _AddBuildingState();
}

class _AddBuildingState extends ConsumerState<AddBuilding> {
  final ImagesService _imageService = ImagesService();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();

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
      BuildingNotifier notifier,
      File? file,
      BuildingState state
      ) async {
    final isLoading = ref.read(loadingProvider);
    if (isLoading) return;

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final longitude = double.parse(_longitudeController.text.trim());
    final latitude = double.parse(_latitudeController.text.trim());

    if (name.isEmpty ||
        description.isEmpty) {
      mySnackbar(context, "Please fill all the fields", Type.error);
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

      await notifier.addBuilding(
        BuildingModel(
          name: name,
          description: description,
          location: GeoPoint(
            latitude,
            longitude
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final currentState = ref.read(buildingNotifierProvider);
      if (currentState.error != null) {
        mySnackbar(context, "Failed to add building: ${currentState.error}", Type.error);
        print('Building notifier error: ${currentState.error}');
        return;
      }

      mySnackbar(context, "Building added successfully", Type.success);

      _clearForm(ref);

      if (mounted) {
        Navigator.pop(context);
      }

    } catch (e) {
      mySnackbar(context, "Failed to add building: $e", Type.error);
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
    _longitudeController.clear();
    _latitudeController.clear();
    ref.read(localImageProvider.notifier).state = null;
    ref.read(imageUrlProvider.notifier).state = null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(buildingNotifierProvider.notifier);
    final File? selectedImage = ref.watch(localImageProvider);
    final state = ref.watch(buildingNotifierProvider);
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Building")),
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
              controller: _longitudeController,
              name: "Longitude",
              inputType: TextInputType.text,
            ),
            MyTextField(
              controller: _latitudeController,
              name: "Latitude",
              inputType: TextInputType.number,
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