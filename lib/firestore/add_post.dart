import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_firebase/Utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('User');
  File? image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage fs =
      firebase_storage.FirebaseStorage.instance;

  Future getImageFromGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        return;
      }
    });
  }

  Future<String> uploadImageToFirebaseStorage(
      File file, String fileName) async {
    firebase_storage.Reference ref = fs.ref().child('images/$fileName');
    await ref.putFile(file);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> addPostToFirestore(String imageUrl) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore.instance.collection('User').doc(id).set({
      'title': postController.text.toString(),
      'id': id,
      'image_url': imageUrl,
    }).then((value) {
      Utils().toastMessage('Post Added');
      postController.clear();
      image = null;
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text(
          'Add Firestore data',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              TextFormField(
                controller: postController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (image != null) {
                    setState(() {
                      loading = true;
                    });

                    String fileName =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    String imageUrl =
                        await uploadImageToFirebaseStorage(image!, fileName);
                    await addPostToFirestore(imageUrl);
                  } else {
                    Utils().toastMessage('Please select an image');
                  }
                },
                child: loading == false
                    ? const Text('Add')
                    : const CircularProgressIndicator(),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: getImageFromGallery,
                child: image == null
                    ? Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image,
                          ),
                        ),
                      )
                    : Image.file(
                        image!,
                        height: 100,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:learn_firebase/Utils/utils.dart';

// class AddPostScreen extends StatefulWidget {
//   const AddPostScreen({super.key});

//   @override
//   State<AddPostScreen> createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends State<AddPostScreen> {
//   final postController = TextEditingController();
//   bool loading = false;
//   final fireStore = FirebaseFirestore.instance.collection('User');
//   int number = 0;
//   File? image;
//   final picker = ImagePicker();

//   Future getImageFromGelary() async {
//     final pickedFile =
//         await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
//     setState(() {
//       if (pickedFile != null) {
//         image = File(pickedFile.path);
//       } else {
//         return;
//       }
//     });
//   }

//   firebase_storage.FirebaseStorage fs =
//       firebase_storage.FirebaseStorage.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueGrey,
//         centerTitle: true,
//         title: const Text(
//           'Add Firestore data',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: postController,
//                 maxLines: 4,
//                 decoration: const InputDecoration(
//                   hintText: 'Whats in Your mind',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     loading = true;
//                   });

//                   String id = DateTime.now().millisecondsSinceEpoch.toString();
//                   fireStore.doc(id).set({
//                     'title': postController.text.toString(),
//                     'id': id
//                   }).then((value) {
//                     Utils().toastMessage('Post Added');
//                     postController.clear();
//                     setState(() {
//                       loading = false;
//                     });
//                   }).onError((error, stackTrace) {
//                     Utils().toastMessage(error.toString());
//                     setState(() {
//                       loading = false;
//                     });
//                   });
//                 },
//                 child: loading == false
//                     ? const Text('Add')
//                     : const CircularProgressIndicator(),
//               ),
//               const SizedBox(height: 12),
//               InkWell(
//                 onTap: getImageFromGelary,
//                 child: image == null
//                     ? Container(
//                         height: 200,
//                         width: 200,
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                           color: Colors.black,
//                         )),
//                         child: const Center(
//                           child: Icon(
//                             Icons.image,
//                           ),
//                         ),
//                       )
//                     : Image.file(
//                         image!.absolute,
//                         height: 100,
//                       ),
//               ),
//               ElevatedButton(
//                 onPressed: () {},
//                 child: const Text('Upload'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
