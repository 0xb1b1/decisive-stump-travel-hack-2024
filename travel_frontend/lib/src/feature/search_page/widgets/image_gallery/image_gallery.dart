import 'package:flutter/material.dart';
import 'package:travel_frontend/src/common/app_contants.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/image_gallery/widgets/hover_image.dart';

class ImageGallery extends StatelessWidget {
  final List<String> images;

  const ImageGallery({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final items = List.generate(23, (index) => 'sd');

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: AppConstants.aspectRatio,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => const HoverImage(
          title: 'Флекс',
          description: 'База',
        ),
        childCount: items.length,
      ),
    );
  }
}
