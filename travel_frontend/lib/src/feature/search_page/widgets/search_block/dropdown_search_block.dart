import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_frontend/core/view_model_widget.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/widgets/filters_container.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/filters_view_model.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/search_block/widgets/search_block.dart';

class DropdownSearchBlock extends StatefulWidget {
  final FiltersViewModel filtersViewModel;
  final VoidCallback onFiltersTap;
  final VoidCallback onSearchPhoto;

  const DropdownSearchBlock({
    super.key,
    required this.onFiltersTap,
    required this.onSearchPhoto,
    required this.filtersViewModel,
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
    return ViewModelWidget<FiltersViewModel>(
      builder: (
        BuildContext context,
        FiltersViewModel vm,
        Widget? child,
      ) =>
          Column(
        children: [
          SearchBlock(
            onSearchPhoto: () {},
            onFiltersTap: _toggleDropdown,
            isFiltersChosen: widget.filtersViewModel.isFiltersChosen,
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.vertical,
            axisAlignment: -1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                FiltersContainer(
                  filtersList: vm.state.filtersList,
                  filtersViewModel: vm,
                )
              ],
            ),
          ),
        ],
      ),
      model: widget.filtersViewModel,
    );
  }
}
