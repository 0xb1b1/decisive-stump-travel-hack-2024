import 'package:flutter/material.dart';

import '../common/app_palette.dart';

class PageContainer extends StatelessWidget {
  final Widget child;

  const PageContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 108,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: AppPalette.lightGrey,
      ),
      child: child,
    );
  }
}
