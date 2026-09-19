import 'package:chat_app/bloc/profile_bloc/profile_bloc.dart';
import 'package:chat_app/bloc/profile_bloc/profile_state.dart';
import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/core/themes/app_theme.dart';
import 'package:chat_app/features/profile/widgets/profile_success_widget.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: context.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      duration: const Duration(milliseconds: 300),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        buildWhen: (previous, current) =>
            current is ProfileLoadingState ||
            current is ProfileSuccessState ||
            current is ProfileErrorState,
        listenWhen: (previous, current) =>
            current is ProfileLogoutState ||
            current is ChangePasswordSuccessState,
        listener: (context, state) {
          if (state is ProfileLogoutState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Logout successfully")),
            );
          }
          if (state is ChangePasswordSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Change password success")),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return Skeletonizer(
              child: ProfileSuccessWidget(user: UserModel.empty()),
            );
          }
          if (state is ProfileSuccessState) {
            return ProfileSuccessWidget(user: state.user);
          }
          if (state is ProfileErrorState) {
            return Center(child: Text(state.errorMessage));
          }
          return Container();
        },
      ),
    );
  }
}
