import 'package:flutter/material.dart';
import 'package:travel_frontend/src/api/models/gallery_image.dart';

import 'package:travel_frontend/src/common/app_palette.dart';
import 'package:travel_frontend/src/common/app_typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../utils/utils.dart';
import 'widgets/selected_checkbox_widget.dart';
import 'widgets/similar_button.dart';

class HoverImage extends StatefulWidget {
  final GalleryImage image;
  final VoidCallback onSimilarTap;
  final bool isButtonsEnabled;

  const HoverImage({
    super.key,
    required this.image,
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
          CachedNetworkImage(
            imageUrl: widget.image.url.thumb,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => const CircularProgressIndicator(
              color: AppPalette.lightGrey,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
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
                      widget.image.label,
                      style: AppTypography.hoverTitle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      Utils.makeUpperStr(widget.image.tags),
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
