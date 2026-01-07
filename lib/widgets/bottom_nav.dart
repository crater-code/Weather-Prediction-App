// lib/widgets/bottom_nav.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

typedef OnNavTap = void Function(int index);

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final OnNavTap onTap;
  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 400;
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: isNarrow ? 60 : 65,
              padding: EdgeInsets.symmetric(
                horizontal: isNarrow ? 8 : 12, 
                vertical: 4
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(context, 0, Icons.home_outlined, Icons.home, 'Home', isNarrow),
                  _buildNavItem(context, 1, Icons.report_outlined, Icons.report, 'Report', isNarrow),
                  _buildNavItem(context, 2, Icons.forum_outlined, Icons.forum, 'Community', isNarrow),
                  _buildNavItem(context, 3, Icons.map_outlined, Icons.map, 'Map', isNarrow),
                  _buildNavItem(context, 4, Icons.person_outline, Icons.person, 'Profile', isNarrow),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData outlinedIcon, IconData filledIcon, String label, bool isNarrow) {
    final isSelected = currentIndex == index;
    final theme = Theme.of(context);
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isNarrow ? 4 : 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: EdgeInsets.all(isNarrow ? 6 : 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isSelected ? filledIcon : outlinedIcon,
                  color: isSelected ? AppTheme.primary : AppTheme.slate500,
                  size: isNarrow ? 20 : 22,
                ),
              ),
              SizedBox(height: isNarrow ? 2 : 3),
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  style: theme.textTheme.labelSmall!.copyWith(
                    color: isSelected ? AppTheme.primary : AppTheme.slate500,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: isNarrow ? 10 : 11,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
