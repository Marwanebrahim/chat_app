import 'package:chat_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_app/bloc/auth_bloc/auth_event.dart';
import 'package:chat_app/bloc/auth_bloc/auth_state.dart';
import 'package:chat_app/core/constants/app_assets.dart';
import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/core/helpers/validators.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/features/auth/widgets/auth_dialog.dart';
import 'package:chat_app/features/auth/widgets/custom_text_form_field.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:chat_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    UserService.instance.getUser().then((user) {
      if (user != null) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
        if (state is AuthFailureState) {
          AuthDialog.showAuthErrorDialog(
            context: context,
            message: state.errorMessage,
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 80.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: colors.primaryGradient,
                  ),
                  child: Icon(Icons.chat_bubble, color: colors.white, size: 50),
                ),
              ),
              SizedBox(height: 32.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome to back', style: textStyles.displayLarge),
                  Text(
                    "Sign in to continue your secure conversations.",
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
                      validator: (value) => Validators.passwordValidator(value),
                      prefixIcon: Icon(Icons.lock_outline, color: colors.text3),
                      isObsecure: true,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot password?",
                    style: textStyles.bodySmall.copyWith(
                      color: colors.lightPurple,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  CustomButtonWidget(
                    height: 56.h,
                    width: double.infinity,
                    borderRadius: 16,
                    gradient: colors.primaryGradient,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          AuthLoginEvent(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          ),
                        );
                      }
                    },
                    child: Center(
                      child: Text(
                        "Sign in",
                        style: textStyles.titleLarge.copyWith(
                          color: colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.signup);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: textStyles.bodyMedium,
                        children: [
                          TextSpan(
                            text: "Sign up",
                            style: textStyles.bodyMedium.copyWith(
                              color: colors.lightPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: colors.dividerColor,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text("or", style: textStyles.bodyMedium),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: colors.dividerColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {
                      context.read<AuthBloc>().add(AuthGoogleSignupEvent());
                    },
                    child: CircleAvatar(
                      backgroundColor: colors.navBarBackground,
                      radius: 28,
                      child: SvgPicture.asset(
                        AppAssets.googleIcon,
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
