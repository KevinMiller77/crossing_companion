import 'dart:async';
import 'dart:io';
// import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;  

import 'package:crossing_companion/utils/kev_utils.dart';
import 'root.dart';

class CCLoginPage extends StatefulWidget
{
  CCLoginPage({this.auth, this.loginCallback});

  final String title = "CC Login page";
  final Auth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() {
    return CCLoginState();
  }
}

class CCLoginState extends State<CCLoginPage> with TickerProviderStateMixin
{
  final databaseReference = Firestore.instance;
  bool tweakingProfSettings = false;

  String email = "";
  String password = "";
  String passVerf = "";
  String username = "";
  bool signingUp;

  MaterialColor kevWhiteTextCol = KevColor.getMatColor(0xFFAAAAAA);
  MaterialColor kevGrey = KevColor.getMatColor(0xFF444444);
  MaterialColor kevPurple = KevColor.getMatColor(0xFF4C30A2);

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode passVerfFocus = FocusNode();
  FocusNode usernameFocus = FocusNode();

  final GlobalKey<FormFieldState> _userKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passVerfKey = GlobalKey<FormFieldState>();

  bool keyboardVisable = false;
  bool creatingAccount = false;
  double userButtonHeight = 0;

  bool usingStockImage = true;
  String profPicURL = "";
  File userProfilePic;

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



  MaterialColor swatchColor = KevColor.getMatColor(0xFFD7AA73);

  @override void initState() {
    signingUp = false;
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
          keyboardVisable = visible;
          if (!keyboardVisable)
          {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
          else
          {
            
          }
      },
    );
    
