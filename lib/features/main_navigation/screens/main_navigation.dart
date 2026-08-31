import 'package:chat_app/bloc/main_navigation/main_navigation_cubit.dart';
import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/features/main_navigation/widgets/nav_bar_item.dart';
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

  final List<Widget> _pages = [
    Center(child: Text('Home Page')),
    Center(child: Text('Search Page')),
    Center(child: Text('Profile Page')),
  ];

  final List<AppBar> _appBars = [
    AppBar(title: Text('Home')),
    AppBar(title: Text('Search')),
    AppBar(title: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      appBar: _appBars[context.watch<MainNavigationCubit>().state],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,

              itemBuilder: (context, index) {
                return _pages[index];
              },
              itemCount: _pages.length,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BlocBuilder<MainNavigationCubit, int>(
                builder: (BuildContext context, index) {
                  return Container(
                    height: 64.h,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    margin: EdgeInsets.only(bottom: 32.h),
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
        return const FractionalOffset(0.07, 0.5);
      case 1:
        return const FractionalOffset(0.49, 0.5);
      case 2:
        return const FractionalOffset(0.93, 0.5);
      default:
        return const FractionalOffset(0.07, 0.5);
    }
  }
}
