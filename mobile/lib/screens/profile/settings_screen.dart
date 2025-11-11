import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification Settings
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _bookingReminders = true;
  bool _messageNotifications = true;
  bool _promotionalEmails = false;

  // App Settings
  String _language = 'English';
  String _currency = 'USD';
  bool _darkMode = false;

  // Privacy Settings
  bool _showProfile = true;
  bool _showActivity = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Notifications',
            children: [
              SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Receive push notifications'),
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Email Notifications'),
                subtitle: const Text('Receive email updates'),
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Booking Reminders'),
                subtitle: const Text('Get reminders about upcoming bookings'),
                value: _bookingReminders,
                onChanged: (value) {
                  setState(() {
                    _bookingReminders = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Message Notifications'),
                subtitle: const Text('Get notified about new messages'),
                value: _messageNotifications,
                onChanged: (value) {
                  setState(() {
                    _messageNotifications = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Promotional Emails'),
                subtitle: const Text('Receive deals and offers'),
                value: _promotionalEmails,
                onChanged: (value) {
                  setState(() {
                    _promotionalEmails = value;
                  });
                },
              ),
            ],
          ),
          _buildSection(
            title: 'App Preferences',
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: Text(_language),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(),
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Currency'),
                subtitle: Text(_currency),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCurrencyDialog(),
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Use dark theme'),
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                  });
                  // TODO: Implement theme switching
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Privacy',
            children: [
              SwitchListTile(
                title: const Text('Public Profile'),
                subtitle: const Text('Make your profile visible to agents'),
                value: _showProfile,
                onChanged: (value) {
                  setState(() {
                    _showProfile = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Show Activity'),
                subtitle: const Text('Let others see your activity'),
                value: _showActivity,
                onChanged: (value) {
                  setState(() {
                    _showActivity = value;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Show terms of service
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Security',
            children: [
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to change password
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Two-Factor Authentication'),
                subtitle: const Text('Not enabled'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Set up 2FA
                },
              ),
              ListTile(
                leading: const Icon(Icons.devices),
                title: const Text('Active Sessions'),
                subtitle: const Text('Manage your devices'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Show active sessions
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Support',
            children: [
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help Center'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to help center
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: const Text('Contact Support'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Contact support
                },
              ),
              ListTile(
                leading: const Icon(Icons.bug_report),
                title: const Text('Report a Problem'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Report problem
                },
              ),
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Rate Us'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Open app store rating
                },
              ),
            ],
          ),
          _buildSection(
            title: 'About',
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('App Version'),
                subtitle: const Text('0.1.0'),
              ),
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text('Check for Updates'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You\'re using the latest version'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.article),
                title: const Text('Licenses'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'MarketMate',
                    applicationVersion: '0.1.0',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'MarketMate © 2025',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(children: children),
        ),
      ],
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'English',
            'Spanish',
            'French',
            'German',
            'Chinese',
            'Japanese',
            'Arabic',
          ].map((language) {
            return RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'USD - US Dollar',
            'EUR - Euro',
            'GBP - British Pound',
            'JPY - Japanese Yen',
            'AED - UAE Dirham',
            'SGD - Singapore Dollar',
          ].map((currency) {
            final code = currency.split(' - ')[0];
            return RadioListTile<String>(
              title: Text(currency),
              value: code,
              groupValue: _currency,
              onChanged: (value) {
                setState(() {
                  _currency = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
