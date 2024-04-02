import 'package:flutter/material.dart';
import 'package:travel_frontend/src/common/assets_provider.dart';

import 'search_input.dart';
import 'side_button.dart';

class SearchBlock extends StatelessWidget {
  final VoidCallback onSearchPhoto;
  final VoidCallback onFiltersTap;

  const SearchBlock({
    super.key,
    required this.onSearchPhoto,
    required this.onFiltersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          flex: 4,
          child: SearchInput(),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: SideButton(
            title: 'Cкрыть фильтры',
            icon: AssetsProvider.cross,
            onTap: onFiltersTap,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SideButton(
            onTap: onSearchPhoto,
            title: 'Поиск по изображению',
            icon: AssetsProvider.photo,
          ),
        ),
      ],
    );
  }
}
