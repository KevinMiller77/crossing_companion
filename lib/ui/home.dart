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
    

    // Firestore.instance.collection("userinfo").document(widget.userID).get().then((DocumentSnapshot ds) {
    //   ds.data.forEach((key, value) {
    //     if (key == "Username")
    //     {
    //       yourName = value;
    //     }
    //   });
    // });

    print(yourName);
    

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            Text(yourName, style: TextStyle(fontSize: 32),),
            FlatButton(
              child: Text("Sign out"),
              onPressed: (() 
              {
                widget.logoutCallback();
              }),
              )
          ],
        ),
        
      )
    );
  }
}