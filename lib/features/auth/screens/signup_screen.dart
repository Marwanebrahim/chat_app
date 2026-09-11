import 'package:chat_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_app/bloc/auth_bloc/auth_event.dart';
import 'package:chat_app/bloc/auth_bloc/auth_state.dart';
import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/core/helpers/validators.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/features/auth/widgets/auth_dialog.dart';
import 'package:chat_app/features/auth/widgets/custom_text_form_field.dart';
import 'package:chat_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _createAnimation;
  late Animation<Offset> _nameAnimation;
  late Animation<Offset> _emailAnimation;
  late Animation<Offset> _passwordAnimation;
  late Animation<Offset> _confirmAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.3, curve: Curves.easeInOut),
      ),
    );
    _createAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 0.45, curve: Curves.easeInOut),
      ),
    );
    _nameAnimation = Tween<Offset>(begin: const Offset(2, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.45, 0.55, curve: Curves.easeInOut),
          ),
        );
    _emailAnimation = Tween<Offset>(begin: const Offset(2, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.55, 0.65, curve: Curves.easeInOut),
          ),
        );
    _passwordAnimation =
        Tween<Offset>(begin: const Offset(2, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.65, 0.75, curve: Curves.easeInOut),
          ),
        );
    _confirmAnimation =
        Tween<Offset>(begin: const Offset(2, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.75, 0.85, curve: Curves.easeInOut),
          ),
        );
    _buttonAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.85, 1, curve: Curves.easeInOut),
      ),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.mainNavigation,
            (route) => false,
          );
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
            children: [
              ScaleTransition(
                scale: _logoAnimation,
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
              FadeTransition(
                opacity: _createAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Create Account', style: textStyles.displayLarge),
                    Text(
                      "Join us to start communicating effortlessly.",
                      style: textStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SlideTransition(
                      position: _nameAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Full Name", style: textStyles.bodySmall),
                          SizedBox(height: 8.h),
                          CustomTextFormField(
                            controller: _nameController,
                            hintWidget: "John Doe",
                            validator: (value) =>
                                Validators.nameValidator(value),
                            prefixIcon: Icon(
                              Icons.person_outline_outlined,
                              color: colors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SlideTransition(
                      position: _emailAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email", style: textStyles.bodySmall),
                          SizedBox(height: 8.h),
                          CustomTextFormField(
                            controller: _emailController,
                            hintWidget: "Enter your email",
                            validator: (value) =>
                                Validators.emailValidator(value),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: colors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SlideTransition(
                      position: _passwordAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SlideTransition(
                      position: _confirmAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Confirm Password", style: textStyles.bodySmall),
                          SizedBox(height: 8.h),
                          CustomTextFormField(
                            controller: _confirmPasswordController,
                            hintWidget: "Confirm your password",
                            validator: (value) =>
                                Validators.confirmPasswordValidator(
                                  _passwordController.text,
                                  value,
                                ),
                            prefixIcon: Icon(
                              Icons.lock_reset_outlined,
                              color: colors.text3,
                              size: 28,
                            ),
                            isObsecure: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                    FadeTransition(
                      opacity: _buttonAnimation,
                      child: Column(
                        children: [
                          CustomButtonWidget(
                            height: 56.h,
                            width: double.infinity,
                            borderRadius: 16,
                            gradient: colors.primaryGradient,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  AuthSignupEvent(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                    username: _nameController.text.trim(),
                                  ),
                                );
                              }
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
