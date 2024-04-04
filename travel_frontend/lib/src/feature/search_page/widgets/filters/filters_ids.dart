abstract class SeasonFilter {
  static const summer = 'Лето';
  static const autumn = 'Осень';
  static const winter = 'Зима';
  static const spring = 'Весна';

  static get list => [summer, autumn, winter, spring];
}

abstract class DayTimeFilter {
  static const morning = 'Утро';
  static const day = 'День';
  static const evening = 'Вечер';
  static const night = 'Ночь';

  static get list => [morning, day, evening, night];
}

abstract class WeatherFilter {
  static const sunny = 'Cолнечно';
  static const cloudy = 'Облачно';
  static const dull = 'Пасмурно';
  static const thunder = 'Гроза';
  static const snow = 'Снег';
}
