import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:travel_frontend/src/api/models/s3_urls.dart';

part 'full_image.freezed.dart';

part 'full_image.g.dart';

@freezed
class FullImage with _$FullImage {
  const factory FullImage({
    required String filename,
    @JsonKey(name: 's3_presigned_urls') required S3Urls url,
    required String label,
    required List<String> tags,
    @JsonKey(name: 'view_count') int? viewsCount,
    @JsonKey(name: 'download_count') int? downloadsCount,
  }) = _FullImage;

  factory FullImage.fromJson(Map<String, Object?> json) =>
      _$FullImageFromJson(json);
}
