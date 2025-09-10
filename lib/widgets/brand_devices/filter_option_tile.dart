import 'package:flutter/material.dart';

class FilterOptionTile extends StatelessWidget {
  const FilterOptionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.isSelected,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Icon(icon),
              const SizedBox(width: 8),
              Text(title),
              const SizedBox(width: 6),
              if (isSelected)
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 10,
                  child: Icon(
                    Icons.done,
                    size: 16,
                  ),
                ),
            ]),
          ),
        ),
        const Divider(
          height: 0,
        ),
      ],
    );
  }
}
