import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:travel_frontend/src/api/models/full_image.dart';
import 'package:travel_frontend/src/api/models/gallery.dart';
import 'package:travel_frontend/src/widgets/image_gallery/image_tags/image_tags.dart';

import '../../../common/app_typography.dart';
import '../../../widgets/image_gallery/image_gallery.dart';

class ImageStatsData extends StatelessWidget {
  final FullImage image;
  final Gallery similarImages;
  final void Function(String) onDownloadTap;
  final void Function(String) onImageTap;
  final void Function(String) onTagTap;

  const ImageStatsData({
    super.key,
    required this.image,
    required this.onDownloadTap,
    required this.similarImages,
    required this.onImageTap,
    required this.onTagTap,
  });

  final _photoBlockHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
        SliverToBoxAdapter(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    height: _photoBlockHeight,
                    image.url.thumb,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: SizedBox(
                  height: _photoBlockHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoSizeText(
                            image.label,
                            style: AppTypography.header,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          ImageTags(
                            tags: image.tags,
                            onTagTap: onTagTap,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => onDownloadTap(image.url.normal),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 58),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.yellow,
                              ),
                              child: const Text(
                                'Cкачать',
                                style: AppTypography.boldText,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: AutoSizeText(
                              'Обратите внимание на ограничения использования, установленные Лицензионным соглашением.',
                              style: AppTypography.text,
                              maxLines: 4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40),
              Text(
                'Похожие изображения',
                style: AppTypography.header,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        //TODO похожие изображения
        // ImageGallery(
        //   images: similarImages.images,
        //   crossAxisCount: 2,
        //   isButtonsEnabled: false,
        //   onImageTap: onImageTap,
        // ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}
