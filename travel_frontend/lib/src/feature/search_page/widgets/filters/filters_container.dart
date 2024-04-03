import 'package:flutter/material.dart';

import '../../../../common/app_palette.dart';

class FiltersContainer extends StatelessWidget {
  const FiltersContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppPalette.grey,
      ),
      padding: const EdgeInsets.all(24),
      height: 190,
      child: const Center(child: Text('Dropdown Content')),
    );
  }
}
