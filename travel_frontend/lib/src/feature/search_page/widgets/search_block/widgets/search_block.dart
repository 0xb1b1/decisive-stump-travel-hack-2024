import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../widgets/painters/filters_icon.dart';
import '../../../../../widgets/painters/photo_icon.dart';
import 'search_input.dart';
import 'side_button.dart';

class SearchBlock extends StatelessWidget {
  final VoidCallback onSearchPhoto;
  final VoidCallback onFiltersTap;
  final bool isFiltersChosen;

  const SearchBlock({
    super.key,
    required this.onSearchPhoto,
    required this.onFiltersTap,
    required this.isFiltersChosen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchInput(
            onSearchTap: () {},
            isFiltersChosen: isFiltersChosen,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SideButton(
          title: 'Cкрыть фильтры',
          icon: CustomPaint(
            size: const Size(18, 14),
            painter: FiltersPainter(),
          ),
          onTap: onFiltersTap,
        ),
        const SizedBox(width: 8),
        SideButton(
          onTap: onSearchPhoto,
          title: 'Поиск по изображению',
          icon: CustomPaint(
            size: const Size(20, 17),
            painter: PhotoPainter(),
          ),
        ),
      ],
    );
  }
}
