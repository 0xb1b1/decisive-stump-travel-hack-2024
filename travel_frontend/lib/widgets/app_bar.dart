import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceAppBar extends StatelessWidget {
  const ServiceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/app_bar/app_bar.svg');
  }
}
