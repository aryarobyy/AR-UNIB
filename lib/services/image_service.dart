import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:ar_unib/component/snackbar.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

const String IMAGE_COLLECTION = "images";

class ImagesService {
  final ImagePicker _picker = ImagePicker();
  late final Cloudinary cloudinary;

  ImagesService() {
    if (dotenv.env['CLOUDINARY_CLOUD_NAME'] == null ||
        dotenv.env['CLOUDINARY_API_KEY'] == null ||
        dotenv.env['CLOUDINARY_API_SECRET'] == null) {
      throw Exception('Cloudinary environment variables not set');
    }
  }

  Future<File?> pickImage() async {
    try {
      XFile? pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 70
      );
      if (pickedImage == null) {
        throw Exception("Gambar tidak boleh kosong");
      }

      File imageFile = File(pickedImage.path);
      if (!await imageFile.exists()) {
        throw Exception("File tidak ditemukan");
      }

      final uuid = const Uuid().v4();
      final String extension = path.extension(pickedImage.path);
      final String newFileName = '$uuid$extension';
      final Directory tempDir = await getTemporaryDirectory();
      final String newPath = path.join(tempDir.path, newFileName);
      final File newImageFile = await imageFile.copy(newPath);

      return newImageFile;
    } catch (e) {
      print('Error picking image: $e');
    }
    return null;
  }

  Future<String?> uploadImage(BuildContext context, File? pickedImage) async {
    try {
      if (pickedImage == null) {
        mySnackbar(context, "No image selected.", Type.warning);
        return null;
      }

      File imageFile = File(pickedImage.path);
      if (!await imageFile.exists()) {
        mySnackbar(context, "File does not exist.", Type.error);
        return null;
      }

      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
      final apiKey = dotenv.env['CLOUDINARY_API_KEY'];
      final apiSecret = dotenv.env['CLOUDINARY_API_SECRET'];

      if (cloudName == null || apiKey == null || apiSecret == null) {
        mySnackbar(context, "Cloudinary configuration missing.", Type.error);
        return null;
      }

      final uuid = const Uuid().v4();
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final folder = 'ar-unib';

      final signature = generateUploadSignature(uuid, timestamp, folder, apiSecret);

      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      var request = http.MultipartRequest('POST', uri)
        ..fields['public_id'] = uuid
        ..fields['timestamp'] = timestamp.toString()
        ..fields['api_key'] = apiKey
        ..fields['signature'] = signature
        ..fields['folder'] = folder
        ..files.add(
          await http.MultipartFile.fromPath(
            'file',
            imageFile.path,
            filename: '$uuid.jpg',
          ),
        );

      print("Uploading to: $uri");
      print("Public ID: $uuid");
      print("Folder: $folder");
      print("Timestamp: $timestamp");
      print("API Key: $apiKey");
      print("Signature: $signature");
      print("String to sign should include folder");

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      print("Upload response status: ${response.statusCode}");
      print("Upload response body: $responseData");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseData);
        final imageUrl = jsonResponse['secure_url'] as String?;

        if (imageUrl != null) {
          mySnackbar(context, "Image uploaded successfully!", Type.success);
          print("Uploaded Image URL: $imageUrl");
          return imageUrl;
        } else {
          mySnackbar(context, "Failed to get image URL.", Type.error);
          return null;
        }
      } else {
        mySnackbar(context, "Image upload failed.", Type.error);
        print("Cloudinary upload error: ${response.statusCode} - ${response.reasonPhrase}");
        print("Response body: $responseData");
        return null;
      }
    } catch (e) {
      mySnackbar(context, "Upload failed: $e", Type.error);
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<bool> deleteImage(BuildContext context, String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      String publicId;
      if (pathSegments.length >= 8) {
        final folder = pathSegments[7]; // ar-unib
        final filename = pathSegments[8].split('.').first;
        publicId = '$folder/$filename';
      } else {
        publicId = pathSegments.last.split('.').first;
      }

      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
      final apiKey = dotenv.env['CLOUDINARY_API_KEY'];
      final apiSecret = dotenv.env['CLOUDINARY_API_SECRET'];

      if (cloudName == null || apiKey == null || apiSecret == null) {
        mySnackbar(context, "Cloudinary configuration missing.", Type.error);
        print("Missing delete environment variables:");
        print("CLOUDINARY_CLOUD_NAME: $cloudName");
        print("CLOUDINARY_API_KEY: $apiKey");
        print("CLOUDINARY_API_SECRET: ${apiSecret != null ? '[SET]' : 'null'}");
        return false;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final signature = generateDeleteSignature(publicId, timestamp, apiSecret);

      print("Deleting image with public_id: $publicId");

      final deleteUri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/destroy');

      final response = await http.post(
        deleteUri,
        body: {
          'public_id': publicId,
          'api_key': apiKey,
          'timestamp': timestamp.toString(),
          'signature': signature,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['result'] == 'ok') {
          mySnackbar(context, "Image deleted successfully!", Type.success);
          return true;
        } else {
          mySnackbar(context, "Failed to delete image: ${jsonResponse['result']}", Type.error);
          return false;
        }
      } else {
        mySnackbar(context, "Failed to delete image.", Type.error);
        print("Cloudinary delete error: ${response.statusCode} - ${response.reasonPhrase}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      mySnackbar(context, "Delete failed: $e", Type.error);
      print('Error deleting image: $e');
      return false;
    }
  }

  String generateUploadSignature(String publicId, int timestamp, String folder, String apiSecret) {
    List<String> params = [];

    params.add('folder=$folder');
    params.add('public_id=$publicId');
    params.add('timestamp=$timestamp');

    params.sort();

    final paramString = params.join('&') + apiSecret;
    print("String to sign: $paramString");

    final bytes = utf8.encode(paramString);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }

  String generateDeleteSignature(String publicId, int timestamp, String apiSecret) {
    final params = 'public_id=$publicId&timestamp=$timestamp$apiSecret';
    final bytes = utf8.encode(params);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }
}