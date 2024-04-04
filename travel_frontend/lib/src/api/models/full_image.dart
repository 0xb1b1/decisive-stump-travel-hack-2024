import 'package:freezed_annotation/freezed_annotation.dart';

part 'full_image.freezed.dart';

part 'full_image.g.dart';

@freezed
class FullImage with _$FullImage {
  const factory FullImage({
    required String filename,
    @JsonKey(name: 's3_presigned_url') required String s3PresignedUrl,
    required String label,
    required List<String> tags,
    @JsonKey(name: 'views_count') int? viewsCount,
    @JsonKey(name: 'downloads_count') int? downloadsCount,
  }) = _FullImage;

  factory FullImage.fromJson(Map<String, Object?> json) =>
      _$FullImageFromJson(json);
}
