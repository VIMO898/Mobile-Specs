import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TileType { Switch, ForwardArrow, None }

class SettingListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final TileType tileType;
  final VoidCallback onTap;
  final bool? switchValue;
  final void Function(bool newValue)? onSwitchChanged;
  final bool includeBottomDivider;
  const SettingListTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
    this.tileType = TileType.ForwardArrow,
    this.switchValue,
    this.onSwitchChanged,
    this.includeBottomDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isSwitch = tileType == TileType.Switch;
    final isForwardArrow = tileType == TileType.ForwardArrow;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: theme.cardColor,
        height: 60,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 16),
              child: FaIcon(leadingIcon, size: 22),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(title, style: textTheme.bodyMedium),
                        const Spacer(),
                        isSwitch
                            ? Switch(
                                value: switchValue!,
                                onChanged: onSwitchChanged!,
                              )
                            : isForwardArrow
                            ? const FaIcon(
                                FontAwesomeIcons.chevronRight,
                                size: 18,
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(width: 6),
                      ],
                    ),
                  ),
                  if (includeBottomDivider) const Divider(height: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
