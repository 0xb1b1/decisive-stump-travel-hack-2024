import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:travel_frontend/image_gallery/widgets/selected_checkbox_widget.dart';
import 'package:travel_frontend/image_gallery/widgets/similar_button.dart';
import 'package:travel_frontend/src/common/app_palette.dart';

class HoverImage extends StatefulWidget {
  final String title;
  final String description;

  const HoverImage({
    super.key,
    required this.title,
    required this.description,
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
      child: SizedBox(
        height: 200,
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/test.png',
                fit: BoxFit.fill,
                color: isHovering
                    ? AppPalette.black.withOpacity(0.1)
                    : Colors.transparent,
                colorBlendMode: BlendMode.darken,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: isHovering
                  ? Colors.black.withOpacity(0.2)
                  : Colors.transparent,
            ),
            if (isHovering) ...[
              const Positioned(
                left: 14,
                top: 14,
                child: CheckboxWidget(),
              ),
              const Positioned(
                right: 8,
                top: 14,
                child: SimilarButton(),
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
                        style: const TextStyle(color: AppPalette.white),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.description,
                        style: const TextStyle(color: AppPalette.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
