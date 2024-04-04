import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_frontend/core/view_model_widget.dart';
import 'package:travel_frontend/src/common/app_palette.dart';
import 'package:travel_frontend/src/common/assets_provider.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/filters_providers.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/search_block/dropdown_search_block.dart';

import 'package:travel_frontend/src/feature/search_page_providers.dart';
import 'package:travel_frontend/src/feature/search_page/search_page_view_model.dart';
import 'package:travel_frontend/src/widgets/image_gallery.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/search_block/widgets/search_block.dart';
import 'package:travel_frontend/src/widgets/page_container.dart';

import '../../widgets/painters/full_app_bar.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(searchViewModelProvider);
    final filtersVm = ref.watch(filtersViewModelProvider);

    return ViewModelWidget<SearchPageViewModel>(
      model: vm,
      builder: (
        BuildContext context,
        SearchPageViewModel vm,
        Widget? child,
      ) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverAppBar(
                pinned: false,
                expandedHeight: 324.0,
                flexibleSpace: FlexibleSpaceBar(
                  // background: AssetsProvider.fullAppBar,
                  background: CustomPaint(
                    size: const Size(double.infinity, 324),
                    painter: Painter(),
                  ),
                ),
              ),
            ],
            body: PageContainer(
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 56),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        DropdownSearchBlock(
                          onFiltersTap: vm.changeGallery,
                          onSearchPhoto: vm.pickImage,
                          filtersViewModel: filtersVm,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  vm.state.when(
                    data: (images) => ImageGallery(
                      images: images,
                      crossAxisCount: 4,
                      isHoverEnabled: true,
                      onImageTap: vm.onImageTap,
                    ),
                    loading: () => const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        width: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    error: () => const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        width: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 56),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
