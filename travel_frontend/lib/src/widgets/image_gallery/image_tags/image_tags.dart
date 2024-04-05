import 'package:flutter/material.dart';

import 'image_tag.dart';
import '../../../utils/utils.dart';

class ImageTags extends StatelessWidget {
  final List<String> tags;
  final void Function(String) onTagTap;

  const ImageTags({
    super.key,
    required this.tags,
    required this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: Utils.makeUpperList(tags)
          .map(
            (e) => ImageTag(
              tag: e,
              onTagTap: onTagTap,
            ),
          )
          .toList(),
    );
  }
}
