import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import 'newsfeed/newsfeed_screen.dart';
import 'solo/solo_screen.dart';
import 'social/social_screen.dart';
import 'explore/explore_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    NewsfeedScreen(),
    SoloScreen(),
    SocialScreen(),
    ExploreScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.dynamic_feed_rounded, Icons.dynamic_feed_outlined, 'Tin'),
                _buildNavItem(1, Icons.auto_awesome_rounded, Icons.auto_awesome_outlined, 'Cá Nhân'),
                _buildNavItem(2, Icons.link_rounded, Icons.link_outlined, 'Bạn Bè'),
                _buildNavItem(3, Icons.explore_rounded, Icons.explore_outlined, 'Khám Phá'),
                _buildNavItem(4, Icons.person_rounded, Icons.person_outlined, 'Hồ Sơ'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? AppColors.primary : AppColors.textLight,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              )
                  .animate()
                  .fadeIn(duration: 200.ms)
                  .slideX(begin: -0.2, end: 0, duration: 200.ms),
            ],
          ],
        ),
      ),
    );
  }
}
