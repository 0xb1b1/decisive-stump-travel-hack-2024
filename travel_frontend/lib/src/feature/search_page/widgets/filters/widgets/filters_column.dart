import 'package:flutter/material.dart';
import 'package:travel_frontend/src/common/app_typography.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/filters_section.dart';

import '../../../../../common/app_palette.dart';

class FiltersColumn extends StatelessWidget {
  final FiltersSection filtersSection;
  final void Function(String) onFiltersTap;

  const FiltersColumn({
    super.key,
    required this.filtersSection,
    required this.onFiltersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          filtersSection.title,
          style: AppTypography.filtersTitle,
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: filtersSection.filters
              .map(
                (e) => _FilterItem(
                  title: e.title,
                  checked: e.checked,
                  onCheckboxTap: () => onFiltersTap(e.title),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _FilterItem extends StatelessWidget {
  final bool checked;
  final String title;
  final VoidCallback onCheckboxTap;

  const _FilterItem({
    super.key,
    required this.checked,
    required this.title,
    required this.onCheckboxTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: checked,
          onChanged: (_) => onCheckboxTap.call(),
          activeColor: AppPalette.yellow,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.text.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
