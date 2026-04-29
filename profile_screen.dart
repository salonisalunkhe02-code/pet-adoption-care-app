import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String userName = "User Name";
  String userEmail = "user@email.com";

  int adoptedCount = 0;
  int favoriteCount = 0;
  int reminderCount = 0;

  Widget profileTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget statBox(String title, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25),
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),

              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 60, color: Colors.deepPurple),
                  ),

                  const SizedBox(height: 10),

                  /// USER NAME (DYNAMIC)
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),

                  /// USER EMAIL (DYNAMIC)
                  Text(
                    userEmail,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// STATS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                statBox("Adopted", adoptedCount.toString()),
                statBox("Favorites", favoriteCount.toString()),
                statBox("Reminders", reminderCount.toString()),
              ],
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [

                  /// EDIT PROFILE
                  profileTile(
                    context,
                    Icons.edit,
                    "Edit Profile",
                    () async {

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          userName = result["name"];
                          userEmail = result["email"];
                        });
                      }

                    },
                  ),

                  /// FAVORITES
                  profileTile(
                    context,
                    Icons.favorite,
                    "My Favorites",
                    () {
                      Navigator.pushNamed(context, '/favorites');

                      setState(() {
                        favoriteCount++;
                      });

                    },
                  ),

                  /// CARE REMINDER
                  profileTile(
                    context,
                    Icons.notifications,
                    "Care Reminder",
                    () {
                      Navigator.pushNamed(context, '/careReminder');

                      setState(() {
                        reminderCount++;
                      });

                    },
                  ),

                  /// SETTINGS
                  profileTile(
                    context,
                    Icons.settings,
                    "Settings",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),

                  /// LOGOUT
                  profileTile(
                    context,
                    Icons.logout,
                    "Logout",
                    () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}