import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_frontend/src/common/app_palette.dart';

class SideButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const SideButton({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppPalette.grey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            const SizedBox(width: 8),
            SvgPicture.asset(iconPath),
          ],
        ),
      ),
    );
  }
}
