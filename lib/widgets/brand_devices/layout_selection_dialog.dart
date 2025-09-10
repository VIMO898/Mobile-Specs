import 'package:flutter/material.dart';

import '../../screens/brand_devices_screen.dart';
import 'filter_option_tile.dart';

class LayoutSelectionDialog extends StatelessWidget {
  const LayoutSelectionDialog(
    this.context, {
    super.key,
    required this.currLayout,
    required this.onSelectLayout,
  });
  final DevicesLayout currLayout;
  final BuildContext context;
  final void Function(DevicesLayout selectedLayout) onSelectLayout;

  void _handleSelectLayout(BuildContext context, DevicesLayout layout) {
    onSelectLayout(layout);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'Select a Layout',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Divider(thickness: 0.8, height: 0),
          FilterOptionTile(
            title: 'Large Grid',
            icon: Icons.grid_view_outlined,
            isSelected: currLayout == DevicesLayout.largeGrid,
            onPressed: () =>
                _handleSelectLayout(context, DevicesLayout.largeGrid),
          ),
          FilterOptionTile(
            title: 'Small Grid',
            isSelected: currLayout == DevicesLayout.smallGrid,
            icon: Icons.grid_on_outlined,
            onPressed: () =>
                _handleSelectLayout(context, DevicesLayout.smallGrid),
          ),
          FilterOptionTile(
            title: 'List (Experimental)',
            icon: Icons.list_outlined,
            isSelected: currLayout == DevicesLayout.list,
            onPressed: () => _handleSelectLayout(context, DevicesLayout.list),
          ),
          FilterOptionTile(
            title: 'Staggered',
            icon: Icons.dashboard_outlined,
            isSelected: currLayout == DevicesLayout.staggeredGrid,
            onPressed: () =>
                _handleSelectLayout(context, DevicesLayout.staggeredGrid),
          ),
        ],
      ),
    );
  }
}
