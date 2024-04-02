import 'dart:io';

import 'package:dio/dio.dart';
import 'package:travel_frontend/src/api/models/gallery_image.dart';

abstract class ApiPath {
  static const uploadImage = 'http://127.0.0.1:8000/img/upload';
  static const getGallery = 'http://backend.0xb1b1.com:81/img/gallery';
}

class AppApi {
  final Dio _dio;

  const AppApi(this._dio);

  Future<GalleryImage> getGallery() async {
    const path = ApiPath.getGallery;

    final response = await _dio.get(path);
    return response.data;
  }

  Future<bool> uploadImage(File file) async {
    const path = ApiPath.uploadImage;
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
