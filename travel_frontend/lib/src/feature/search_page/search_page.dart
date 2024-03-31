import 'package:flutter/material.dart';

import 'package:travel_frontend/src/common/app_palette.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/menu_button.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/search_input.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/side_button.dart';
import 'package:travel_frontend/widgets/app_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isPressedFirst = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: AppPalette.black,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(250),
            child: ServiceAppBar(),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 108,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppPalette.lightGrey,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPressedFirst = !_isPressedFirst;
                            });
                          },
                          child: MenuButton(
                            text: 'Фотографии',
                            isPressed: _isPressedFirst,
                            path: 'assets/icons/photo.svg',
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Second Button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPressedFirst = !_isPressedFirst;
                            });
                          },
                          child: MenuButton(
                            text: 'AI-генерация',
                            isPressed: !_isPressedFirst,
                            path: 'assets/icons/stars.svg',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        const Expanded(
                          flex: 6,
                          child: SearchInput(),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SideButton(
                            title: 'Cкрыть фильтры',
                            iconPath: 'assets/icons/photo.svg',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SideButton(
                            onTap: () {},
                            title: 'Поиск по изображению',
                            iconPath: 'assets/icons/photo.svg',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
