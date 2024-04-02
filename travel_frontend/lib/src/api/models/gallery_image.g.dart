// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GalleryImageImpl _$$GalleryImageImplFromJson(Map<String, dynamic> json) =>
    _$GalleryImageImpl(
      filename: json['filename'] as String,
      s3PresignedUrl: json['s3_presigned_url'] as String,
      label: json['label'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$GalleryImageImplToJson(_$GalleryImageImpl instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      's3_presigned_url': instance.s3PresignedUrl,
      'label': instance.label,
      'tags': instance.tags,
    };
