import 'package:flutter/material.dart';

class AdminNotificationSettingsScreen extends StatefulWidget {
  const AdminNotificationSettingsScreen({super.key});

  @override
  State<AdminNotificationSettingsScreen> createState() =>
      _AdminNotificationSettingsScreenState();
}

class _AdminNotificationSettingsScreenState
    extends State<AdminNotificationSettingsScreen> {
  bool push = true;
  bool email = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Settings"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Push Notifications"),
            value: push,
            onChanged: (val) {
              setState(() => push = val);
            },
          ),
          SwitchListTile(
            title: const Text("Email Notifications"),
            value: email,
            onChanged: (val) {
              setState(() => email = val);
            },
          ),
        ],
      ),
    );
  }
}