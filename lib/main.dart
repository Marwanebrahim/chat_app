import 'package:chat_app/core/routes/app_router.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/core/themes/app_theme.dart';
import 'package:chat_app/core/themes/cubit/theme_cubit.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializations();
}

Future<void> initializations() async {
  await ScreenUtil.ensureScreenSize();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await UserService.instance.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      splitScreenMode: true,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: TextScaler.noScaling),
          child: BlocProvider(
            create: (context) => ThemeCubit(),
            child: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (BuildContext context, ThemeMode themeMode) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: AppRouter.onGenerateRoute,
                  initialRoute: AppRoutes.login,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeMode,
                  themeAnimationDuration: const Duration(milliseconds: 300),
                  themeAnimationCurve: Curves.easeInOut,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
