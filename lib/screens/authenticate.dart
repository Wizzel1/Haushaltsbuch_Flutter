import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/services/auth.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FlatButton(
        child: Container(),
        onPressed: () => _auth.signInWithEmailAndPassword('test1@email.com', 'test123456'),
      ),
    );
  }
}
