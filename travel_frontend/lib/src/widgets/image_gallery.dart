import 'package:flutter/material.dart';
import 'package:travel_frontend/src/api/models/gallery_image.dart';
import 'package:travel_frontend/src/common/app_contants.dart';

import '../feature/search_page/widgets/hover_image/hover_image.dart';

class ImageGallery extends StatelessWidget {
  final List<GalleryImage> images;
  final int crossAxisCount;
  final bool isHoverEnabled;
  final void Function(String fileName) onImageTap;

  const ImageGallery({
    super.key,
    required this.images,
    required this.crossAxisCount,
    required this.isHoverEnabled,
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
          child: isHoverEnabled
              ? HoverImage(
                  title: images[index].label,
                  description: images[index].tags.join(', '),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.teal[100 * (index % 9)],
                  ),
                  alignment: Alignment.center,
                  child: Text('Grid Item $index'),
                ),
        ),
        childCount: images.length,
      ),
    );
  }
}
