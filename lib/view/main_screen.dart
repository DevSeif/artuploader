import 'dart:io';
import 'dart:typed_data';

import 'package:artupload/main.dart';
import 'package:artupload/models/user.dart';
import 'package:artupload/providers/user_provider.dart';
import 'package:artupload/repository/auth_service.dart';
import 'package:artupload/view/login_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 2;
  final posts = FirebaseFirestore.instance.collection('posts');
  User? loggedInUser;
  final _auth = FirebaseAuth.instance;
  UploadTask? uploadTask;
  XFile? _file;
  String path = '';
  final foodNameController = TextEditingController();
  final bioController = TextEditingController();

  Future<String?> getCurrentUser() async {
    try {
      final user = await _auth.currentUser;

      if (user != null) {
        print('Inloggad!');
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    _file = await _imagePicker.pickImage(source: source);
    if (_file == null) return;

    path = 'files/${_file!.name}';
    final file = File(_file!.path!);
    return file;
  }

  Future uploadImage(File file, String food, String bio) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download the URL: $urlDownload');
    posts.add({
      'foodName': food,
      'imageUrl': urlDownload,
      'user': context.read<UserProvider>().user?.username,
      'bio': bio,
    });
  }

  showModal(File file) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 250,
                      ),
                      child: Image.file(file)),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: TextField(
                      controller: foodNameController,
                      decoration: InputDecoration(
                        labelText: 'Food name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.lunch_dining,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 15,
                      controller: bioController,
                      decoration: InputDecoration(
                        labelText: 'Information',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.text_snippet,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: 200,
                    child: ElevatedButton(
                        onPressed: () async {
                          await uploadImage(file, foodNameController.text,
                              bioController.text);
                          Navigator.pop(context);
                          foodNameController.clear();
                          bioController.clear();
                        },
                        child: Text('Upload')),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  File file = await pickImage(ImageSource.camera);
                  showModal(file);
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  File file = await pickImage(ImageSource.gallery);
                  showModal(file);
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('Execute dispose');
  }

  final screens = [SearchScreen(), Container(), HomeScreen(),];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              height: height * .1,
              indicatorColor: Colors.blue.shade100,
              labelTextStyle: MaterialStateProperty.all(
                TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              )),
          child: NavigationBar(
              selectedIndex: index,
              destinations: [
                NavigationDestination(icon: Icon(Icons.menu), label: 'Search'),
                NavigationDestination(icon: Icon(Icons.add), label: 'Upload'),
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              ],
              onDestinationSelected: (index) => setState(() {
                    final snackBar = SnackBar(
                      content: const Text("You have to log in to upload"),
                    );
                    if (index == 1) {
                      if (loggedInUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        _selectImage(context);
                        print('Executed');
                      }
                    } else {
                      this.index = index;
                    }
                  }))),
      body: SafeArea(
        child: screens[index],
      ),
    );
  }
}




class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Search screen'),
    );
  }
}

