// lib/widgets/curved_bottom_nav.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CurvedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onReportTap;

  const CurvedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onReportTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing based on screen width
        final isCompact = constraints.maxWidth < 400;
        final navHeight = isCompact ? 75.0 : 85.0;
        final iconSize = isCompact ? 22.0 : 24.0;
        final fontSize = isCompact ? 10.0 : 11.0;
        
        return Container(
          height: navHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primary,
                AppTheme.primary.withOpacity(0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  label: 'Dashboard',
                  emoji: '📊',
                  iconSize: iconSize,
                  fontSize: fontSize,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.add_alert_outlined,
                  activeIcon: Icons.add_alert,
                  label: 'Report',
                  emoji: '📝',
                  iconSize: iconSize,
                  fontSize: fontSize,
                  onTap: onReportTap,
                  isCenter: true,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.groups_outlined,
                  activeIcon: Icons.groups,
                  label: 'Community',
                  emoji: '👥',
                  iconSize: iconSize,
                  fontSize: fontSize,
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.map_outlined,
                  activeIcon: Icons.map,
                  label: 'Map',
                  emoji: '🗺️',
                  iconSize: iconSize,
                  fontSize: fontSize,
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: 'Settings',
                  emoji: '⚙️',
                  iconSize: iconSize,
                  fontSize: fontSize,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String emoji,
    required double iconSize,
    required double fontSize,
    VoidCallback? onTap,
    bool isCenter = false,
  }) {
    final isSelected = currentIndex == index;
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? (() => this.onTap(index)),
          borderRadius: BorderRadius.circular(isCenter ? 25 : 12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48), // Minimum touch target
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with proper scaling and states - center button is larger and white
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(isCenter ? 12 : (isSelected ? 8 : 6)),
                  decoration: BoxDecoration(
                    color: isCenter 
                        ? Colors.white
                        : isSelected 
                            ? Colors.white.withOpacity(0.2)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(isCenter ? 20 : 12),
                    boxShadow: isCenter ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    size: isCenter ? iconSize + 4 : iconSize,
                    color: isCenter 
                        ? AppTheme.primary
                        : isSelected 
                            ? Colors.white
                            : Colors.white.withOpacity(0.7),
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Label with proper contrast and scaling
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: isSelected || isCenter ? FontWeight.w600 : FontWeight.w500,
                      color: isCenter 
                          ? Colors.white
                          : isSelected 
                              ? Colors.white
                              : Colors.white.withOpacity(0.8),
                      letterSpacing: 0.1,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}