import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    required this.height,
    required this.width,
    this.backgroundColor,
    this.gradient,
    required this.borderRadius,
    required this.onTap,
    required this.child,
  });
  final double height;
  final double width;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double borderRadius;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}