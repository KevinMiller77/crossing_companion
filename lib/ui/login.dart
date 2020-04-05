import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'root.dart';

class KevLoginPage extends StatefulWidget
{
  KevLoginPage({this.auth, this.loginCallback});

  final String title = "CC Login page";
  final Auth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() {
    return KevLoginState();
  }
}

class KevLoginState extends State<KevLoginPage> with TickerProviderStateMixin
{
  final databaseReference = Firestore.instance;
  

  String email = "";
  String password = "";
  String passConf = "";
  String username = "";
  bool signingUp;

  bool keyboardVisable = false;
  bool creatingAccount = false;
  double userButtonHeight = 0;

  double buttonPad = 60;
  double errorWidth = 0;
  String errorText = "";

  bool errorPopupVisible = false;
  Duration errorTimeOnScreen = Duration(seconds: 3);
  Duration ms = const Duration(milliseconds: 1);

  startPopupTimer([int milliseconds]) {
    print("Start timer");
    Duration duration = milliseconds == null ? errorTimeOnScreen : ms * milliseconds;
    return Timer(duration, handleErrorTimerUp);
  }

  VoidCallback handleErrorTimerUp()
  {
    print("Timer up");
    setState(() {
      errorPopupVisible = false;
    });

    return null;
  }

  final GlobalKey<FormFieldState> _userKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passConfKey = GlobalKey<FormFieldState>();


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

