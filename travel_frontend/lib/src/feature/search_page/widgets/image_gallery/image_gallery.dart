import 'package:flutter/material.dart';
import 'package:travel_frontend/image_gallery/widgets/hover_image.dart';

class ImageGallery extends StatelessWidget {
  const ImageGallery({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final items = List.generate(23, (index) => 'sd');

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => const HoverImage(
        title: 'Флекс',
        description: 'База',
      ),
    );
  }
}
