import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_frontend/src/api/models/full_image.dart';
import 'package:travel_frontend/src/api/models/gallery.dart';
import 'package:travel_frontend/src/api/models/image_search_query.dart';
import 'package:http_parser/http_parser.dart';
import 'package:travel_frontend/src/api/models/uploaded_file_response.dart';

abstract class ApiPath {
  static const upload = 'http://guests.0xb1b1.com:81/upload';
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
      'amount': 150,
      // if (token != null) 'token': token,
    };

    final response = await _dio.get(
      path,
      queryParameters: queryParams,
    );

    return Gallery.fromJson(response.data);
  }

  Future<Gallery> getNeighbors(
    String filename,
    ImageSearchQuery? query,
    int imagesCount,
  ) async {
    final path = '${ApiPath.similar}$filename';
    final queryParams = {
      'amount': imagesCount,
    };

    final data = (query != null) ? query.toJson() : jsonEncode({'text': null});

    final response = await _dio.post(
      path,
      queryParameters: queryParams,
      data: data,
    );

    return Gallery.fromJson(response.data);
  }

  Future<Gallery> search(ImageSearchQuery query, int imagesCount) async {
    const path = ApiPath.search;
    final queryParams = {
      'images_limit': imagesCount,
      'tags_limit': 20,
    };

    final response = await _dio.post(
      path,
      queryParameters: queryParams,
      data: query.toJson(),
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

  Future<UploadedFileResponse> uploadImage(XFile file) async {
    const path = ApiPath.upload;
    final Uri uri = Uri.parse(path);

    final fileBytes = await file.readAsBytes();

    const String contentType = 'image/jpeg';

    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: file.name,
          contentType: MediaType.parse(contentType),
        ),
      );

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    // return UploadedFileResponse.fromJson(jsonDecode(response.body));

    return UploadedFileResponse(images: [], tags: [
      'лето',
      'лето',
      'лето',
      'лето',
      'лето',
      'лето',
      'лето',
      'лето',
      'лето',
      'лето'
    ], filename: 'некоторое');
  }
}
