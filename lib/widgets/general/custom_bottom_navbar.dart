import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {
  final List<CustomBottomNavbarItem> items;
  final int selectedIndex;
  final void Function(int index)? onSelected;
  const CustomBottomNavbar({
    required this.items,
    required this.selectedIndex,
    this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      width: double.infinity,
      height: 75,
      child: Row(
        children: List.generate(
          items.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => onSelected != null ? onSelected!(index) : null,
              child: items[index]..isSelected = index == selectedIndex,
            ),
          ),
        ).toList(),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomBottomNavbarItem extends StatelessWidget {
  bool isSelected;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  CustomBottomNavbarItem({
    super.key,
    this.isSelected = false,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(isSelected ? selectedIcon : icon, size: 22),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }
}
