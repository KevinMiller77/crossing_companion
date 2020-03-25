import 'package:flutter/material.dart';

class KevLoginPage extends StatefulWidget
{
  KevLoginPage({this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return KevLoginState();
  }
}

class KevLoginState extends State<KevLoginPage>
{
  StringBuffer username;
  StringBuffer password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Center(
        child: Column (
          children: <Widget>[
            Text("This is text\n"),
          ],
        ),
      ),
    );
  }
}