import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_frontend/src/api/models/image_search_query.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/filters_view_model.dart';

import '../../../../../widgets/painters/filters_icon.dart';
import '../../../../../widgets/painters/photo_icon.dart';
import 'search_input.dart';
import 'side_button.dart';

class SearchBlock extends StatelessWidget {
  final VoidCallback onSearchPhoto;
  final VoidCallback onFiltersTap;
  final FiltersViewModel filtersViewModel;
  final String filtersTitle;
  final void Function(ImageSearchQuery) searchQuery;

  const SearchBlock({
    super.key,
    required this.onSearchPhoto,
    required this.onFiltersTap,
    required this.filtersTitle,
    required this.filtersViewModel,
    required this.searchQuery,
  });

  void joinedSearch(String text) {
    final query = filtersViewModel.makeSearchQuery(text);
    searchQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchInput(
            onSearchTap: joinedSearch,
            isFiltersChosen: filtersViewModel.isFiltersChosen,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SideButton(
          title: filtersTitle,
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
