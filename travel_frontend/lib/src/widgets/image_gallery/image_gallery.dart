import 'package:flutter/material.dart';
import 'package:travel_frontend/src/api/models/gallery_image.dart';
import 'package:travel_frontend/src/common/app_contants.dart';

import 'hover_image/hover_image.dart';

class ImageGallery extends StatelessWidget {
  final List<GalleryImage> images;
  final int crossAxisCount;
  final bool isButtonsEnabled;
  final void Function(String fileName) onImageTap;

  const ImageGallery({
    super.key,
    required this.images,
    required this.crossAxisCount,
    required this.isButtonsEnabled,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    // final image = [
    //   GalleryImage(
    //     filename: 'кастом',
    //     s3PresignedUrl:
    //         'https://ir.ozone.ru/s3/multimedia-z/c1000/6744654071.jpg',
    //     label: 'что-то',
    //     tags: ['кто-то'],
    //   ),
    // ];

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
            title: images[index].label,
            tags: images[index].tags,
            url: images[index].url.thumb,
            isButtonsEnabled: isButtonsEnabled,
            onSimilarTap: () {},
          ),
        ),
        childCount: images.length,
      ),
    );
  }
}
