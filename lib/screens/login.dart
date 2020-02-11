import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../database_config/sign_in.dart';
import './home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'CRUD',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
            Text(
              'TEST',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              padding: EdgeInsets.only(top: 80),
              child: RaisedButton(
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/google_logo.png'),
                        height: 35,
                      ),
                      Text('LOGIN WITH GOOGLE'),
                    ],
                  ),
                ),
                onPressed: !_loading
                    ? () async {
                        setState(() {
                          _loading = true;
                        });
                        signInWithGoogle().whenComplete(() {
                          Navigator.of(context)
                              .pushReplacementNamed(HomeScreen.routeName);
                        });
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
