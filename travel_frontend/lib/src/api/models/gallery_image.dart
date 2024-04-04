import 'package:freezed_annotation/freezed_annotation.dart';

part 'gallery_image.freezed.dart';

part 'gallery_image.g.dart';

@freezed
class GalleryImage with _$GalleryImage {
  const factory GalleryImage({
    required String filename,
    @JsonKey(name: 's3_presigned_url') required String s3PresignedUrl,
    required String label,
    required List<String> tags,
  }) = _GalleryImage;

  factory GalleryImage.fromJson(Map<String, Object?> json) =>
      _$GalleryImageFromJson(json);

  factory GalleryImage.mock() => const GalleryImage(
        filename: 'ARTPLAY_3.jpeg',
        s3PresignedUrl:
            'https://img.freepik.com/free-photo/the-adorable-illustration-of-kittens-playing-in-the-forest-generative-ai_260559-483.jpg?size=338&ext=jpg&ga=GA1.1.632798143.1712188800&semt=ais',
        label: 'Милый котик <3',
        tags: ['Любовь', 'Малыш', 'Счастье'],
      );
}
