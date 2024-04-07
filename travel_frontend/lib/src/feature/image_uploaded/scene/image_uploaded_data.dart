import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_frontend/src/widgets/image_gallery/image_gallery_without_buttons.dart';

import '../../../common/app_palette.dart';
import '../../../common/app_typography.dart';
import '../../../widgets/image_gallery/image_tags/image_tags.dart';
import '../../search_page/widgets/search_block/widgets/search_input.dart';

class ImageUploadedData extends StatelessWidget {
  final void Function(String) onImageTap;
  final XFile uploadedImage;

  const ImageUploadedData({
    super.key,
    required this.uploadedImage,
    required this.onImageTap,
  });

  final _photoBlockHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 56,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              color: AppPalette.white,
              border: Border.all(
                color: AppPalette.yellow,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageContainerMode(
                  title: 'Загруженное изображение',
                  onCrossTap: () {},
                ),
                IconButton(
                  color: AppPalette.yellow,
                  icon: const Icon(
                    Icons.search,
                    color: AppPalette.black,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        const SliverToBoxAdapter(
          child: BackButton(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
        SliverToBoxAdapter(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Возможные теги',
                    style: AppTypography.header,
                  ),
                  const SizedBox(height: 16),
                  ImageTags(
                    tags: const [],
                    onTagTap: (_) {},
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      height: _photoBlockHeight,
                      uploadedImage.path,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Похожие изображения',
                      style: AppTypography.header,
                    ),
                    const SizedBox(height: 16),
                    ImageGalleryWithoutButtons(
                      images: const [],
                      crossAxisCount: 2,
                      onImageTap: (_) {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
