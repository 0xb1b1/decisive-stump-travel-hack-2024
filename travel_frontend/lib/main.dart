import 'package:flutter/material.dart';
import 'package:travel_frontend/image_page/image_page.dart';
import 'package:travel_frontend/src/common/app_theme.dart';
import 'package:travel_frontend/src/feature/search_page/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel hack',
      theme: AppTheme.defaultTheme,
      home: const Scaffold(
        body: ImagePage(
          uuid: 'dsdsdsdsdsdsdsdsdsdsd',
          title: 'Фотографии на стене висят неподвижно, счастье, радость',
          tags: [
            'Река',
            'Лето',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
          ],
          similarItems: [
            'Река',
            'Лето',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
            'Депрессия',
          ],
          downloaded: 12,
          viewed: 23,
        ),
      ),
    );
  }
}
