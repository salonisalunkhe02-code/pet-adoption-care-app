import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Correct imports – adjust folder structure if needed
import 'manage_pets_screen.dart';
import 'adoption_requests_screen.dart';
import 'admin_reports_screen.dart';
import 'admin_settings_screen.dart';
import 'admin_users_screen.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          // Manage Pets
          _adminCard(Icons.pets, "Manage Pets", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManagePetsScreen()),
            );
          }),
          // Manage Users
          _adminCard(Icons.people, "Manage Users", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminUsersScreen()),
            );
          }),
          // Adoption Requests
          _adminCard(Icons.assignment, "Adoption Requests", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdoptionRequestsScreen()),
            );
          }),
          // View Reports
          _adminCard(Icons.analytics, "View Reports", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminReportsScreen()),
            );
          }),
          // Settings
          _adminCard(Icons.settings, "Settings", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminSettingsScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _adminCard(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.deepPurple),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}