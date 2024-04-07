import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_svg/flutter_svg.dart' hide Svg;
import 'package:travel_frontend/src/common/app_palette.dart';

abstract class AssetsPath {
  static const filters = 'assets/icons/filters.svg';
  static const cross = 'assets/icons/cross.svg';
  static const photo = 'assets/icons/photo.svg';
  static const search = 'assets/icons/search.svg';
  static const similar = 'assets/icons/similar.svg';

  static const appBar = 'assets/app_bar/app_bar.svg';

  static const bottomBar = 'assets/app_bar/bottom_bar.svg';
  static const empty = 'assets/empty.png';
}

abstract class AssetsProvider {
  static get empty => Image.asset(
        AssetsPath.empty,
        height: 400,
        width: 400,
      );

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
        color: AppPalette.white,
      );

  static get search => SvgPicture.asset(
        AssetsPath.search,
      );

  static get similar => SvgPicture.asset(
        AssetsPath.similar,
      );

  static get appBar => SvgPicture.asset(
        AssetsPath.appBar,
        fit: BoxFit.cover,
      );

  static get bottomBar => SvgPicture.asset(
        AssetsPath.bottomBar,
        fit: BoxFit.fill,
      );
}
