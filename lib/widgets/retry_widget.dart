import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget({super.key, required this.message, required this.onRetry});
  final String message;
  final void Function() onRetry;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final appTextStyles = context.appTextStyles;
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 100,
            backgroundColor: colors.lightPurple,
            child: Icon(Icons.error, size: 100, color: colors.white),
          ),
          Text(message, style: appTextStyles.titleLarge),
          CustomButtonWidget(
            height: 56.h,
            width: 250.w,
            borderRadius: 12,
            gradient: colors.primaryGradient,
            onTap: onRetry,
            child: Text("Retry", style: appTextStyles.bodySmall),
          ),
        ],
      ),
    );
  }
}
