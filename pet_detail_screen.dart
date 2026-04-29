import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adoption_form_screen.dart';

class PetDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pet['name'])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              pet['image'],
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet['name'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text("Breed: ${pet['breed']}"),
                  Text("Age: ${pet['age']}"),
                  Text("Shelter: ${pet['shelter'] ?? 'Unknown'}"),
                  Text("Price: ₹${pet['price']}"),
                  const SizedBox(height: 15),
                  Text(pet['description']),
                  const SizedBox(height: 25),

                  // ❤️ FAVORITE + ADOPT BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.favorite_border),
                          label: const Text("Add to Favorites"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('favorites')
                                .doc('demo_user')
                                .collection('pets')
                                .doc(pet.id)
                                .set({
                              'name': pet['name'],
                              'image': pet['image'],
                              'breed': pet['breed'],
                              'age': pet['age'],
                              'price': pet['price'],
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Added to Favorites ❤️"),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.pets),
                          label: const Text("Adopt Me"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
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
                        ),
                      ),
                    ],
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