import 'package:flutter/material.dart';

class PopularComparisonTile extends StatelessWidget {
  final String nameA;
  final String nameB;
  final VoidCallback onTap;
  const PopularComparisonTile({
    super.key,
    required this.nameA,
    required this.nameB,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border(
            bottom: BorderSide(color: theme.dividerColor, width: 0.35),
          ),
        ),
        child: Row(
          children: [
            _buildDevice(name: nameA),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: theme.textTheme.bodyLarge!.color,
                child: Text(
                  'VS',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            _buildDevice(name: nameB, reversed: true),
          ],
        ),
      ),
    );
  }

  Flexible _buildDevice({required String name, bool reversed = false}) {
    final children = [
      Image.asset('assets/images/phone.png', width: 40, height: 60),
      const SizedBox(width: 12),
      Expanded(
        child: Align(
          alignment: !reversed ? Alignment.centerLeft : Alignment.centerRight,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    ];
    return Flexible(
      flex: 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: reversed ? children.reversed.toList() : children,
      ),
    );
  }
}
