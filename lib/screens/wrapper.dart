import 'package:flutter_haushaltsbuch/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_haushaltsbuch/screens/home.dart';
import 'package:flutter_haushaltsbuch/screens/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
