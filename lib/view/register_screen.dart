import 'package:artupload/view/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:artupload/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class RegisterScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final users = FirebaseFirestore.instance.collection('users');
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Register',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.account_box,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.mail,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await context.read<UserProvider>().signUp(nameController.text ,emailController.text, passwordController.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new MainScreen()));


                  },
                  child: const Text('Sign up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

