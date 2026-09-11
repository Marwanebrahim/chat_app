import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    super.key,
    required this.title,
    required this.icon,
    this.subTitle,
    this.trailing,
    this.isDanger = false,
    this.onTap,
  });
  final String title;
  final String? subTitle;
  final IconData icon;
  final Widget? trailing;
  final bool isDanger;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final appTextStyles = context.appTextStyles;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isDanger
            ? appColors.red.withValues(alpha: 0.2)
            : appColors.dividerColor.withValues(alpha: 0.5),
        child: Icon(
          icon,
          color: isDanger ? appColors.red : appColors.lightPurple,
        ),
      ),
      title: Text(
        title,
        style: appTextStyles.bodyLarge.copyWith(
          color: isDanger ? appColors.red : appColors.text1,
        ),
      ),
      subtitle: subTitle == null
          ? null
          : Text(subTitle!, style: appTextStyles.bodyMedium),
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          trailing ?? const SizedBox.shrink(),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: isDanger ? appColors.red : appColors.text2,
          ),
        ],
      ),
    );
  }
}
