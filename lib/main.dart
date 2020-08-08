import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/Models/users.dart';
import 'package:smart_meter/Services/auth.dart';
import 'package:smart_meter/layouts/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: Color(0xff7E4D8B)),
        home: Wrapper(),
      ),
    );
  }
}