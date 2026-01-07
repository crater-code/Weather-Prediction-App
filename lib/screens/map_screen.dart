// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: Navigator.canPop(context) ? IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: const Text('Disaster Map'),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 768;
            final padding = isTablet ? 24.0 : 16.0;
            
            return Padding(
              padding: EdgeInsets.only(
                left: padding,
                right: padding,
                top: padding,
                bottom: 120, // Space for expandable bottom nav
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppTheme.slate100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.map_outlined, 
                                size: isTablet ? 64 : 48, 
                                color: AppTheme.slate400,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Interactive Map',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.slate800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                'Real-time disaster markers and affected areas will be displayed here',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.slate500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: isTablet ? 140 : 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: 4,
                      itemBuilder: (context, i) => _buildLocationCard(context, i, isTablet),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, int index, bool isTablet) {
    final isFlood = index % 2 == 0;
    final title = isFlood ? 'Flood near Riverside' : 'Earthquake epicenter';
    final severity = index % 3 == 0 ? 'High' : 'Warning';
    final color = isFlood ? AppTheme.info : AppTheme.warning;
    final icon = isFlood ? Icons.water_drop : Icons.terrain;
    
    return Container(
      width: isTablet ? 280 : 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.slate800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: severity == 'High' 
                    ? AppTheme.error.withOpacity(0.1)
                    : AppTheme.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Severity: $severity',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: severity == 'High' ? AppTheme.error : AppTheme.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: AppTheme.slate400),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Coordinates: ${12.3456 + index}, ${-98.7654 - index}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.slate500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