    super.initState();
  }

  @override
  void dispose()
  {
    super.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    passVerfFocus.dispose();
    usernameFocus.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double sHeight = MediaQuery.of(context).size.height;
    double sWidth = MediaQuery.of(context).size.width;

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
                      padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
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
                    loginForm(),
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
                            _createAccount();
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
                            _login();
                          },
                        ),
                        Spacer(flex: 2),
                      ],
                    ),
                    Spacer(flex: 2),
                    Container(
                      width: 240,
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
                            widget.auth.googleSignIn().whenComplete(()
                              {
                                print("Signed in with google\n");
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
                              widget.auth.resetPassword(email);
                              alertMessage("You have been sent a password reset email\nif you have an account");
                              setState(() {
                                errorPopupVisible = true;
                              });
                              startPopupTimer();
                            }
                            else
                            {
                              if (creatingAccount)
                              {
                                errorText = "Please enter an email!";
                                setState(() {
                                  buttonPad = creatingAccount ? 60 : 0;
                                  userButtonHeight = 0;
                                  creatingAccount = false;
                                  errorPopupVisible = true;
                                });
                                startPopupTimer();
                                return;
                              }
                            }
                            
                          },
                        ),
                  ],
                ),
              ),
            profileSettingsView(sWidth, sHeight),
            alertSystem(),
            ],
          ),
        ),
      ),
    );
  }

  Widget alertSystem()
  {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,                  
          children: <Widget>[
            Spacer(flex: 2),
            Container(
              child: AnimatedContainer(

                duration: Duration(seconds: 1),
                height: errorPopupVisible ? 100 : 50,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 1000),
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
                      Spacer(),
                      Icon(
                        Icons.info,
                        color: swatchColor,
                        size: 32,
                        semanticLabel: "Error",
                      ),
                      Spacer(),
                      Text(errorText, style: TextStyle(color: Colors.white60, fontSize: 18), textAlign: TextAlign.center,), 
                      Spacer(flex: 2),
                    ],
                  ),

                  onPressed: () 
                  {
                  },
                ),
            ),
              ),
          ),
          Spacer(flex: 5),
        ],
      ),
    );
  }

  void _createAccount()
  {
    if (creatingAccount){
      if (_emailKey.currentState.validate() && _passKey.currentState.validate() && _passVerfKey.currentState.validate() && _userKey.currentState.validate())
      {
        signingUp = true;
        submitFirebaseCredentials();   
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
  }

  void _login()
  {
    if (creatingAccount)
    {
      setState(() {
        buttonPad = creatingAccount ? 60 : 0;
        userButtonHeight = 0;
        creatingAccount = false;
      });
      return;
    }
    if (_emailKey.currentState.validate() && _passKey.currentState.validate())
    {
        signingUp = false;
        submitFirebaseCredentials();
    }
  }


  void submitFirebaseCredentials() async {
  String userId = "";
  bool finishedSignUp = false;
  try {
    if (!signingUp) {

      userId = await widget.auth.signIn(email.trim(), password);
      Firestore.instance.collection("userinfo").document(userId).get().then((value){
          if (!value.data.isEmpty && value.data["AcctCreated"])
          {
            finishedSignUp = true;
          }
          else
          {
            alertMessage("Please finish making your account!");
            setState(() {
              tweakingProfSettings = true;
            });
          }
        }
      );
      
      print('Signed in: $userId');
    } else {
      userId = await widget.auth.signUp(email.trim(), password);

      print('Signed up user: $userId');

      // Map<String, dynamic> userInfo = Map<String, dynamic>();
      Firestore.instance.collection('userinfo').document(userId)
          .setData({"Username": username.trim(), "Email": email.trim(), "AcctCreated": false});

      userId = await widget.auth.signIn(email.trim(), password);

      alertMessage("You account has been created!");
      setState(() {
        errorPopupVisible = true;
        
        _passVerfKey.currentState.reset();
        _userKey.currentState.reset();
        buttonPad = 60;
        userButtonHeight = 0;
        creatingAccount = false;
        tweakingProfSettings = true;
      });
      startPopupTimer();
    }

    if (userId.length > 0 && userId != null && !signingUp && finishedSignUp) {
      widget.loginCallback();
    }
    } catch (e) {
      print('Error: $e');
      if(e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        alertMessage("Your email address is already registered!");
        creatingAccount = false;
      } else if (e.code == "ERROR_USER_NOT_FOUND")
      {
        alertMessage("You do not have an account! Please create one.");
        setState(() {
          creatingAccount = false;
          _createAccount();
        });
      } else if (e.code == "ERROR_WEAK_PASSWORD")
      {
        alertMessage("Weak password! Must be at least 6 characters.");        
      } else if (e.code == "ERROR_WRONG_PASSWORD")
      {
        alertMessage("Invalid password!");
      } else if (e.code == "ERROR_TOO_MANY_REQUESTS")
      {
        alertMessage("Too many requests!");
      } else if (e.code != null)
      {
        alertMessage("Unknown login error!");
      } else if (e.code == "ERROR_INVALID_EMAIL")
      {
        alertMessage("Email incorrectly formatted!");
      }

      setState(() {
        _passVerfKey.currentState.reset();
        _userKey.currentState.reset();
        
        // _emailKey.currentState.reset();
        // _passKey.currentState.reset();
        buttonPad = 60;
        userButtonHeight = 0;
        creatingAccount = false;
      });
    }
  }

  alertMessage(String message)
  {
    errorText = message;
    setState(() {
      errorPopupVisible = true;
    });
    startPopupTimer();
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);  
  }

  bool checkIfUserTaken(String attemptedName)
  {
    Firestore.instance.collection("userinfo").snapshots().listen((snapshot) {
      snapshot.documents.every((element) { 
        String currentElm = element.data["Username"];
        if (currentElm != null)
        {
          return !(currentElm.trim().toLowerCase() == attemptedName.trim().toLowerCase());
        }
        return true;
      });
    });
    return true;
  }

  Widget profileSettingsView(double sWidth, double sHeight)
  {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        width: tweakingProfSettings ? sWidth - sWidth / 10 : 0,
        height: tweakingProfSettings ? (sHeight - (sHeight / 8)) - (sHeight - (sHeight / 8)) / 10 : 0,
        child: Card (
          color: kevGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 0),),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("New Account", style: TextStyle(fontSize: 40, color: kevWhiteTextCol, fontFamily: "Fink"), softWrap: false, textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(icon: Icon(Icons.close), iconSize: sHeight / 20, onPressed: () {setState((){tweakingProfSettings = false;});}),
                    ],),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(sHeight / 10, 0, sHeight / 10, 16),
                child: DecoratedBox(decoration: BoxDecoration(color: kevWhiteTextCol), child: Container( height: 3,),),
              ),
              SingleChildScrollView(
                child: Column(children: [
                  Text("Profile Picture", style: TextStyle(fontSize: 32, color: kevWhiteTextCol, fontFamily: "Fink"), softWrap: false, textAlign: TextAlign.center,),
                  profilePictureSelector(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(sHeight / 10, 32, sHeight / 10, 0),
                    child: FlatButton(
                      color: Colors.black,
                      onPressed: () {
                        
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Change password", style: TextStyle(fontSize: 28, color: kevWhiteTextCol, fontFamily: "Fink"), softWrap: false, textAlign: TextAlign.center,),
                          Spacer(),
                          Icon(Icons.arrow_drop_down, color: kevWhiteTextCol,),
                        ],
                      ),
                    ),
                  ),


                ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
  
  Widget loginForm()
  {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      padding: EdgeInsets.only(top: buttonPad),
      child: Container(
        child: Column (crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          
          Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: TextFormField(
            key: _emailKey,
            focusNode: emailFocus,
            decoration: InputDecoration(
              labelText: " Email",
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
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (String fieldData) {
              print("Email: " + fieldData);
              _fieldFocusChange(context, usernameFocus, passwordFocus);
            },
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
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: TextFormField(
            key: _passKey,
            focusNode: passwordFocus,
            decoration: InputDecoration(
              labelText: " Password",
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
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (String fieldData) {
              if (creatingAccount)
              {
                _fieldFocusChange(context, passwordFocus, passVerfFocus);
              }
              else
              {
                _fieldFocusChange(context, passwordFocus, null);
                _login();
              }
            },
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
                focusNode: passVerfFocus,
                key: _passVerfKey,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Verify Password",
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
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (String fieldData) {
                  if (creatingAccount)
                  {
                    _fieldFocusChange(context, passVerfFocus, usernameFocus);
                  }
                },
                validator: (val)
                {
                  if (val.length == 0 && creatingAccount)
                  {
                    return "Please re-enter your password!";
                  } else 
                  {
                    _passKey.currentState.validate();
                    if (val != password) return "Passwords must match!";

                    passVerf = val;
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: swatchColor,
                  fontSize: 32,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 16,)),
                TextFormField(
                focusNode: usernameFocus,
                key: _userKey,
                decoration: InputDecoration(
                  labelText: " Username",
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
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (String fieldData) {
                  if (creatingAccount)
                  {
                    _createAccount();
                  }
                  _fieldFocusChange(context, usernameFocus, null);
                },
                validator: (val)
                {
                  if (val.length == 0 && creatingAccount)
                  {
                    return "Username cannot be empty";
                  } 
                  else if (!checkIfUserTaken(val))
                  {
                    alertMessage("Username already taken!");
                    return "Username already taken!";
                  }
                  else 
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
    );
  }

  Widget profilePictureSelector()
  {
    StorageReference storedpic = FirebaseStorage.instance.ref().child("StockProfileImage.jpg");
    getFirebaseStorageURL(storedpic).then((value) {
      setState(() {
        profPicURL = value;
      });
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Container(height: 200,),
          GestureDetector(
            onTap: () {
              setState(() {
                usingStockImage = false;
                chooseFile();
              });
            },
            child: Container(
              height: 200,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                child: usingStockImage ? profPicURL != "" ? Image.network(profPicURL) : Container() : Image.asset(userProfilePic.path == null ? "" : userProfilePic.path),
              ),
            ),
          ),
      ],
    );
  }

  Future chooseFile() async {    
   await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {    
     setState(() {    
       userProfilePic = image;    
       print("oops");
       print(image.path);
     });    
   });    
 } 

 Future<String> getFirebaseStorageURL(StorageReference ref) async
 {
   try
   {
     return await ref.getDownloadURL();
   }
   catch(e)
   {
    print("User does not yet have acces to firebase");
   }
   return "";
 }
}
