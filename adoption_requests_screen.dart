import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdoptionRequestsScreen extends StatelessWidget {
  const AdoptionRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollectionReference requests =
        FirebaseFirestore.instance.collection('adoption_requests');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Adoption Requests"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: requests.orderBy('submittedAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No adoption requests yet."));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>? ?? {};
              final status = data['status'] ?? "Pending";

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: ListTile(
                  title: Text(data['petName'] ?? "Unnamed Pet"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User: ${data['userName'] ?? '-'}"),
                      Text("Email: ${data['userEmail'] ?? '-'}"),
                      Text("Phone: ${data['userPhone'] ?? '-'}"),
                      Text("Status: $status"),
                    ]
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Approve button
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: status == "Pending"
                            ? () async {
                                await requests
                                    .doc(docs[index].id)
                                    .update({'status': 'Approved'});
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Request Approved")));
                              }
                            : null,
                      ),

                      // Reject button
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: status == "Pending"
                            ? () async {
                                await requests
                                    .doc(docs[index].id)
                                    .update({'status': 'Rejected'});
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Request Rejected")));
                              }
                            : null,
                      ),

                      // DELETE button (added)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () async {
                          await requests.doc(docs[index].id).delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Request Deleted")),
                          );
                        },
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