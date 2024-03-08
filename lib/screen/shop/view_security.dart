import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preorder/screen/shop/add_security.dart';

class ViewSecurity extends StatefulWidget {
  const ViewSecurity({super.key});

  @override
  State<ViewSecurity> createState() => _ViewSecurityState();
}

class _ViewSecurityState extends State<ViewSecurity> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Securities'),
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AddSecurity()));
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _firestore
            .collection('users')
            .where('type', isEqualTo: 'security')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<DocumentSnapshot> securityDocs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: securityDocs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    securityDocs[index].data() as Map<String, dynamic>;
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      data['username'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      data['email'],
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
