import 'package:flutter/material.dart';
import 'package:travel_frontend/src/common/app_palette.dart';
import 'package:travel_frontend/src/common/app_typography.dart';

class AppBarInfoBlock extends StatelessWidget {
  const AppBarInfoBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 108),
      color: AppPalette.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'Главная · Проекты и мероприятия · Фотографии',
            style: AppTypography.boldText.copyWith(
              color: const Color(0xFF747474),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Фотографии',
            style: AppTypography.header.copyWith(
              fontSize: 44,
              color: AppPalette.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Наш портал предлагает огромный выбор фотографий высокого качества, подходящих для любых проектов.'
            '\nНайтиде идеальное изображение'
            ' для вашего сайта или рекламной кампании с нами.',
            style: AppTypography.text.copyWith(color: AppPalette.white),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
