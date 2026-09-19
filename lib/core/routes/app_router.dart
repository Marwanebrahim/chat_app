import 'package:chat_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_app/bloc/main_navigation/main_navigation_cubit.dart';
import 'package:chat_app/bloc/search/user_search_bloc.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/features/auth/screens/login_screen.dart';
import 'package:chat_app/features/auth/screens/signup_screen.dart';
import 'package:chat_app/features/main_navigation/screens/main_navigation.dart';
import 'package:chat_app/features/search/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return _buildRoute(
          BlocProvider(
            create: (context) => AuthBloc(),
            child: const LoginScreen(),
          ),
          settings,
        );
      case AppRoutes.signup:
        return _buildRoute(
          BlocProvider(
            create: (context) => AuthBloc(),
            child: const SignupScreen(),
          ),
          settings,
        );
      case AppRoutes.mainNavigation:
        return _buildRoute(
          BlocProvider(
            create: (context) => MainNavigationCubit(),
            child: MainNavigation(),
          ),
          settings,
        );
      case AppRoutes.search:
        return _buildRoute(
          BlocProvider(
            create: (context) => UserSearchBloc(),
            child: const SearchScreen(),
          ),
          settings,
          isLeft: true,
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static PageRouteBuilder _buildRoute(
    Widget page,
    RouteSettings setting, {
    bool isLeft = false,
  }) {
    return PageRouteBuilder(
      settings: setting,

      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },

      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        double start = isLeft ? -1.0 : 1.0;
        final begin = Offset(start, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
