import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/screens/home.dart';
import 'package:flutter_haushaltsbuch/screens/statistics.dart';
import 'package:flutter_haushaltsbuch/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_haushaltsbuch/models/user.dart';
import 'package:flutter_haushaltsbuch/services/auth.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
        routes: {'/home': (context) => Home(), '/statistics': (context) => Statistics()},
      ),
    );
  }
}
