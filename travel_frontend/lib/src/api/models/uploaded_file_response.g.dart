// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploaded_file_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UploadedFileResponseImpl _$$UploadedFileResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$UploadedFileResponseImpl(
      images: (json['images'] as List<dynamic>)
          .map((e) => GalleryImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      filename: json['filename'] as String,
    );

Map<String, dynamic> _$$UploadedFileResponseImplToJson(
        _$UploadedFileResponseImpl instance) =>
    <String, dynamic>{
      'images': instance.images,
      'tags': instance.tags,
      'filename': instance.filename,
    };
