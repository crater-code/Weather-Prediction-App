// lib/widgets/responsive_drawer.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/mock_data_service.dart';

class ResponsiveDrawer extends StatelessWidget {
  final Function(String) onNavigate;
  final String currentRoute;

  const ResponsiveDrawer({
    super.key,
    required this.onNavigate,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final role = MockDataService.currentRole;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 768;
        
        return Container(
          width: isWideScreen ? 280 : 260,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, role, isWideScreen),
                const Divider(height: 1),
                Expanded(
                  child: _buildNavigationItems(context, role, isWideScreen),
                ),
                const Divider(height: 1),
                _buildFooter(context, isWideScreen),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, String role, bool isWideScreen) {
    return Container(
      padding: EdgeInsets.all(isWideScreen ? 24 : 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: isWideScreen ? 32 : 28,
            backgroundColor: AppTheme.primary,
            child: Text(
              'U',
              style: TextStyle(
                color: Colors.white,
                fontSize: isWideScreen ? 24 : 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'User Name',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.neutral800,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: role == 'NGO' 
                  ? AppTheme.primary.withOpacity(0.1)
                  : AppTheme.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              role == 'NGO' ? 'NGO Official' : 'Citizen',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: role == 'NGO' ? AppTheme.primary : AppTheme.info,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItems(BuildContext context, String role, bool isWideScreen) {
    final items = role == 'NGO' ? _getNGOItems() : _getCitizenItems();
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: isWideScreen ? 16 : 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = currentRoute == item.route;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onNavigate(item.route),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideScreen ? 16 : 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppTheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppTheme.primary.withOpacity(0.2)
                            : AppTheme.neutral100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        size: 20,
                        color: isSelected 
                            ? AppTheme.primary
                            : AppTheme.neutral600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected 
                              ? AppTheme.primary
                              : AppTheme.neutral700,
                        ),
                      ),
                    ),
                    if (item.badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item.badge!,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context, bool isWideScreen) {
    return Padding(
      padding: EdgeInsets.all(isWideScreen ? 16 : 12),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // Handle logout
                MockDataService.setRole('');
                onNavigate('login');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: AppTheme.error),
                    const SizedBox(width: 12),
                    Text(
                      'Sign Out',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Emergency Response v1.0',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.neutral500,
            ),
          ),
        ],
      ),
    );
  }

  List<DrawerItem> _getCitizenItems() {
    return [
      DrawerItem(
        icon: Icons.home,
        title: 'Dashboard',
        route: 'home',
      ),
      DrawerItem(
        icon: Icons.report,
        title: 'Report Disaster',
        route: 'report',
      ),
      DrawerItem(
        icon: Icons.map,
        title: 'Map & Alerts',
        route: 'map',
      ),
      DrawerItem(
        icon: Icons.smart_toy,
        title: 'AI Chatbot',
        route: 'chatbot',
      ),
      DrawerItem(
        icon: Icons.my_location,
        title: 'Location Calibration',
        route: 'location',
      ),
      DrawerItem(
        icon: Icons.phone,
        title: 'Emergency Hotlines',
        route: 'hotline',
      ),
      DrawerItem(
        icon: Icons.settings,
        title: 'Settings',
        route: 'settings',
      ),
      DrawerItem(
        icon: Icons.person,
        title: 'Edit Profile',
        route: 'profile',
      ),
    ];
  }

  List<DrawerItem> _getNGOItems() {
    return [
      DrawerItem(
        icon: Icons.dashboard,
        title: 'NGO Dashboard',
        route: 'ngo_dashboard',
      ),
      DrawerItem(
        icon: Icons.emergency,
        title: 'Manage Reports',
        route: 'manage_reports',
        badge: '3',
      ),
      DrawerItem(
        icon: Icons.inventory_2,
        title: 'Inventory Management',
        route: 'inventory',
      ),
      DrawerItem(
        icon: Icons.map,
        title: 'Incident Map & Heatmaps',
        route: 'map',
      ),
      DrawerItem(
        icon: Icons.campaign,
        title: 'Post Official Updates',
        route: 'post_updates',
      ),
      DrawerItem(
        icon: Icons.groups,
        title: 'Community Hub',
        route: 'community',
      ),
      DrawerItem(
        icon: Icons.settings,
        title: 'Settings / Profile',
        route: 'profile',
      ),
    ];
  }
}

class DrawerItem {
  final IconData icon;
  final String title;
  final String route;
  final String? badge;

  DrawerItem({
    required this.icon,
    required this.title,
    required this.route,
    this.badge,
  });
}