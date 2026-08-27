import 'dart:ui';

import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/core/helpers/validators.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/features/auth/widgets/custom_text_form_field.dart';
import 'package:chat_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: colors.primaryGradient,
                  ),
                  child: Icon(Icons.chat_bubble, color: colors.white, size: 50),
                ),
                SizedBox(height: 32.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Create Account', style: textStyles.displayLarge),
                    Text(
                      "Join us to start communicating effortlessly.",
                      style: textStyles.bodyMedium,
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Full Name", style: textStyles.bodySmall),
                      SizedBox(height: 8.h),
                      CustomTextFormField(
                        controller: _nameController,
                        hintWidget: "John Doe",
                        validator: (value) => Validators.nameValidator(value),
                        prefixIcon: Icon(
                          Icons.person_outline_outlined,
                          color: colors.text3,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text("Email", style: textStyles.bodySmall),
                      SizedBox(height: 8.h),
                      CustomTextFormField(
                        controller: _emailController,
                        hintWidget: "Enter your email",
                        validator: (value) => Validators.emailValidator(value),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: colors.text3,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text("Password", style: textStyles.bodySmall),
                      SizedBox(height: 8.h),
                      CustomTextFormField(
                        controller: _passwordController,
                        hintWidget: "Enter your password",
                        validator: (value) =>
                            Validators.passwordValidator(value),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: colors.text3,
                        ),
                        isObsecure: true,
                      ),
                      SizedBox(height: 16.h),
                      Text("Confirm Password", style: textStyles.bodySmall),
                      SizedBox(height: 8.h),
                      CustomTextFormField(
                        controller: _confirmPasswordController,
                        hintWidget: "Confirm your password",
                        validator: (value) =>
                            Validators.passwordValidator(value),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: colors.text3,
                        ),
                        isObsecure: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                Column(
                  children: [
                    CustomButtonWidget(
                      height: 56.h,
                      width: double.infinity,
                      borderRadius: 16,
                      gradient: colors.primaryGradient,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                      child: Center(
                        child: Text(
                          "Sign up",
                          style: textStyles.titleLarge.copyWith(
                            color: colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: textStyles.bodyMedium,
                          children: [
                            TextSpan(
                              text: "Sign in",
                              style: textStyles.bodyMedium.copyWith(
                                color: colors.lightPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 16.h,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: Opacity(
                opacity: 0.25,
                child: Container(
                  width: 256,
                  height: 256,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.purple,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16.h,
            right: 10.w,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: Opacity(
                opacity: 0.25,
                child: Container(
                  width: 256,
                  height: 256,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.purple,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
