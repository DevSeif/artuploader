import 'package:artupload/view/register_screen.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';


class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new LoginScreen()));
                },
                child: Text('Login'),
              ),
            ),
            SizedBox(height: 30,),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new RegisterScreen()));
                },
                child: Text('Register'),
              ),
            ),
          ],
        ),
      ), //
    );
  }
}