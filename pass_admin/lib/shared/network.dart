import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pass_admin/pages/upload/image_data.dart';

class Network {
  static Future<Map<String, dynamic>> uploadImage(Uint8List imageData, String fileName) async {
    const String uploadUrl = 'http://backend.0xb1b1.com:81/img/upload';
    final Uri uri = Uri.parse(uploadUrl);

    const String contentType = 'image/jpeg';

    // Create a MultipartRequest to send data to the server
    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imageData,
        filename: fileName,
        contentType: MediaType.parse(contentType),
      ));

    try {
      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      print(response.body);
      print(response.statusCode);

      return json.decode(response.body);
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> checkUpload(String fileName) async {
    const String uploadUrl = 'http://backend.0xb1b1.com:81/img/upload/check';
    final Uri uri = Uri.parse(uploadUrl).replace(queryParameters: {'filename': fileName});

    print(uri.toString());

    final response = await http.get(uri);

    print(response.body);
    print(response.statusCode);

    return json.decode(response.body, reviver: (key, value) {
      if (value is String) {
        return utf8.decode(value.codeUnits); // Specify the correct encoding here
      }
      return value;
    });
  }

  static Future<bool> publish(String fileName, String label, ImageInformation data) async {
    const String uploadUrl = 'http://backend.0xb1b1.com:81/img/publish';
    final Uri uri = Uri.parse(uploadUrl);

    print(uri.toString());

    var bodyMap = data.toMap()..addAll({'filename': fileName, 'label': label});

    print(bodyMap);

    final response = await http.post(uri, body: json.encode(bodyMap));

    print(response.body);
    print(response.statusCode);

    return response.statusCode == 200;
  }

  static Future<bool> checkPublish(String fileName) async {
    const String uploadUrl = 'http://backend.0xb1b1.com:81/img/publish/check';
    final Uri uri = Uri.parse(uploadUrl).replace(queryParameters: {'filename': fileName});

    print(uri.toString());

    final response = await http.get(uri);

    print(response.body);
    print(response.statusCode);

    print('OK');

    return response.statusCode == 200;
  }
}
