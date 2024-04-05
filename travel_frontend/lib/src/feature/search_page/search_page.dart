import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_frontend/core/view_model_widget.dart';
import 'package:travel_frontend/src/common/app_palette.dart';
import 'package:travel_frontend/src/common/app_typography.dart';
import 'package:travel_frontend/src/common/assets_provider.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/app_bar_info_block.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/filters_providers.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/search_block/dropdown_search_block.dart';

import 'package:travel_frontend/src/feature/search_page_providers.dart';
import 'package:travel_frontend/src/feature/search_page/search_page_view_model.dart';
import 'package:travel_frontend/src/widgets/image_gallery/image_gallery.dart';
import 'package:travel_frontend/src/widgets/page_container.dart';

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
          backgroundColor: AppPalette.black,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(74),
            child: Container(
              color: AppPalette.black,
              padding: const EdgeInsets.symmetric(
                horizontal: 108,
              ),
              child: AssetsProvider.appBar,
            ),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_, __) => [
              const SliverAppBar(
                shadowColor: AppPalette.black,
                surfaceTintColor: AppPalette.black,
                backgroundColor: AppPalette.black,
                toolbarHeight: 0,
                collapsedHeight: 0.1,
                pinned: false,
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: AppBarInfoBlock(),
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
                          onFiltersTap: () {},
                          onSearchPhoto: vm.pickImage,
                          filtersViewModel: filtersVm,
                          search: vm.search,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  vm.state.when(
                    data: (images) => ImageGallery(
                      images: images,
                      crossAxisCount: 4,
                      isButtonsEnabled: true,
                      onImageTap: vm.onImageTap,
                    ),
                    loading: () => const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        width: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppPalette.yellow,
                          ),
                        ),
                      ),
                    ),
                    error: () => SliverToBoxAdapter(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppPalette.yellow.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        height: 236,
                        width: 200,
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            'Произошла ошибка, \nпроверьте ваше интернет-соединение и повторите попытку',
                            style:
                                AppTypography.boldText.copyWith(fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                    empty: () => SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(76),
                        child: Column(
                          children: [
                            AssetsProvider.empty,
                            const SizedBox(height: 64),
                            Text(
                              'Извините, ничего не нашлось',
                              style:
                                  AppTypography.boldText.copyWith(fontSize: 24),
                            ),
                            const SizedBox(height: 4),
                            const AutoSizeText(
                              'Измените, пожалуйста, фильтры или запрос и попробуйте еще раз',
                              maxLines: 3,
                              style: AppTypography.text,
                            ),
                          ],
                        ),
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
