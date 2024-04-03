import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/filters_container.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/search_block/widgets/search_block.dart';

class DropdownSearchBlock extends StatefulWidget {
  final VoidCallback onFiltersTap;
  final VoidCallback onSearchPhoto;

  const DropdownSearchBlock({
    super.key,
    required this.onFiltersTap,
    required this.onSearchPhoto,
  });

  @override
  State<DropdownSearchBlock> createState() => _DropdownSearchBlockState();
}

class _DropdownSearchBlockState extends State<DropdownSearchBlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_controller.isDismissed) {
      _controller.forward();
      widget.onFiltersTap.call();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBlock(
          onSearchPhoto: () {},
          onFiltersTap: _toggleDropdown,
        ),
        SizeTransition(
          sizeFactor: _animation,
          axis: Axis.vertical,
          axisAlignment: -1,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              FiltersContainer(),
            ],
          ),
        ),
      ],
    );
  }
}
