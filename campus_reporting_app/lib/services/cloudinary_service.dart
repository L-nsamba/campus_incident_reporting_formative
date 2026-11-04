import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'kyazyt6i';
  static const String uploadPreset = 'campus_incidents';

  Future<String> uploadImage(File image) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    final result = jsonDecode(responseBody);

    if (response.statusCode == 200) {
      return result['secure_url'];
    }

    final errorMessage = result['error']?['message'] ?? 'Image upload failed';

    throw Exception(errorMessage);
  }
}
