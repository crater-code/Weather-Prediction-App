// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _locationServices = true;
  bool _emergencyAlerts = true;
  bool _communityUpdates = false;
  bool _darkMode = false;
  String _language = 'English';
  String _emergencyContact = '+1 (555) 123-4567';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.slate50,
      appBar: AppBar(
        leading: Navigator.canPop(context) ? IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: const Text('Settings'),
        backgroundColor: AppTheme.slate50,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'Notifications',
              Icons.notifications_outlined,
              [
                _buildSwitchTile(
                  'Push Notifications',
                  'Receive app notifications',
                  _pushNotifications,
                  (value) => setState(() => _pushNotifications = value),
                ),
                _buildSwitchTile(
                  'Emergency Alerts',
                  'Critical disaster warnings',
                  _emergencyAlerts,
                  (value) => setState(() => _emergencyAlerts = value),
                ),
                _buildSwitchTile(
                  'Community Updates',
                  'New posts and comments',
                  _communityUpdates,
                  (value) => setState(() => _communityUpdates = value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Privacy & Security',
              Icons.security_outlined,
              [
                _buildSwitchTile(
                  'Location Services',
                  'Allow location access for reports',
                  _locationServices,
                  (value) => setState(() => _locationServices = value),
                ),
                _buildActionTile(
                  'Emergency Contact',
                  _emergencyContact,
                  Icons.contact_phone,
                  () => _editEmergencyContact(),
                ),
                _buildActionTile(
                  'Privacy Policy',
                  'View our privacy policy',
                  Icons.privacy_tip_outlined,
                  () => _showPrivacyPolicy(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Appearance',
              Icons.palette_outlined,
              [
                _buildSwitchTile(
                  'Dark Mode',
                  'Use dark theme',
                  _darkMode,
                  (value) => setState(() => _darkMode = value),
                ),
                _buildDropdownTile(
                  'Language',
                  _language,
                  ['English', 'Spanish', 'French', 'German'],
                  (value) => setState(() => _language = value!),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Support',
              Icons.help_outline,
              [
                _buildActionTile(
                  'Help Center',
                  'Get help and support',
                  Icons.help_center_outlined,
                  () => _showHelpCenter(),
                ),
                _buildActionTile(
                  'Report a Bug',
                  'Send feedback to developers',
                  Icons.bug_report_outlined,
                  () => _reportBug(),
                ),
                _buildActionTile(
                  'About',
                  'App version and info',
                  Icons.info_outline,
                  () => _showAbout(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Account',
              Icons.account_circle_outlined,
              [
                _buildActionTile(
                  'Export Data',
                  'Download your data',
                  Icons.download_outlined,
                  () => _exportData(),
                ),
                _buildActionTile(
                  'Delete Account',
                  'Permanently delete account',
                  Icons.delete_outline,
                  () => _deleteAccount(),
                  isDestructive: true,
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildVersionInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.slate600),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.slate800,
                ),
              ),
            ],
          ),
        ),
        Container(
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
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.slate800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.slate500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDestructive 
                      ? AppTheme.error.withOpacity(0.1)
                      : AppTheme.slate100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isDestructive ? AppTheme.error : AppTheme.slate600,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? AppTheme.error : AppTheme.slate800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.slate500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppTheme.slate400,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.slate800,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.slate50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.slate200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                items: options.map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                )).toList(),
                onChanged: onChanged,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Disaster Alert App',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.slate700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Version 1.0.0 (Build 1)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.slate500,
            ),
          ),
        ],
      ),
    );
  }

  void _editEmergencyContact() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _emergencyContact);
        return AlertDialog(
          title: const Text('Emergency Contact'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '+1 (555) 123-4567',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() => _emergencyContact = controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text('Privacy policy content would be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening help center...')),
    );
  }

  void _reportBug() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bug report form opened')),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Disaster Alert App',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 Disaster Response Team',
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data export started...')),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
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
                const SnackBar(content: Text('Account deletion initiated')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}