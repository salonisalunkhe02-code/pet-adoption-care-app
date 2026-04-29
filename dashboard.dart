import 'package:flutter/material.dart';
import 'adopt_pet_screen.dart';
import 'favorites_screen.dart';
import 'care_reminder_screen.dart';
import 'profile_screen.dart';
import 'payment_screen.dart'; 
import 'pet_care_tips_screen.dart'; // ✅ ADD THIS

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌈 Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF667EEA),
                  Color(0xFF764BA2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 🐾 Soft Paw Overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Icon(
                Icons.pets,
                size: 300,
                color: Colors.white,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 🔥 Premium Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: const [
                      Text(
                        "Welcome 🐾",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        children: [
                          dashboardCard(
                            context,
                            "Adopt Pet",
                            Icons.pets,
                            Colors.deepPurple,
                            const AdoptPetScreen(),
                          ),
                          dashboardCard(
                            context,
                            "Favorites",
                            Icons.favorite,
                            Colors.red,
                            const FavoritesScreen(),
                          ),
                          dashboardCard(
                            context,
                            "Care Reminder",
                            Icons.alarm,
                            Colors.blue,
                            const CareReminderScreen(),
                          ),
                          dashboardCard(
                            context,
                            "Profile",
                            Icons.person,
                            Colors.green,
                            const ProfileScreen(),
                          ),
                          dashboardCard(
  context,
  "Pet Care Tips",
  Icons.pets,
  Colors.orange,
  const PetCareTipsScreen(),
),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(2, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}