import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:travel_frontend/src/api/models/gallery_image.dart';

part 'uploaded_file_response.freezed.dart';

part 'uploaded_file_response.g.dart';

@freezed
class UploadedFileResponse with _$UploadedFileResponse {
  const factory UploadedFileResponse({
    required List<GalleryImage> images,
    required List<String> tags,
    required String filename,
  }) = _UploadedFileResponse;

  factory UploadedFileResponse.fromJson(Map<String, Object?> json) =>
      _$UploadedFileResponseFromJson(json);
}
