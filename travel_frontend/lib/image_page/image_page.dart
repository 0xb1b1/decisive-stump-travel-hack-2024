import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:travel_frontend/image_page/widgets/image_tag.dart';
import 'package:travel_frontend/src/common/app_contants.dart';
import 'package:travel_frontend/src/common/app_typography.dart';

class ImagePage extends StatelessWidget {
  final String uuid;
  final String title;
  final List<String> tags;
  final List<String> similarItems;
  final int downloaded;
  final int viewed;

  final _photoBlockHeight = 400.0;

  const ImagePage({
    super.key,
    required this.uuid,
    required this.title,
    required this.tags,
    required this.similarItems,
    required this.downloaded,
    required this.viewed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 108,
        vertical: 32,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    height: _photoBlockHeight,
                    'assets/test.png',
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
                              title,
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
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: AppConstants.aspectRatio,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.teal[100 * (index % 9)],
                  ),
                  alignment: Alignment.center,
                  child: Text('Grid Item $index'),
                );
              },
              childCount: similarItems.length,
            ),
          ),
        ],
      ),
    );
  }
}
