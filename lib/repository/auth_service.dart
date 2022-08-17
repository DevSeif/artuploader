import 'package:artupload/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  User? loggedInUser;
  final _auth = FirebaseAuth.instance;
  final accounts = FirebaseFirestore.instance.collection('users');

  Future<void> authSignout() async {
    await _auth.signOut();
  }

  Future<String> authLogin(String email, String password)async{
    final newUser = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    if (newUser != null) {
      return 'success';
    }
    return 'fail';
  }

  Future<String> authSignup(String username, String email, String password)async{
    final newUser = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (newUser != null) {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      await users.doc(newUser.user!.uid).set({'name': username, 'email': email,});
      return 'success';
    }
    return 'fail';
  }

  Future getUsername() async{
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return UserData(username: snapshot['name'], uid: userId, email: snapshot['email']);
  }


  Future<String?> getCurrentUser() async {
    try {
      final user = await _auth.currentUser;

      if (user != null) {
        loggedInUser = user;
        return loggedInUser!.email;
      }
    } catch (e) {
      print(e);
    }
  }




}