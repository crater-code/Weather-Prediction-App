// lib/widgets/expandable_bottom_nav.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/mock_data_service.dart';

class ExpandableBottomNav extends StatefulWidget {
  final Function(String) onNavigate;
  final String currentRoute;

  const ExpandableBottomNav({
    super.key,
    required this.onNavigate,
    required this.currentRoute,
  });

  @override
  State<ExpandableBottomNav> createState() => _ExpandableBottomNavState();
}

class _ExpandableBottomNavState extends State<ExpandableBottomNav>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final expandedHeight = screenHeight * 0.55;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _isExpanded ? expandedHeight : 65,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary,
            Color(0xFF1565C0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(80),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Collapsed navigation bar - always visible
            _buildCollapsedNav(),
            // Expanded content
            if (_isExpanded)
              Expanded(child: _buildExpandedContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedNav() {
    final role = MockDataService.currentRole;
    final items = _getNavItems(role);

    return SizedBox(
      height: 65,
      child: Column(
        children: [
          // Drag handle - 12px
          GestureDetector(
            onTap: _toggleExpansion,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: 12,
              alignment: Alignment.center,
              child: Container(
                width: 36,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Nav items - 53px remaining
          SizedBox(
            height: 53,
            child: Row(
              children: items.map((item) {
                final isSelected = widget.currentRoute == item.route;
                return Expanded(
                  child: _buildNavItem(item, isSelected),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(NavItem item, bool isSelected) {
    return GestureDetector(
      onTap: () => widget.onNavigate(item.route),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 20,
            color: isSelected ? Colors.white : Colors.white.withAlpha(180),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.white : Colors.white.withAlpha(180),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    final role = MockDataService.currentRole;
    final secondaryItems = _getSecondaryItems(role);

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, Color(0xFF1565C0)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white.withAlpha(50),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'User Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          role == 'NGO' ? 'NGO Official' : 'Citizen',
                          style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Secondary items
            const Text(
              'More Options',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            ...secondaryItems.map((item) => _buildSecondaryItem(item)),
            const SizedBox(height: 16),
            // Sign out
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  MockDataService.setRole('');
                  widget.onNavigate('login');
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.error,
                  side: BorderSide(color: AppTheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryItem(NavItem item) {
    final isSelected = widget.currentRoute == item.route;
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(
        item.icon,
        size: 20,
        color: isSelected ? AppTheme.primary : Colors.grey[600],
      ),
      title: Text(
        item.label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? AppTheme.primary : Colors.black87,
        ),
      ),
      onTap: () => widget.onNavigate(item.route),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: isSelected ? AppTheme.primary.withAlpha(20) : null,
    );
  }

  List<NavItem> _getNavItems(String role) {
    if (role == 'NGO') {
      return [
        NavItem(Icons.dashboard, 'Dashboard', 'ngo_dashboard'),
        NavItem(Icons.warning_amber, 'Reports', 'manage_reports'),
        NavItem(Icons.map, 'Map', 'map'),
        NavItem(Icons.people, 'Community', 'community'),
        NavItem(Icons.person, 'Profile', 'profile'),
      ];
    }
    return [
      NavItem(Icons.home, 'Home', 'home'),
      NavItem(Icons.add_alert, 'Report', 'report'),
      NavItem(Icons.map, 'Map', 'map'),
      NavItem(Icons.people, 'Community', 'community'),
      NavItem(Icons.person, 'Profile', 'profile'),
    ];
  }

  List<NavItem> _getSecondaryItems(String role) {
    if (role == 'NGO') {
      return [
        NavItem(Icons.inventory_2, 'Inventory', 'inventory'),
        NavItem(Icons.campaign, 'Post Updates', 'post_updates'),
        NavItem(Icons.analytics, 'Heatmaps', 'heatmaps'),
        NavItem(Icons.settings, 'Settings', 'settings'),
      ];
    }
    return [
      NavItem(Icons.smart_toy, 'AI Chatbot', 'chatbot'),
      NavItem(Icons.my_location, 'Location', 'location'),
      NavItem(Icons.phone, 'Hotlines', 'hotline'),
      NavItem(Icons.settings, 'Settings', 'settings'),
    ];
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final String route;

  NavItem(this.icon, this.label, this.route);
}
