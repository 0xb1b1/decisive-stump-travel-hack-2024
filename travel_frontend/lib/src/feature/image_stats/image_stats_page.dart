import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_frontend/core/view_model_widget.dart';
import 'package:travel_frontend/src/common/app_palette.dart';

import 'package:travel_frontend/src/common/assets_provider.dart';
import 'package:travel_frontend/src/feature/image_stats/image_stats_provider.dart';
import 'package:travel_frontend/src/feature/image_stats/scene/image_stats_data.dart';
import 'package:travel_frontend/src/widgets/page_container.dart';

import '../../navigation/routes.dart';
import 'image_stats_view_model.dart';

class ImageStats extends ConsumerWidget {
  const ImageStats({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filename = componentArg0f<String>(
      context,
      RoutesArgs.filename,
    );

    final vm = ref.watch(imageStatsViewModelProvider(filename!));

    return ViewModelWidget<ImageStatsViewModel>(
      model: vm,
      builder: (
        BuildContext context,
        ImageStatsViewModel vm,
        Widget? child,
      ) {
        return Scaffold(
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
          body: PageContainer(
            child: vm.state.when(
              data: (image, gallery) => ImageStatsData(
                image: image,
                similarImages: gallery,
                onDownloadTap: (_) {},
                onImageTap: vm.onImageTap,
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppPalette.yellow,
                ),
              ),
              error: () => const Center(
                child: CircularProgressIndicator(
                  color: AppPalette.yellow,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
