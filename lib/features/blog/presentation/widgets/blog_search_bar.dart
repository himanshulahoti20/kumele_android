import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';

class BlogSearchBar extends StatelessWidget {
  const BlogSearchBar({
    super.key,
    this.controller,
    this.onChanged,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return KumeleTextField.search(
      controller: controller,
      hintText: 'Search',
      onChanged: onChanged,
    );
  }
}
