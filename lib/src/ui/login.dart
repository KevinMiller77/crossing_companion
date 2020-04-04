import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

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
  String username;
  String password;

  final GlobalKey<FormFieldState> _userKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passKey = GlobalKey<FormFieldState>();

  static int swatchColorHex = 0xFFD7AA73;

  static Map<int, Color> color =
  {
  50:Color.fromRGBO (200,141,50, .1),
  100:Color.fromRGBO(200,141,50, .2),
  200:Color.fromRGBO(200,141,50, .3),
  300:Color.fromRGBO(200,141,50, .4),
  400:Color.fromRGBO(200,141,50, .5),
  500:Color.fromRGBO(200,141,50, .6),
  600:Color.fromRGBO(200,141,50, .7),
  700:Color.fromRGBO(200,141,50, .8),
  800:Color.fromRGBO(200,141,50, .9),
  900:Color.fromRGBO(200,141,50, 1),
  };

  MaterialColor swatchColor = MaterialColor(swatchColorHex, color);

  @override void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
          
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Center(
          child: Stack (
            fit: StackFit.expand,
            children: <Widget>[
              Image(
                image: AssetImage("assets/images/LoginBackdrop.jpg"),
                fit:BoxFit.cover,
                color: Colors.black54,
                colorBlendMode: BlendMode.darken,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Spacer(flex: 2,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.info,
                          color: swatchColor,
                          size: 32,
                          semanticLabel: "App information",
                        )
                      ],
                    ),
                  ),
                  Padding(
                    child: Image(
                      image: AssetImage("assets/images/LoginBanner.png"),
                      fit: BoxFit.contain,
                    ),
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  ),
                  Spacer(flex: 6),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: TextFormField(
                      key: _userKey,
                      decoration: InputDecoration(
                        labelText: "Enter Email",
                        labelStyle: TextStyle(
                          color: Colors.white38,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45.0),
                          borderSide: BorderSide(),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45.0),
                          borderSide: BorderSide(color: swatchColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45.0),
                          borderSide: BorderSide(color: swatchColor),
                        ),
                      ),
                      validator: (val)
                      {
                        if (val.length == 0)
                        {
                          return "Email cannot be empty";
                        }
                        username = val;
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: swatchColor,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: TextFormField(
                      key: _passKey,
                      decoration: InputDecoration(
                        labelText: "Enter Password",
                        labelStyle: TextStyle(
                          color: Colors.white38,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45.0),
                          borderSide: BorderSide(),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45.0),
                          borderSide: BorderSide(color: swatchColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45.0),
                          borderSide: BorderSide(color: swatchColor),
                        ),
                        
                      ),
                      validator: (val)
                      {
                        if (val.length == 0)
                        {
                          return "Password cannot be empty";
                        } else 
                        {
                          password = val;
                          return null;
                        }
                      },
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: swatchColor,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(flex: 2),
                      RaisedButton(
                        textTheme: ButtonTextTheme.normal,
                        color: swatchColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0),
                          side: BorderSide(color: swatchColor),
                        ), 
                        child: Text("Create an account", style: TextStyle(color: Colors.black54, fontSize: 18),), 
                        onPressed: () 
                        {
                          //TODO: Go to another screen, the creation screen
                        },
                      ),
                      Spacer(),
                      RaisedButton(
                        textTheme: ButtonTextTheme.normal,
                        color: swatchColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0),
                          side: BorderSide(color: swatchColor),
                        ), 
                        child: Text("Log in with email", style: TextStyle(color: Colors.black54, fontSize: 18),), 
                        onPressed: () 
                        {
                          //TODO: Go to another screen, the creation screen
                            if (_userKey.currentState.validate())
                            {
                              print(username);
                              print(password);
                            }
                        },
                      ),
                      Spacer(flex: 2),
                    ],
                  ),
                  Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(120, 0, 120, 0),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 70,
                      ),
                      child: FlatButton(
                        color:  Colors.black54,
                        shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45.0),
                              side: BorderSide(
                                color: Colors.black54,
                              ),
                        ), 
                        child: Row (
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Sign In with Google", style: TextStyle(color: Colors.white70, fontSize: 16)),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                              child: Image(
                                image: AssetImage("assets/images/GoogleLogo.png"),
                                fit: BoxFit.contain),
                            ),
                          ],
                        ), onPressed: () 
                        {
                          //TODO: Firebase google signin
                          signInWithGoogle().whenComplete(()
                            {
                              log("Signed in with google\n");
                            }
                          );
                        },
                      ),
                    ),
                  ),
                  Spacer(flex: 2),
                  FlatButton(
                        textTheme: ButtonTextTheme.normal,
                        child: Text("Forgot password", style: TextStyle(color: Colors.white)), 
                        onPressed: () 
                        {
                          //TODO: Go to another screen, Forgot password
                        },
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async 
  {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
    }
    
    void signOutGoogle() async
    {
      await googleSignIn.signOut();
    }
}