// // ignore_for_file: must_be_immutable
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../Utils/utils.dart';
// import 'add_post_screen.dart';
// import 'login_screen.dart';

// class PostScreen extends StatelessWidget {
//   // PostScreen({super.key});
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueGrey,
//         title: const Text('Post Screen'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               _auth.signOut().then((value) {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const LoginScreen()));
//               }).onError((error, stackTrace) {
//                 Utils().toastMessage(error.toString());
//               });
//             },
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => const AddPostScreen()));
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
