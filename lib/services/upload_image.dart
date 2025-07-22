import 'dart:convert';
import 'dart:io';
import 'package:baber_booking_app/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudinaryService {
  static const String cloudName = 'dkxjsiq62'; // ví dụ: 'khucbaominh'
  static const String uploadPreset = 'image_upload'; // ví dụ: 'unsigned_preset'

  /// Upload image to Cloudinary, return image URL
  static Future<String?> uploadImageToCloudinary(File imageFile) async {
    final uri =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = json.decode(resStr);
      return data['secure_url'];
    } else {
      print("❌ Upload failed with status: ${response.statusCode}");
      return null;
    }
  }

  /// Select image from gallery and upload
  static Future<String?> selectAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print("❌ No image selected");
      return null;
    }

    final file = File(pickedFile.path);
    final imageUrl = await uploadImageToCloudinary(file);

    if (imageUrl != null) {
      await updateUserImage(imageUrl);
      print("✅ Image updated: $imageUrl");
    }

    return imageUrl;
  }

  /// Update Firestore user document
  static Future<void> updateUserImage(String imageUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'Image': imageUrl,
      });
      await SharedPreferenceHelper().saveUserImage(imageUrl);
    }
  }
}
