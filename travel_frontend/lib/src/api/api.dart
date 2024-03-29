import 'dart:io';

import 'package:dio/dio.dart';

abstract class AppPath {
  static const uploadImage = 'http://127.0.0.1:8000/img/upload';
}

class AppApi {
  final Dio _dio;

  const AppApi(this._dio);

  Future<bool> uploadImage(File file) async {
    const path = AppPath.uploadImage;
    final fileName = file.path.split('/').last;
    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    final response = await _dio.post(path, data: formData);
    return response.statusCode == 200;
  }
}
