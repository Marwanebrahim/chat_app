import 'package:chat_app/bloc/profile_bloc/profile_bloc.dart';
import 'package:chat_app/bloc/profile_bloc/profile_event.dart';
import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/core/helpers/validators.dart';
import 'package:chat_app/core/themes/app_colors.dart';
import 'package:chat_app/core/themes/app_text_styles.dart';
import 'package:chat_app/core/themes/cubit/theme_cubit.dart';
import 'package:chat_app/features/auth/widgets/custom_text_form_field.dart';
import 'package:chat_app/features/profile/widgets/profile_list_tile.dart';
import 'package:chat_app/features/profile/widgets/user_avatar_widget.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSuccessWidget extends StatefulWidget {
  const ProfileSuccessWidget({super.key, required this.user});
  final UserModel user;

  @override
  State<ProfileSuccessWidget> createState() => _ProfileSuccessWidgetState();
}

class _ProfileSuccessWidgetState extends State<ProfileSuccessWidget> {
  final userNameFormKey = GlobalKey<FormState>();
  final changePasswordFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final appTextStyles = context.appTextStyles;
    return Column(
      children: [
        UserAvatarWidget(user: widget.user, radius: 50),
        Text(widget.user.username, style: appTextStyles.titleLarge),
        Text(widget.user.email, style: appTextStyles.bodyMedium),
        SizedBox(height: 40.h),
        Container(
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.borderColor),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            children: [
              ProfileListTile(
                icon: Icons.dark_mode,
                title: "Theme",
                subTitle: "System",
                trailing: Switch(
                  value: context.isDarkMode,
                  activeTrackColor: colors.paleViolet.withValues(alpha: 0.35),
                  activeThumbColor: colors.paleViolet.withValues(alpha: 0.8),
                  onChanged: (value) =>
                      context.read<ThemeCubit>().toggleTheme(),
                ),
              ),
              Divider(color: colors.dividerColor),
              ProfileListTile(
                icon: Icons.person,
                title: "Change Username",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        _changeUserNameDialog(appTextStyles, colors, context),
                  );
                },
              ),
              Divider(color: colors.dividerColor),
              ProfileListTile(
                icon: Icons.lock,
                title: "Change Password",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        _changePasswordDialog(appTextStyles, colors, context),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 30.h),
        Container(
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.borderColor),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: ProfileListTile(
            title: 'LogOut',
            icon: Icons.logout_outlined,
            isDanger: true,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => _logoutDialog(appTextStyles, colors, context),
              );
            },
          ),
        ),
      ],
    );
  }

  AlertDialog _changeUserNameDialog(
    AppTextStyles appTextStyles,
    AppColors colors,
    BuildContext context,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text("Change Username", style: appTextStyles.bodyLarge),
      content: Form(
        key: userNameFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              hintWidget: 'Enter your username',
              validator: (value) => Validators.nameValidator(value),
              controller: usernameController,
              prefixIcon: Icon(Icons.person),
            ),
            SizedBox(height: 36.h),
            CustomButtonWidget(
              height: 56.h,
              width: 250.w,
              borderRadius: 12,
              gradient: colors.primaryGradient,
              onTap: () {
                if (userNameFormKey.currentState!.validate()) {
                  Navigator.pop(context);
                  context.read<ProfileBloc>().add(
                    ChangeUserNameEvent(username: usernameController.text),
                  );
                }
              },

              child: Center(
                child: Text("Save", style: appTextStyles.bodySmall),
              ),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
    );
  }

  AlertDialog _changePasswordDialog(
    AppTextStyles appTextStyles,
    AppColors colors,
    BuildContext context,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text("Change Password", style: appTextStyles.bodyLarge),
      content: Form(
        key: changePasswordFormKey,
        child: Column(
          spacing: 20.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              hintWidget: 'Enter your current password',
              validator: (value) => Validators.passwordValidator(value),
              controller: currentPasswordController,
              isObsecure: true,
              prefixIcon: Icon(Icons.password),
            ),
            CustomTextFormField(
              hintWidget: 'Enter your new password',
              validator: (value) => Validators.passwordValidator(value),
              controller: newPasswordController,
              isObsecure: true,
              prefixIcon: Icon(Icons.lock),
            ),
            CustomTextFormField(
              hintWidget: 'Confirm your new password',
              validator: (value) => Validators.confirmPasswordValidator(
                newPasswordController.text,
                value,
              ),
              controller: confirmNewPasswordController,
              isObsecure: true,
              prefixIcon: Icon(Icons.lock_reset_outlined),
            ),
            SizedBox(height: 36.h),
            CustomButtonWidget(
              height: 56.h,
              width: 250.w,
              borderRadius: 12,
              gradient: colors.primaryGradient,
              onTap: () {
                if (changePasswordFormKey.currentState!.validate()) {
                  Navigator.pop(context);
                  context.read<ProfileBloc>().add(
                    ChangePasswordEvent(
                      currentPassword: currentPasswordController.text,
                      newPassword: newPasswordController.text,
                    ),
                  );
                }
              },
              child: Center(
                child: Text("Save", style: appTextStyles.bodySmall),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AlertDialog _logoutDialog(
    AppTextStyles appTextStyles,
    AppColors colors,
    BuildContext context,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text("LogOut", style: appTextStyles.bodyLarge),
      content: Text(
        "Are you sure you want to LogOut?",
        style: appTextStyles.bodyMedium,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      actions: [
        CustomButtonWidget(
          height: 56.h,
          width: 250.w,
          borderRadius: 12,
          gradient: colors.primaryGradient,
          onTap: () {
            context.read<ProfileBloc>().add(LogOutEvent());
            // Navigator.pop(context);
          },
          child: Center(child: Text("LogOut", style: appTextStyles.bodySmall)),
        ),
      ],
    );
  }
}
