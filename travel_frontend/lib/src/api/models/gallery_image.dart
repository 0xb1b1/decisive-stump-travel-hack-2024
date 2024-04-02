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
            'https://www.marthastewart.com/thmb/g-FunKfdiZombJQ7pB4wb8BF4C8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/cat-kitten-138468381-4cd82b91d7be45cb9f9aa8366e10bce4.jpg',
        label: 'Милый котик <3',
        tags: ['Любовь', 'Малыш', 'Счастье'],
      );
}
