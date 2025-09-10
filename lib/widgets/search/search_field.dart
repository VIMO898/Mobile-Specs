import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchField extends ConsumerWidget {
  final TextEditingController? controller;
  final void Function(String)? onChange;
  final void Function(String)? onSubmit;
  final VoidCallback? onTap;
  final VoidCallback? onTapOutside;
  final VoidCallback? onClear;
  final bool readOnly;
  const SearchField({
    super.key,
    this.controller,
    this.onChange,
    this.onTap,
    this.onSubmit,
    this.onClear,
    this.onTapOutside,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final iconColor = theme.iconTheme.color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        onChanged: onChange,
        onSubmitted: onSubmit,
        onTap: onTap,
        onTapOutside: (_) => onTapOutside != null ? onTapOutside!() : null,
        autocorrect: false,
        style: const TextStyle(fontSize: 18),
        maxLines: 1,
        decoration: _buildSearchFieldDecoration(theme.cardColor, iconColor),
      ),
    );
  }

  InputDecoration _buildSearchFieldDecoration(
    Color fillColor,
    Color? iconColor,
  ) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      suffixIcon: IconButton(
        icon: Icon(Icons.cancel_outlined, color: iconColor),
        onPressed: onClear,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(22),
      ),
      filled: true,
      fillColor: fillColor,
      labelText: 'Search for devices',
      contentPadding: const EdgeInsets.all(12),
      prefixIcon: Icon(
        FontAwesomeIcons.magnifyingGlass,
        size: 20,
        color: iconColor,
      ),
    );
  }
}
