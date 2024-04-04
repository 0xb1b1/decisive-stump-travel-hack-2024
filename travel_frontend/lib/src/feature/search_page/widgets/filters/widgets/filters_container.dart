import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/filters_view_model.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/widgets/filters_column.dart';

import '../../../../../common/app_palette.dart';
import '../models/filters_list.dart';

class FiltersContainer extends StatelessWidget {
  final FiltersList filtersList;
  final FiltersViewModel filtersViewModel;

  const FiltersContainer({
    super.key,
    required this.filtersList,
    required this.filtersViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppPalette.grey,
      ),
      padding: const EdgeInsets.all(24),
      height: 236,
      child: Row(
        children: [
          Expanded(
            child: FiltersColumn(
              filtersSection: filtersList.season,
              onFiltersTap: filtersViewModel.checkDayTime,
            ),
          ),
          Expanded(
            child: FiltersColumn(
              filtersSection: filtersList.dayTime,
              onFiltersTap: (_) {},
            ),
          ),
          Expanded(
            child: FiltersColumn(
              filtersSection: filtersList.weather,
              onFiltersTap: (_) {},
            ),
          ),
          Expanded(
            child: FiltersColumn(
              filtersSection: filtersList.atmosphere,
              onFiltersTap: (_) {},
            ),
          ),
          Expanded(
            child: FiltersColumn(
              filtersSection: filtersList.persons,
              onFiltersTap: (_) {},
            ),
          ),
          Expanded(
            child: FiltersColumn(
              filtersSection: filtersList.orientation,
              onFiltersTap: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
