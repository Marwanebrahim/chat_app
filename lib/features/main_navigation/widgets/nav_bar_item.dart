import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  const NavBarItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isSelected,
  });
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final appTextStyles = context.appTextStyles;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? colors.white : colors.text2),
          Text(
            title,
            style: appTextStyles.bodySmall.copyWith(
              color: isSelected ? colors.white : colors.text2,
            ),
          ),
        ],
      ),
    );
  }
}
