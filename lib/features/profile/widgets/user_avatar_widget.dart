import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({super.key, required this.user, this.radius = 24});
  final UserModel user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final appTextStyles = context.appTextStyles;
    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.lightPurple,
      child: user.photoUrl.isNullOrEmpty()
          ? Text(
              user.username.isEmpty
                  ? "?"
                  : user.username
                        .substring(0, user.username.length >= 2 ? 2 : 1)
                        .toUpperCase(),
              style: appTextStyles.displayLarge.copyWith(color: colors.white),
            )
          : ClipOval(
              child: CachedNetworkImage(
                imageUrl: user.photoUrl!,
                fit: BoxFit.cover,
                height: radius * 2,
                width: radius * 2,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
    );
  }
}
