import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/color_filter.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/widgets/custom_checkbox.dart';

import '../../../../../common/app_palette.dart';
import '../../../../../common/app_typography.dart';
import '../models/filters_section.dart';

class FiltersColorColumn extends StatelessWidget {
  final FiltersSection<ColorsFilter> colorFiltersSection;
  final void Function(String) onColorTap;

  const FiltersColorColumn({
    super.key,
    required this.colorFiltersSection,
    required this.onColorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          colorFiltersSection.title,
          style: AppTypography.filtersTitle,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SizedBox(
            width: 116,
            child: GridView.count(
              crossAxisCount: 6,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: colorFiltersSection.filters
                  .map(
                    (e) => _FiltersColorItem(
                      checked: e.checked,
                      color: e.color,
                      onColorTap: () => onColorTap(e.title),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _FiltersColorItem extends StatelessWidget {
  final bool checked;
  final Color color;
  final VoidCallback onColorTap;

  const _FiltersColorItem({
    super.key,
    required this.checked,
    required this.color,
    required this.onColorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      value: checked,
      onChanged: (_) => onColorTap.call(),
      activeColor: color,
      fillColor: MaterialStatePropertyAll(color),
    );
  }
}
