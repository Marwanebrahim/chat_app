import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/features/auth/screens/login_screen.dart';
import 'package:chat_app/features/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return _buildRoute(const LoginScreen(), settings);
      case AppRoutes.signup:
        return _buildRoute(const SignupScreen(), settings);
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
