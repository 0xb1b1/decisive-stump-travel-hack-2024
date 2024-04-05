import 'package:flutter/material.dart';

import 'image_tag.dart';
import '../../../utils/utils.dart';

class ImageTags extends StatelessWidget {
  final List<String> tags;

  const ImageTags({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: Utils.makeUpperList(tags).map((e) => ImageTag(tag: e)).toList(),
    );
  }
}
