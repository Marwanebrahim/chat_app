import 'package:chat_app/bloc/main_navigation/main_navigation_cubit.dart';
import 'package:chat_app/bloc/profile_bloc/profile_bloc.dart';
import 'package:chat_app/bloc/profile_bloc/profile_event.dart';
import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/core/themes/cubit/theme_cubit.dart';
import 'package:chat_app/features/chats/screens/chats_screen.dart';
import 'package:chat_app/features/main_navigation/widgets/nav_bar_item.dart';
import 'package:chat_app/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final PageController _pageController = PageController(initialPage: 0);
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ChatsScreen(),
      Text('Search Page'),
      MultiBlocProvider(
        providers: [
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc()..add(GetProfileEvent()),
          ),
          BlocProvider<ThemeCubit>.value(value: context.read<ThemeCubit>()),
        ],
        child: ProfileScreen(),
      ),
    ];
    final colors = context.appColors;
    final List<AppBar> appBars = [
      AppBar(
        title: Text('Chats'),
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.search);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      AppBar(
        title: Text('Calls'),
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.search);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.search);
            },
            icon: const Icon(Icons.search),
          ),
        ],
        forceMaterialTransparency: true,
      ),
    ];
    return Scaffold(
      appBar: appBars[context.watch<MainNavigationCubit>().state],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                return pages[index];
              },
              itemCount: pages.length,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BlocBuilder<MainNavigationCubit, int>(
                builder: (BuildContext context, index) {
                  return Container(
                    height: 70.h,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    margin: EdgeInsets.only(bottom: 24.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colors.borderColor.withValues(alpha: 0.4),
                      ),
                      color: colors.appBarBackground.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedAlign(
                          alignment: _align(index),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Container(
                            height: 56.h,
                            width: 74.w,
                            decoration: BoxDecoration(
                              gradient: context.appColors.primaryGradient,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            NavBarItem(
                              title: 'Chats',
                              icon: Icons.chat_bubble_outline,
                              onTap: () {
                                context.read<MainNavigationCubit>().updateIndex(
                                  0,
                                );
                                _pageController.animateToPage(
                                  0,
                                  curve: Curves.easeInOut,
                                  duration: const Duration(milliseconds: 300),
                                );
                              },
                              isSelected: index == 0,
                            ),
                            NavBarItem(
                              title: 'Calls',
                              icon: Icons.call_outlined,
                              onTap: () {
                                context.read<MainNavigationCubit>().updateIndex(
                                  1,
                                );
                                _pageController.animateToPage(
                                  1,
                                  curve: Curves.easeInOut,
                                  duration: const Duration(milliseconds: 300),
                                );
                              },
                              isSelected: index == 1,
                            ),
                            NavBarItem(
                              title: 'Profile',
                              icon: Icons.person_outline,
                              onTap: () {
                                context.read<MainNavigationCubit>().updateIndex(
                                  2,
                                );
                                _pageController.animateToPage(
                                  2,
                                  curve: Curves.easeInOut,
                                  duration: const Duration(milliseconds: 300),
                                );
                              },
                              isSelected: index == 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  FractionalOffset _align(int index) {
    switch (index) {
      case 0:
        return const FractionalOffset(0.08, 0.5);
      case 1:
        return const FractionalOffset(0.49, 0.5);
      case 2:
        return const FractionalOffset(0.92, 0.5);
      default:
        return const FractionalOffset(0.08, 0.5);
    }
  }
}
