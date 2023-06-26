// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Utils/utils.dart';
import '../ui/login_screen.dart';
import 'add_post.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final searchController = TextEditingController();
  final editController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection('User').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('User');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        title: const Text('Firestore'),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text('Error');
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var user = snapshot.data!.docs[index];
                        return ListTile(
                          leading: Image.network(user['image_url']),
                          title: Text(user['title'].toString()),
                          subtitle: Text(user['id'].toString()),
                          trailing: IconButton(
                              onPressed: () {
                                ShowMyDialog(user['title'].toString(),
                                    user['id'].toString());
                              },
                              icon: const Icon(Icons.line_weight_sharp)),
                        );
                      }),
                );
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> ShowMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: SizedBox(
              child: TextField(
                controller: editController,
                decoration: const InputDecoration(hintText: 'Edit'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ref.doc(id).delete();

                  Navigator.pop(context);
                },
                child: const Text('delete'),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .doc(id)
                      .update({'title': editController.text}).then((value) {
                    Utils().toastMessage('Post Updated');
                    editController.clear();
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }
}
