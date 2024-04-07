import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_frontend/core/view_model_widget.dart';
import 'package:travel_frontend/src/common/app_palette.dart';

import 'package:travel_frontend/src/common/assets_provider.dart';
import 'package:travel_frontend/src/feature/image_uploaded/image_uploaded_providers.dart';
import 'package:travel_frontend/src/feature/image_uploaded/image_uploaded_view_model.dart';
import 'package:travel_frontend/src/feature/image_uploaded/scene/image_uploaded_data.dart';
import 'package:travel_frontend/src/widgets/error_scene.dart';
import 'package:travel_frontend/src/widgets/page_container.dart';

import '../../navigation/routes.dart';

class ImageUploadedPage extends ConsumerWidget {
  const ImageUploadedPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = componentArg0f<XFile>(
      context,
      RoutesArgs.uploadedFile,
    );

    final vm = ref.watch(imageUploadedViewModelProvider(file!));

    return ViewModelWidget<ImageUploadedViewModel>(
      model: vm,
      builder: (
        BuildContext context,
        ImageUploadedViewModel vm,
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
              data: (image, tags, similar) => ImageUploadedData(
                uploadedImage: image,
                onImageTap: vm.onImageTap,
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppPalette.yellow,
                ),
              ),
              error: () => const Center(
                child: ErrorScene(),
              ),
            ),
          ),
        );
      },
    );
  }
}
