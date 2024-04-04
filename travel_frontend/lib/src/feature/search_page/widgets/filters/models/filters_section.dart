import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'color_filter.dart';
import 'filter.dart';

part 'filters_section.freezed.dart';

@Freezed(genericArgumentFactories: true)
class FiltersSection<T> with _$FiltersSection<T> {
  const factory FiltersSection({
    required String title,
    required List<T> filters,
  }) = _FiltersSection<T>;

  static FiltersSection<Filter> get season => FiltersSection<Filter>(
        title: 'Время года',
        filters: [
          Filter.initial(title: 'Лето'),
          Filter.initial(title: 'Осень'),
          Filter.initial(title: 'Зима'),
          Filter.initial(title: 'Весна'),
        ],
      );

  static FiltersSection<Filter> get dayTime => FiltersSection<Filter>(
        title: 'Время суток',
        filters: [
          Filter.initial(title: 'Утро'),
          Filter.initial(title: 'День'),
          Filter.initial(title: 'Вечер'),
          Filter.initial(title: 'Ночь'),
        ],
      );

  static FiltersSection<Filter> get weather => FiltersSection<Filter>(
        title: 'Погода',
        filters: [
          Filter.initial(title: 'Солнечно'),
          Filter.initial(title: 'Облачно'),
          Filter.initial(title: 'Пасмурно'),
          Filter.initial(title: 'Дождь'),
          Filter.initial(title: 'Снег'),
        ],
      );

  static FiltersSection<Filter> get atmosphere => FiltersSection<Filter>(
        title: 'Атмосфера',
        filters: [
          Filter.initial(title: 'Романтическая'),
          Filter.initial(title: 'Официальная'),
          Filter.initial(title: 'Радостная'),
          Filter.initial(title: 'Меланхоличная'),
          Filter.initial(title: 'Нейтральная'),
        ],
      );

  static FiltersSection<Filter> get orientation => FiltersSection<Filter>(
        title: 'Ориентация',
        filters: [
          Filter.initial(title: 'Горизонтальная'),
          Filter.initial(title: 'Вертикальная'),
          Filter.initial(title: 'Квадратная'),
        ],
      );

  static FiltersSection<Filter> get persons => FiltersSection<Filter>(
        title: 'Люди на фото',
        filters: [
          Filter.initial(title: 'Без людей'),
          Filter.initial(title: 'От 1 до 5'),
          Filter.initial(title: 'От 5 до 15'),
          Filter.initial(title: 'От 15'),
        ],
      );

  static FiltersSection<ColorsFilter> get colors =>
      const FiltersSection<ColorsFilter>(
        title: 'Цвет',
        filters: [
          ColorsFilter(
            checked: false,
            title: 'Красный',
            color: _FiltersColor.red,
          ),
          ColorsFilter(
            checked: false,
            title: 'Оранжевый',
            color: _FiltersColor.orange,
          ),
          ColorsFilter(
            checked: false,
            title: 'Желтый',
            color: _FiltersColor.yellow,
          ),
          ColorsFilter(
            checked: false,
            title: 'Зеленый',
            color: _FiltersColor.green,
          ),
          ColorsFilter(
            checked: false,
            title: 'Голубой',
            color: _FiltersColor.lightBlue,
          ),
          ColorsFilter(
            checked: false,
            title: 'Синий',
            color: _FiltersColor.blue,
          ),
          ColorsFilter(
            checked: false,
            title: 'Фиолетовый',
            color: _FiltersColor.purple,
          ),
          ColorsFilter(
            checked: false,
            title: 'Розовый',
            color: _FiltersColor.pink,
          ),
          ColorsFilter(
            checked: false,
            title: 'Белый',
            color: _FiltersColor.white,
          ),
          ColorsFilter(
            checked: false,
            title: 'Серый',
            color: _FiltersColor.grey,
          ),
          ColorsFilter(
            checked: false,
            title: 'Черный',
            color: _FiltersColor.black,
          ),
          ColorsFilter(
            checked: false,
            title: 'Коричневый',
            color: _FiltersColor.brown,
          ),
        ],
      );
}

abstract class _FiltersColor {
  static const red = Color(0xFFFF3000);
  static const orange = Color(0xFFF18638);
  static const yellow = Color(0xFFFFCF08);
  static const green = Color(0xFF67AD5B);
  static const lightBlue = Color(0xFF54B9D1);
  static const blue = Color(0xFF4994EC);
  static const purple = Color(0xFF9031AA);
  static const pink = Color(0xFFD63864);
  static const white = Colors.white;
  static const grey = Color(0xFF9E9E9E);
  static const black = Colors.black;
  static const brown = Color(0xFF594139);
}
