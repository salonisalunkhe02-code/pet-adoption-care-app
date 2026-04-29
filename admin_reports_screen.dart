import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  Future<int> _getCount(String collection, {String? field, String? value}) async {
    Query query = FirebaseFirestore.instance.collection(collection);

    // Optional filter for approved/rejected requests
    if (field != null && value != null) {
      query = query.where(field, isEqualTo: value);
    }

    final snapshot = await query.get();
    return snapshot.size;
  }

  Widget _reportCard(String title, int count, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(count.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: Future.wait([
            _getCount('pets'), // total pets
            _getCount('adoption_requests'), // total requests
            _getCount('adoption_requests', field: 'status', value: 'approved'),
            _getCount('adoption_requests', field: 'status', value: 'rejected'),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final counts = snapshot.data as List<int>;
            final totalPets = counts[0];
            final totalRequests = counts[1];
            final approved = counts[2];
            final rejected = counts[3];

            return GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _reportCard("Total Pets", totalPets, Colors.deepPurple),
                _reportCard("Total Requests", totalRequests, Colors.orange),
                _reportCard("Approved", approved, Colors.green),
                _reportCard("Rejected", rejected, Colors.red),
              ],
            );
          },
        ),
      ),
    );
  }
}