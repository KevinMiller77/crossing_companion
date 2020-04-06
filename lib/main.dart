import 'package:flutter/material.dart';
import 'package:crossing_companion/ui/root.dart';
import 'package:crossing_companion/web/web_landing_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  if (kIsWeb)
  {
    print("on web");
    runApp(CCWebAppMain());
  }
  else
  {
    runApp(CCAppMain());
  }
}
class CCWebAppMain extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crossing Companion',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),

      home: WebLandingPage(),
    );
  }
}
class CCAppMain extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crossing Companion',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      
      home: CCRootPage(auth: Auth(),),
      
    );
  }
}
