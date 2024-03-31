import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_frontend/src/common/app_palette.dart';

abstract class AssetsPath {
  static const filters = 'assets/icons/filters.svg';
  static const cross = 'assets/icons/cross.svg';
  static const photo = 'assets/icons/photo.svg';
  static const search = 'assets/icons/search.svg';
  static const share = 'assets/icons/share.svg';

  static const appBar = 'assets/app_bar/app_bar.svg';
  static const fullAppBar = 'assets/app_bar/full_app_bar.svg';
  static const bottomBar = 'assets/app_bar/bottom_bar.svg';
}

abstract class AssetsProvider {
  static get filters => SvgPicture.asset(
        AssetsPath.filters,
        height: 24,
        width: 24,
        color: AppPalette.black,
      );

  static get cross => SvgPicture.asset(
        AssetsPath.cross,
        height: 24,
        width: 24,
        color: AppPalette.black,
      );

  static get photo => SvgPicture.asset(
        AssetsPath.photo,
        height: 24,
        width: 24,
        color: AppPalette.black,
      );

  static get search => SvgPicture.asset(
        AssetsPath.search,
        height: 24,
        width: 24,
        color: AppPalette.black,
      );

  static get share => SvgPicture.asset(
        AssetsPath.search,
        height: 16,
        width: 16,
        color: AppPalette.white,
      );

  static get appBar => SvgPicture.asset(
        AssetsPath.appBar,
      );

  static get fullAppBar => SvgPicture.asset(
        AssetsPath.fullAppBar,
      );

  static get bottomBar => SvgPicture.asset(
        AssetsPath.bottomBar,
      );
}
