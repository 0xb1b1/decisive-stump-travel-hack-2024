import 'package:flutter/material.dart';
import 'package:travel_frontend/src/api/models/gallery_image.dart';
import 'package:travel_frontend/src/common/app_contants.dart';

import 'hover_image/hover_image.dart';

class ImageGalleryWithoutButtons extends StatelessWidget {
  final List<GalleryImage> images;
  final int crossAxisCount;
  final void Function(String fileName) onImageTap;

  const ImageGalleryWithoutButtons({
    super.key,
    required this.images,
    required this.crossAxisCount,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: AppConstants.aspectRatio,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => GestureDetector(
          onTap: () => onImageTap(images[index].filename),
          child: HoverImage(
            image: images[index],
            isButtonsEnabled: false,
            onSimilarTap: () {},
          ),
        ),
        childCount: images.length,
      ),
    );
  }
}
