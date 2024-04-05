import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_search_query.freezed.dart';

part 'image_search_query.g.dart';

@freezed
class ImageSearchQuery with _$ImageSearchQuery {
  const factory ImageSearchQuery({
    String? text,
    @JsonKey(name: 'time_of_day') List<String>? dayTime,
    List<String>? season,
    List<String>? weather,
    List<String>? atmosphere,
    @JsonKey(name: 'number_of_people') List<int>? persons,
    List<String>? orientation,
    @JsonKey(name: 'main_color') List<String>? colors,
    List<String>? tags,
  }) = _ImageSearchQuery;

  factory ImageSearchQuery.fromJson(Map<String, Object?> json) =>
      _$ImageSearchQueryFromJson(json);
}
