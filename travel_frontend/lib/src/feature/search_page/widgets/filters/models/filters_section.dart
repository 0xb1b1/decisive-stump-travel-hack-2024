import 'package:freezed_annotation/freezed_annotation.dart';

import 'filter.dart';

part 'filters_section.freezed.dart';

part 'filters_section.g.dart';

@freezed
class FiltersSection with _$FiltersSection {
  const factory FiltersSection({
    required String title,
    required List<Filter> filters,
  }) = _FiltersSection;

  factory FiltersSection.season() => FiltersSection(
        title: 'Время года',
        filters: [
          Filter.initial(title: 'Лето'),
          Filter.initial(title: 'Осень'),
          Filter.initial(title: 'Зима'),
          Filter.initial(title: 'Весна'),
        ],
      );

  factory FiltersSection.dayTime() => FiltersSection(
        title: 'Время суток',
        filters: [
          Filter.initial(title: 'Утро'),
          Filter.initial(title: 'День'),
          Filter.initial(title: 'Вечер'),
          Filter.initial(title: 'Ночь'),
        ],
      );

  factory FiltersSection.weather() => FiltersSection(
        title: 'Погода',
        filters: [
          Filter.initial(title: 'Солнечно'),
          Filter.initial(title: 'Облачно'),
          Filter.initial(title: 'Пасмурно'),
          Filter.initial(title: 'Дождь'),
          Filter.initial(title: 'Снег'),
        ],
      );

  factory FiltersSection.atmosphere() => FiltersSection(
        title: 'Атмосфера',
        filters: [
          Filter.initial(title: 'Романтическая'),
          Filter.initial(title: 'Официальная'),
          Filter.initial(title: 'Радостная'),
          Filter.initial(title: 'Меланхоличная'),
          Filter.initial(title: 'Нейтральная'),
        ],
      );

  factory FiltersSection.orientation() => FiltersSection(
        title: 'Ориентация',
        filters: [
          Filter.initial(title: 'Горизонтальная'),
          Filter.initial(title: 'Вертикальная'),
          Filter.initial(title: 'Квадратная'),
        ],
      );

  factory FiltersSection.persons() => FiltersSection(
        title: 'Люди на фото',
        filters: [
          Filter.initial(title: 'Без людей'),
          Filter.initial(title: 'От 1 до 5'),
          Filter.initial(title: 'От 5 до 15'),
          Filter.initial(title: 'От 15'),
        ],
      );

  factory FiltersSection.fromJson(Map<String, Object?> json) =>
      _$FiltersSectionFromJson(json);
}
