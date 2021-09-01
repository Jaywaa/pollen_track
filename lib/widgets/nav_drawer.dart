import 'package:flutter/material.dart';
import 'package:pollen_track/providers/user_settings_provider.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final userSettingsProvider = Provider.of<UserSettingsProvider>(context, listen: false);
    final isDarkMode = userSettingsProvider.isDarkMode();
    final notificationsEnabled = userSettingsProvider.notificationsEnabled();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SwitchListTile(
            value: isDarkMode, 
            title: ListTile(leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode), 
            title: Text('Dark Mode')), onChanged: userSettingsProvider.setDarkMode,
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            value: notificationsEnabled, 
            title: ListTile(leading: Icon(Icons.notifications), 
            title: Text('Notifications')), onChanged: userSettingsProvider.setNotificationsEnabled,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
