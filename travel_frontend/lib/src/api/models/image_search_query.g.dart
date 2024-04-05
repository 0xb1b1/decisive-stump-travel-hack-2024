// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_search_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImageSearchQueryImpl _$$ImageSearchQueryImplFromJson(
        Map<String, dynamic> json) =>
    _$ImageSearchQueryImpl(
      text: json['text'] as String?,
      dayTime: (json['time_of_day'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      season:
          (json['season'] as List<dynamic>?)?.map((e) => e as String).toList(),
      weather:
          (json['weather'] as List<dynamic>?)?.map((e) => e as String).toList(),
      atmosphere: (json['atmosphere'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      persons: (json['number_of_people'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      orientation: (json['orientation'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      colors: (json['main_color'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ImageSearchQueryImplToJson(
        _$ImageSearchQueryImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'time_of_day': instance.dayTime,
      'season': instance.season,
      'weather': instance.weather,
      'atmosphere': instance.atmosphere,
      'number_of_people': instance.persons,
      'orientation': instance.orientation,
      'main_color': instance.colors,
      'tags': instance.tags,
    };
