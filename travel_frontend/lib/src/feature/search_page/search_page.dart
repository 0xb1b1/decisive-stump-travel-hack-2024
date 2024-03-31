import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:travel_frontend/src/common/app_palette.dart';
import 'package:travel_frontend/src/common/assets_provider.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/image_gallery/image_gallery.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/search_block/search_block.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.black,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: false,
            expandedHeight: 324.0,
            flexibleSpace:
                FlexibleSpaceBar(background: AssetsProvider.fullAppBar),
          ),
        ],
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 108,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppPalette.lightGrey,
          ),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(height: 56),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SearchBlock(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              ImageGallery(
                images: List.generate(23, (index) => 'Some'),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 56),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