  Unfocus<bool>(val)
  {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override void initState() {
    signingUp = false;
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
          keyboardVisable = visible;
          if (!keyboardVisable)
          {
            print("Keyboard gone");
            Unfocus(false);
          }
          else
          {
            
          }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    double statusBarHeight = MediaQuery.of(context).padding.top;
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
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(padding: EdgeInsets.only(top: statusBarHeight),),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
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
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 750),
                      padding: EdgeInsets.only(top: buttonPad),
                      child: Container(
                        child: Column (crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                          
                          Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                          child: TextFormField(
                            key: _emailKey,
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
                              email = val;
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              color: swatchColor,
                              fontSize: 32,
                            ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                          child: TextFormField(
                            key: _passKey,
                            onFieldSubmitted: Unfocus,
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
                        
                        AnimatedOpacity(
                          opacity: creatingAccount ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          child: AnimatedSize(
                            vsync: this,
                            duration: Duration(milliseconds: 500),
                            child: Container(
                              height: userButtonHeight,
                              padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                              child: Column(children: <Widget>[
                                TextFormField(
                                key: _passConfKey,
                                obscureText: true,
                                onFieldSubmitted: Unfocus,
                                decoration: InputDecoration(
                                  labelText: "Re-enter Password",
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
                                  if (val.length == 0 && creatingAccount)
                                  {
                                    return "Please re-enter your password!";
                                  } else 
                                  {
                                    _passKey.currentState.validate();
                                    if (val != password) return "Passwords must match!";

                                    username = val;
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: swatchColor,
                                  fontSize: 32,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 32),),
                                TextFormField(
                                key: _userKey,
                                onFieldSubmitted: Unfocus,
                                decoration: InputDecoration(
                                  labelText: "Enter Username",
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
                                  if (val.length == 0 && creatingAccount)
                                  {
                                    return "Username cannot be empty";
                                  } else 
                                  {
                                    username = val;
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: swatchColor,
                                  fontSize: 32,
                                ),
                              ),
                              ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
                            if (creatingAccount){
                            //TODO: Go to another screen, the creation screen
                              if (_emailKey.currentState.validate() && _passKey.currentState.validate() && _passConfKey.currentState.validate() && _userKey.currentState.validate())
                              {
                                signingUp = true;
                                SubmitCreds();   

                              }
                            }
                            else
                            {
                              setState(() {
                                if (!errorPopupVisible)
                                {
                                  buttonPad = creatingAccount ? 60 : 0;
                                  userButtonHeight = 206;
                                  creatingAccount = true;
                                }
                              });
                            }
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
                            if (_emailKey.currentState.validate() && _passKey.currentState.validate())
                            {
                                print("Login");
                                signingUp = false;
                                SubmitCreds();
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
                            widget.auth.googleSignIn().whenComplete(()
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
                          onPressed: () async
                          {
                            if (_emailKey.currentState.validate())
                            {
                              FirebaseUser user = await widget.auth.getCurrentUser();
                            }
                            //TODO: Go to another screen, Forgot password
                            
                          },
                        ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,                  
                    children: <Widget>[
                      Spacer(flex: 2),
                      Container(
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          height: errorPopupVisible ? 100 : 80,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 750),
                            opacity: errorPopupVisible ? 1.0 : 0.0,
                            child: RaisedButton(
                              textTheme: ButtonTextTheme.normal,
                              color: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(45.0),
                                side: BorderSide(color: Colors.black87),
                            ), 

                            child: Column(
                              children: <Widget>[
                                Spacer(flex: 2),
                                Icon(
                                  Icons.info,
                                  color: swatchColor,
                                  size: 32,
                                  semanticLabel: "Error",
                                ),
                                Spacer(),
                                Text(errorText, style: TextStyle(color: Colors.white60, fontSize: 18),), 
                                Spacer(flex: 2),
                              ],
                            ),

                            onPressed: () 
                            {
                              print(errorPopupVisible);
                            },
                          ),
                      ),
                        ),
                    ),
                    Spacer(flex: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

    String _errorMessage;
    bool _isLoading;

    void SubmitCreds() async {
    String userId = "";
    try {
      if (!signingUp) {
        userId = await widget.auth.signIn(email.trim(), password);
        print('Signed in: $userId');
      } else {
        userId = await widget.auth.signUp(email.trim(), password);

        print('Signed up user: $userId');

        // Map<String, dynamic> userInfo = Map<String, dynamic>();
        Firestore.instance.collection('userinfo').document(userId)
            .setData({"Username": username, "Email": email});

        userId = await widget.auth.signIn(email.trim(), password);

        errorText = "You account has been created!";
        setState(() {
          errorPopupVisible = true;
          
          _passConfKey.currentState.reset();
          _userKey.currentState.reset();
          buttonPad = 60;
          userButtonHeight = 0;
          creatingAccount = false;
        });
        startPopupTimer();
      }
      setState(() {
        _isLoading = false;
        creatingAccount = creatingAccount;
      });

      if (userId.length > 0 && userId != null && !signingUp) {
        widget.loginCallback();
      }
    } catch (e) {
      print('Error: $e');
      if(e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        errorText = "Your email address is already registered!";
        setState(() {
          errorPopupVisible = true;
        });
        startPopupTimer();
      /// `foo@bar.com` has alread been registered.
      }
      else if (e.code == "ERROR_USER_NOT_FOUND")
      {
        errorText = "You do not have an account! Please create one.";
        setState(() {
          errorPopupVisible = true;
        });
        startPopupTimer();
      }
      else if (e.code == "ERROR_WEAK_PASSWORD")
      {
        errorText = "Weak password! Must be at least 6 characters.";
        setState(() {
          errorPopupVisible = true;
        });
        startPopupTimer();
      }
      else if (e.code == "ERROR_WRONG_PASSWORD")
      {
        errorText = "Invalid password!";
        setState(() {
          errorPopupVisible = true;
        });
        startPopupTimer();
      }
      else if (e.code != null)
      {
        errorText = "Unknown login error!";
        setState(() {
          errorPopupVisible = true;
        });
        startPopupTimer();
      }

      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
        _passConfKey.currentState.reset();
        _userKey.currentState.reset();
        
        // _emailKey.currentState.reset();
        // _passKey.currentState.reset();
        buttonPad = 60;
        userButtonHeight = 0;
        creatingAccount = false;
      });
    }
  }
}
