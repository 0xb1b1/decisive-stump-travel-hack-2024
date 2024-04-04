// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filters_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FiltersSectionImpl _$$FiltersSectionImplFromJson(Map<String, dynamic> json) =>
    _$FiltersSectionImpl(
      title: json['title'] as String,
      filters: (json['filters'] as List<dynamic>)
          .map((e) => Filter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$FiltersSectionImplToJson(
        _$FiltersSectionImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'filters': instance.filters,
    };
