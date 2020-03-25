import 'package:flutter/material.dart';
import 'ui/home.dart';

void main() => runApp(CCAppMain());

class CCAppMain extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      
      home: CCHomePage(title: 'Flutter Demo Home Page'),

    );
  }
}
