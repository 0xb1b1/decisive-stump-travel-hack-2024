import 'package:flutter/material.dart';
import 'package:travel_frontend/src/common/app_palette.dart';

class BottomAppBar extends StatelessWidget {
  const BottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 108,
        right: 108,
        top: 56,
        bottom: 24,
      ),
      color: AppPalette.black,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [],
          )
        ],
      ),
    );
  }
}
