// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FullImageImpl _$$FullImageImplFromJson(Map<String, dynamic> json) =>
    _$FullImageImpl(
      filename: json['filename'] as String,
      s3PresignedUrl: json['s3_presigned_url'] as String,
      label: json['label'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      viewsCount: json['views_count'] as int?,
      downloadsCount: json['downloads_count'] as int?,
    );

Map<String, dynamic> _$$FullImageImplToJson(_$FullImageImpl instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      's3_presigned_url': instance.s3PresignedUrl,
      'label': instance.label,
      'tags': instance.tags,
      'views_count': instance.viewsCount,
      'downloads_count': instance.downloadsCount,
    };
