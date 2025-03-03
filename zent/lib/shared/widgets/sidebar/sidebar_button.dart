// shared/widgets/sidebar/sidebar_button.dart
import 'package:flutter/material.dart';
import 'package:zent/shared/models/sidebar_item.dart';

class SidebarButton extends StatelessWidget {
  final SidebarItem item;
  final bool isSelected;
  final VoidCallback onPressed;

  const SidebarButton({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;

    return Container(
      width: 180,
      height: 36,
      padding: const EdgeInsets.all(8),
      decoration: ShapeDecoration(
        color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: isSelected ? primaryColor : textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.label,
                style: theme.textTheme.headlineMedium!.copyWith(
                  color: isSelected ? primaryColor : textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
