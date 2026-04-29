import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {

              final user = users[index];

              // Safely convert Firestore data
              final data = user.data() as Map<String, dynamic>;

              String name = data.containsKey('name') ? data['name'] : "No Name";
              String email = data.containsKey('email') ? data['email'] : "No Email";

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, color: Colors.white),
                  ),

                  title: Text(name),
                  subtitle: Text(email),

                  trailing: PopupMenuButton(
                    onSelected: (value) async {

                      if (value == 'block') {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.id)
                            .update({'blocked': true});
                      }

                      if (value == 'unblock') {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.id)
                            .update({'blocked': false});
                      }

                      if (value == 'delete') {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.id)
                            .delete();
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'block',
                        child: Text("Block User"),
                      ),
                      PopupMenuItem(
                        value: 'unblock',
                        child: Text("Unblock User"),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text("Delete User"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}