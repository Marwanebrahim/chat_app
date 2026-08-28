import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthDialog {
  static void showAuthErrorDialog({
    required BuildContext context,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(message, style: context.appTextStyles.bodyLarge),
        content: Icon(
          Icons.error_outline_outlined,
          color: Colors.red,
          size: 70.w,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: context.appTextStyles.bodySmall),
          ),
        ],
      ),
    );
  }
}
