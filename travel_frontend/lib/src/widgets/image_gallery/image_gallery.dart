import 'package:flutter/material.dart';
import 'package:travel_frontend/src/api/models/gallery_image.dart';
import 'package:travel_frontend/src/common/app_contants.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/filters_view_model.dart';

import '../../feature/search_page/widgets/filters/models/search_type_state.dart';
import 'hover_image/hover_image.dart';

class ImageGallery extends StatelessWidget {
  final List<GalleryImage> images;
  final int crossAxisCount;
  final bool isButtonsEnabled;
  final void Function(String fileName) onImageTap;
  final FiltersViewModel filtersVm;
  final void Function(SearchTypeState state) searchQuery;

  const ImageGallery({
    super.key,
    required this.images,
    required this.crossAxisCount,
    required this.isButtonsEnabled,
    required this.onImageTap,
    required this.filtersVm,
    required this.searchQuery,
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
            image: images[index],
            isButtonsEnabled: isButtonsEnabled,
            onSimilarTap: () {
              filtersVm.changeModeSimilar(images[index].filename);
              searchQuery(filtersVm.state);
            },
          ),
        ),
        childCount: images.length,
      ),
    );
  }
}
