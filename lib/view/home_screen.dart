import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  User? loggedInUser;
  final posts = FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome back',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    Text(
                      '${context.watch<UserProvider>().user?.username}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () async {

                              await context.read<UserProvider>().signOut();
                              Navigator.pop(context);
                              print('Log out');

                          },
                          icon: Icon(
                            Icons.logout,
                            size: 27,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 10,
          child: StreamBuilder(
              stream: posts.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                if (!snapshots.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                return ListView(
                    children: snapshots.data!.docs.map((painting) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: width, maxHeight: height * .5),
                          color: Colors.grey.shade300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Image(
                                  image: NetworkImage(painting['imageUrl']),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text(
                                      painting['foodName'],
                                      style: TextStyle(),
                                    ),
                                    Text(painting['user']),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList());
              }),
        ),
      ],
    );
  }
}