import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_frontend/src/api/models/full_image.dart';
import 'package:travel_frontend/src/api/models/gallery.dart';
import 'package:travel_frontend/src/common/app_palette.dart';
import 'package:travel_frontend/src/feature/image_stats/widgets/download_row.dart';

import 'package:travel_frontend/src/widgets/image_gallery/image_tags/image_tags.dart';

import '../../../common/app_typography.dart';
import '../../../widgets/image_gallery/image_gallery.dart';
import '../../../widgets/image_gallery/image_gallery_without_buttons.dart';

class ImageStatsData extends StatelessWidget {
  final FullImage image;
  final Gallery similarImages;
  final void Function(String, String) onDownloadTap;
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
        const SliverToBoxAdapter(
          child: Row(
            children: [
              BackButton(),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
        SliverToBoxAdapter(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  height: _photoBlockHeight,
                  image.url.thumb,
                  fit: BoxFit.fill,
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
                      DownloadRow(
                        onTap: () =>
                            onDownloadTap(image.url.normal, image.filename),
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
        ImageGalleryWithoutButtons(
          images: similarImages.images,
          crossAxisCount: 4,
          onImageTap: onImageTap,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}
