import 'package:flutter/material.dart';
import '../main.dart';   // IMPORTANT: to access theme toggle
import 'notification_settings_screen.dart';
import 'privacy_settings_screen.dart';
import 'about_app_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.deepPurple,
      ),

      body: ListView(
        children: [

          /// ⭐ DARK MODE SWITCH
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            value: MyApp.of(context)!.isDarkMode,
            onChanged: (value) {
              MyApp.of(context)!.toggleTheme(value);
            },
          ),

          /// NOTIFICATION SETTINGS
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notification Settings"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),

          /// PRIVACY SETTINGS
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Privacy Settings"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacySettingsScreen(),
                ),
              );
            },
          ),

          /// ABOUT APP
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About App"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutAppScreen(),
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}