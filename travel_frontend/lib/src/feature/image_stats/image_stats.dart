import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:travel_frontend/src/api/models/gallery_image.dart';

import 'package:travel_frontend/src/common/app_typography.dart';
import 'package:travel_frontend/src/common/assets_provider.dart';
import 'package:travel_frontend/src/feature/image_stats/widgets/image_tag.dart';
import 'package:travel_frontend/src/widgets/image_gallery.dart';
import 'package:travel_frontend/src/widgets/page_container.dart';

class ImageStats extends StatelessWidget {
  final String filename;

  // final String title;
  final List<String> tags = ['лето', 'cолнце', 'жара'];

  // final List<String> similarItems;
  // final int downloaded;
  // final int viewed;

  final _photoBlockHeight = 400.0;

  ImageStats({
    super.key,
    required this.filename,
    // required this.title,
    // required this.tags,
    // required this.similarItems,
    // required this.downloaded,
    // required this.viewed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AssetsProvider.appBar,
        preferredSize: const Size.fromHeight(74),
      ),
      body: PageContainer(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            SliverToBoxAdapter(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      height: _photoBlockHeight,
                      'assets/test.jpg',
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
                              const AutoSizeText(
                                'тайтлвывывывывыв',
                                style: AppTypography.header,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    tags.map((e) => ImageTag(tag: e)).toList(),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Cкачать'),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: AutoSizeText(
                                  'Текст про лицензионные соглашения оыоваыра выоарлывра аоыраыа раоырара арывоалры',
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
            ImageGallery(
              images: List.generate(
                10,
                (index) => GalleryImage.mock(),
              ),
              crossAxisCount: 4,
              isHoverEnabled: false,
              onImageTap: (_) {},
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
