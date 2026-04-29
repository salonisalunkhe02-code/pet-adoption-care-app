import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adoption_form_screen.dart';
import 'pet_detail_screen.dart';

class AdoptPetScreen extends StatelessWidget {
  const AdoptPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adopt a Pet"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pets').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final pets = snapshot.data!.docs;

          if (pets.isEmpty) {
            return const Center(child: Text("No pets available"));
          }

          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: pet['image'] != null
                      ? Image.network(
                          pet['image'],
                          width: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.pets, size: 60),
                  title: Text(pet['name']),
                  subtitle: Text("${pet['breed']} • ${pet['age']} • Shelter: ${pet['shelter'] ?? 'Unknown'}"),

                  // Adopt button
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdoptionFormScreen(
                            petId: pet.id,
                            petName: pet['name'],
                             petPrice: int.tryParse(pet['price'].toString()) ?? 0,
                          ),
                        ),
                      );
                    },
                    child: const Text("Adopt"),
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PetDetailScreen(pet: pet),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
} 