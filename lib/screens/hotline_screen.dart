// lib/screens/hotline_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HotlineScreen extends StatelessWidget {
  const HotlineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.slate50,
      appBar: AppBar(
        leading: Navigator.canPop(context) ? IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: const Text('Emergency Hotlines'),
        backgroundColor: AppTheme.slate50,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmergencyHeader(context),
            const SizedBox(height: 24),
            _buildHotlineCard(
              context,
              'Emergency Services',
              '911',
              'Police, Fire, Medical Emergency',
              Icons.local_hospital,
              AppTheme.error,
              isEmergency: true,
            ),
            const SizedBox(height: 16),
            _buildHotlineCard(
              context,
              'Disaster Response Center',
              '1-800-DISASTER',
              'Disaster coordination and assistance',
              Icons.support_agent,
              AppTheme.primary,
            ),
            const SizedBox(height: 16),
            _buildHotlineCard(
              context,
              'Red Cross Emergency',
              '1-800-RED-CROSS',
              'Shelter, food, and emergency aid',
              Icons.favorite,
              AppTheme.error,
            ),
            const SizedBox(height: 16),
            _buildHotlineCard(
              context,
              'FEMA Helpline',
              '1-800-621-3362',
              'Federal disaster assistance',
              Icons.account_balance,
              AppTheme.info,
            ),
            const SizedBox(height: 16),
            _buildHotlineCard(
              context,
              'Poison Control',
              '1-800-222-1222',
              '24/7 poison emergency assistance',
              Icons.medical_services,
              AppTheme.warning,
            ),
            const SizedBox(height: 16),
            _buildHotlineCard(
              context,
              'Crisis Text Line',
              'Text HOME to 741741',
              'Mental health crisis support',
              Icons.chat,
              AppTheme.success,
            ),
            const SizedBox(height: 32),
            _buildQuickActionsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.emergency, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Emergency Contacts',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'In case of immediate danger, call 911 first. These hotlines provide additional support and resources.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotlineCard(
    BuildContext context,
    String title,
    String number,
    String description,
    IconData icon,
    Color color, {
    bool isEmergency = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isEmergency ? Border.all(color: color.withOpacity(0.3), width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: isEmergency 
                ? color.withOpacity(0.15)
                : Colors.black.withOpacity(0.05),
            blurRadius: isEmergency ? 15 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _makeCall(context, number),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.slate800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        number,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.slate500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.phone, color: color, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.slate800,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                context,
                'Share Location',
                Icons.location_on,
                AppTheme.info,
                () => _shareLocation(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionButton(
                context,
                'Emergency SOS',
                Icons.sos,
                AppTheme.error,
                () => _sendSOS(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.slate700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _makeCall(BuildContext context, String number) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Emergency Service'),
        content: Text('Would you like to call $number?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, you would use url_launcher to make the call
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling $number...')),
              );
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  void _shareLocation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location shared with emergency contacts')),
    );
  }

  void _sendSOS(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency SOS'),
        content: const Text('This will send an emergency alert to your contacts and local authorities. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emergency SOS sent!'),
                  backgroundColor: AppTheme.error,
                ),
              );
            },
            child: const Text('Send SOS'),
          ),
        ],
      ),
    );
  }
}