import "package:flutter/material.dart";
import 'package:crossing_companion/ui/root.dart';

class CCHomePage extends StatefulWidget {
  CCHomePage({this.userID, this.auth, this.logoutCallback});

  final String title = "CC Home page";
  final Auth auth;
  final String userID;
  final VoidCallback logoutCallback;

  @override
  _CCHomePageState createState() => _CCHomePageState();
}

class _CCHomePageState extends State<CCHomePage> {

String yourName = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Text("Text"),
        ], 
      )
    );
  }
}