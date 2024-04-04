// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filters_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FiltersListImpl _$$FiltersListImplFromJson(Map<String, dynamic> json) =>
    _$FiltersListImpl(
      dayTime: FiltersSection.fromJson(json['dayTime'] as Map<String, dynamic>),
      season: FiltersSection.fromJson(json['season'] as Map<String, dynamic>),
      weather: FiltersSection.fromJson(json['weather'] as Map<String, dynamic>),
      atmosphere:
          FiltersSection.fromJson(json['atmosphere'] as Map<String, dynamic>),
      persons: FiltersSection.fromJson(json['persons'] as Map<String, dynamic>),
      orientation:
          FiltersSection.fromJson(json['orientation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FiltersListImplToJson(_$FiltersListImpl instance) =>
    <String, dynamic>{
      'dayTime': instance.dayTime,
      'season': instance.season,
      'weather': instance.weather,
      'atmosphere': instance.atmosphere,
      'persons': instance.persons,
      'orientation': instance.orientation,
    };
