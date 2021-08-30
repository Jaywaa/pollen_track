import 'package:flutter/material.dart';
import 'package:pollen_track/providers/user_settings_provider.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final userSettingsProvider = Provider.of<UserSettingsProvider>(context, listen: false);
    final isDarkMode = userSettingsProvider.isDarkMode();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SwitchListTile(value: isDarkMode, title: Text('Dark Mode'), onChanged: userSettingsProvider.setDarkMode ),
          // ListTile(
          //   enabled: false,
          //   leading: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   onTap: () => {Navigator.of(context).pop()},
          // ),
          ListTile(
            enabled: false,
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          )
        ],
      ),
    );
  }
}
