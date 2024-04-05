import 'dart:io';

import 'package:dio/dio.dart';
import 'package:travel_frontend/src/api/models/full_image.dart';
import 'package:travel_frontend/src/api/models/gallery.dart';
import 'package:travel_frontend/src/api/models/image_search_query.dart';

abstract class ApiPath {
  static const uploadImage = 'http://127.0.0.1:8000/img/upload';
  static const getGallery = 'http://backend.0xb1b1.com:81/img/gallery';
  static const getImage = 'http://backend.0xb1b1.com:81/img/get/full/';
  static const search = 'http://backend.0xb1b1.com:81/img/search';
  static const similar = 'http://backend.0xb1b1.com:81/img/neighbors/';
}

class AppApi {
  final Dio _dio;

  const AppApi(this._dio);

  Future<Gallery> getGallery() async {
    const path = ApiPath.getGallery;
    final queryParams = {
      'amount': 400,
      // if (token != null) 'token': token,
    };

    final response = await _dio.get(
      path,
      queryParameters: queryParams,
    );

    return Gallery.fromJson(response.data);
  }

  Future<Gallery> getSimilar(String filename) async {
    final path = '${ApiPath.similar}$filename';
    final queryParams = {
      'amount': 400,
    };

    final response = await _dio.get(
      path,
      queryParameters: queryParams,
    );


    return Gallery.fromJson(response.data);
  }

  Future<Gallery> search(ImageSearchQuery query) async {
    const path = ApiPath.search;
    final queryParams = {
      'images_limit': 100,
      'tags_limit': 20,
    };

    final data = query.toJson();

    final response = await _dio.post(
      path,
      queryParameters: queryParams,
      data: data,
    );

    return Gallery.fromJson(response.data);
  }

  Future<FullImage> getImage(String filename) async {
    final path = '${ApiPath.getImage}$filename';

    final response = await _dio.get(
      path,
    );
    return FullImage.fromJson(response.data);
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
