import 'dart:convert';

class ImageInformation {
  static const yearTimes = ['Лето', 'Осень', 'Зима', 'Весна'];
  static const dayTimes = ['Утро', 'День', 'Вечер', 'Ночь'];
  static const weathers = ['Солнечно', 'Облачно', 'Пасмурно', 'Гроза', 'Снег'];
  static const atmospheres = ['Романтическая', 'Официальная', 'Радостная', 'Меланхоличная', 'Нейтральная'];
  static const peoples = ['Без людей', 'От 1 до 5', 'От 5 до 15', 'От 15'];
  static const colors = [
    'Красный',
    'Оранжевый',
    'Жeлтый',
    'Зеленый',
    'Голубой',
    'Синий',
    'Фиолетовый',
    'Розовый',
    'Белый',
    'Серый',
    'Черный'
  ];

  List<String> tags;
  String yearTime;
  String dayTime;
  String weather;
  String atmosphere;
  String people;
  String color;
  String orientation;
  String landmark;
  bool grayscale;

  ImageInformation({
    required this.tags,
    required this.yearTime,
    required this.dayTime,
    required this.weather,
    required this.atmosphere,
    required this.people,
    required this.color,
    required this.orientation,
    required this.grayscale,
    required this.landmark,
  });

  factory ImageInformation.fromMap(Map<String, dynamic> map) {
    return ImageInformation(
      tags: List<String>.from(map['tags']),
      yearTime: map['season'] ?? '',
      dayTime: map['time_of_day'] ?? '',
      weather: map['weather'] ?? '',
      atmosphere: map['atmosphere'] ?? '',
      people: numToPeople(map['number_of_people'] ?? 0),
      color: map['main_color'] ?? '',
      orientation: map['orientation'] ?? '',
      grayscale: map['grayscale'] ?? false,
      landmark: map['landmark'] ?? '',
    );
  }

  static String numToPeople(int number) {
    switch (number) {
      case 0:
        return 'Без людей';
      case 1:
        return 'От 1 до 5';
      case 2:
        return 'От 5 до 15';
      default:
        return 'От 15';
    }
  }

  static int peopleToNum(String number) {
    switch (number) {
      case 'Без людей':
        return 0;
      case 'От 1 до 5':
        return 1;
      case 'От 5 до 15':
        return 2;
      default:
        return 3;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'tags': tags,
      'season': yearTime.toLowerCase(),
      'time_of_day': dayTime.toLowerCase(),
      'weather': weather.toLowerCase(),
      'atmosphere': atmosphere.toLowerCase(),
      'number_of_people': peopleToNum(people),
      'main_color': color.toLowerCase(),
      'orientation': orientation.toLowerCase(),
      'landmark': landmark.toLowerCase(),
      'grayscale': grayscale,
    };
  }

  String toJson() => json.encode(toMap());

  factory ImageInformation.fromJson(String source) => ImageInformation.fromMap(json.decode(source));
}
