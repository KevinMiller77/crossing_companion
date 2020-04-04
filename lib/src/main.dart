import 'package:flutter/material.dart';
import 'ui/login.dart';

void main() => runApp(CCAppMain());

class CCAppMain extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crossing Companion',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      
      home: KevLoginPage(title: 'Login Page'),
      

    );
  }
}
