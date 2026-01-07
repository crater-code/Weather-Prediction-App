// lib/screens/ngo_dashboard_screen.dart
import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../theme/app_theme.dart';
import 'ngo_report_management_screen.dart';

class NGODashboardScreen extends StatefulWidget {
  const NGODashboardScreen({super.key});

  @override
  State<NGODashboardScreen> createState() => _NGODashboardScreenState();
}

class _NGODashboardScreenState extends State<NGODashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final posts = MockDataService.fetchPosts();
    final total = posts.length;
    final high = posts.where((p) => p.severity == 'High').length;
    final inProgress = posts.where((p) => p.status == 'In Progress').length;
    final resolved = posts.where((p) => p.status == 'Resolved').length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 768;
            final isMobile = constraints.maxWidth < 600;
            final horizontalPadding = isTablet ? 32.0 : 20.0;
            
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                top: 24,
                bottom: 120, // Space for expandable bottom nav
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCommandHeader(context, isTablet),
                  const SizedBox(height: 32),
                  _buildStatusOverview(context, isTablet),
                  const SizedBox(height: 32),
                  _buildMetricsGrid(context, isTablet, isMobile, total, high, inProgress, resolved),
                  const SizedBox(height: 40),
                  _buildActionCenter(context, isTablet),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCommandHeader(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button row
        if (Navigator.canPop(context))
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF64748B)),
              ),
            ),
          ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(isTablet ? 32 : 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.neutral800, AppTheme.neutral700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crisis Command Center',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NGO Operations Dashboard',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF10B981), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ACTIVE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
              const SizedBox(height: 20),
              Text(
                _getCurrentDateTime(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white60,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusOverview(BuildContext context, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: AppTheme.slate600,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Situation Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.slate800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Real-time monitoring of disaster reports and response coordination across all affected regions.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.slate600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, bool isTablet, bool isMobile, int total, int high, int inProgress, int resolved) {
    final metrics = [
      _MetricData(
        icon: Icons.assessment,
        label: 'Total Reports',
        value: total.toString(),
        color: const Color(0xFF3B82F6),
        trend: '+12%',
        isPositive: true,
        priority: 1,
      ),
      _MetricData(
        icon: Icons.priority_high,
        label: 'High Severity',
        value: high.toString(),
        color: const Color(0xFFDC2626),
        trend: '+3',
        isPositive: false,
        priority: 4, // Highest priority for visual emphasis
      ),
      _MetricData(
        icon: Icons.pending_actions,
        label: 'In Progress',
        value: inProgress.toString(),
        color: const Color(0xFFF59E0B),
        trend: '-2',
        isPositive: true,
        priority: 3,
      ),
      _MetricData(
        icon: Icons.task_alt,
        label: 'Resolved',
        value: resolved.toString(),
        color: const Color(0xFF10B981),
        trend: '+8',
        isPositive: true,
        priority: 2,
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          // High severity gets full width on mobile for emphasis
          _buildMetricCard(context, metrics[1], isTablet, isFullWidth: true),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMetricCard(context, metrics[0], isTablet)),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard(context, metrics[2], isTablet)),
            ],
          ),
          const SizedBox(height: 12),
          _buildMetricCard(context, metrics[3], isTablet, isFullWidth: true),
        ],
      );
    } else if (isTablet) {
      return Row(
        children: metrics.map((metric) => 
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: _buildMetricCard(context, metric, isTablet),
            ),
          )
        ).toList(),
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildMetricCard(context, metrics[0], isTablet)),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard(context, metrics[1], isTablet)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildMetricCard(context, metrics[2], isTablet)),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard(context, metrics[3], isTablet)),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildMetricCard(BuildContext context, _MetricData metric, bool isTablet, {bool isFullWidth = false}) {
    final isHighSeverity = metric.label == 'High Severity';
    
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isHighSeverity ? Border.all(color: metric.color.withOpacity(0.3), width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: isHighSeverity 
                ? metric.color.withOpacity(0.15)
                : Colors.black.withOpacity(0.05),
            blurRadius: isHighSeverity ? 15 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: metric.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  metric.icon,
                  color: metric.color,
                  size: isHighSeverity ? 28 : 24,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: metric.isPositive 
                      ? const Color(0xFFDCFDF7) 
                      : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      metric.isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 12,
                      color: metric.isPositive 
                          ? const Color(0xFF059669) 
                          : const Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      metric.trend,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: metric.isPositive 
                            ? const Color(0xFF059669) 
                            : const Color(0xFFDC2626),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            metric.value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isHighSeverity ? metric.color : AppTheme.slate800,
              fontSize: isHighSeverity ? 36 : 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            metric.label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.slate600,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (isHighSeverity) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: metric.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'REQUIRES IMMEDIATE ATTENTION',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: metric.color,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionCenter(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Command Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.slate800,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (isTablet) {
              return Row(
                children: [
                  Expanded(flex: 2, child: _buildPrimaryAction(context)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSecondaryAction(context)),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildPrimaryAction(context),
                  const SizedBox(height: 12),
                  _buildSecondaryAction(context),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildPrimaryAction(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NGOReportManagementScreen())),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.manage_accounts,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage Reports',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Review, verify, and coordinate response efforts',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryAction(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.slate200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            MockDataService.postOfficialUpdate('Official update from NGO at ${DateTime.now()}');
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.campaign,
                    color: AppTheme.info,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Post Official Update',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.slate800,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Broadcast critical information to the community',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.slate600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.send,
                  color: AppTheme.info,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year} • ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}

class _MetricData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String trend;
  final bool isPositive;
  final int priority;

  _MetricData({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.trend,
    required this.isPositive,
    required this.priority,
  });
}