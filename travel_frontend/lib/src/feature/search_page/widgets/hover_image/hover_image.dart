import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:travel_frontend/src/common/app_palette.dart';
import 'package:travel_frontend/src/common/app_typography.dart';

import 'widgets/selected_checkbox_widget.dart';
import 'widgets/similar_button.dart';

class HoverImage extends StatefulWidget {
  final String title;
  final String description;
  final String url;
  final VoidCallback onSimilarTap;
  final bool isButtonsEnabled;

  const HoverImage({
    super.key,
    required this.title,
    required this.description,
    required this.url,
    required this.onSimilarTap,
    required this.isButtonsEnabled,
  });

  @override
  State<HoverImage> createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => isHovering = true),
      onExit: (event) => setState(() => isHovering = false),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.url),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isHovering
                  ? Colors.black.withOpacity(0.55)
                  : Colors.transparent,
            ),
            duration: const Duration(milliseconds: 300),
          ),
          if (isHovering && widget.isButtonsEnabled) ...[
            const Positioned(
              left: 14,
              top: 14,
              child: CheckboxWidget(),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap: widget.onSimilarTap,
                child: const SimilarButton(),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: AppTypography.hoverTitle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      widget.description,
                      style: AppTypography.hoverDescr.copyWith(
                        color: AppPalette.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
