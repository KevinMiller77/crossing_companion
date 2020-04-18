import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;  
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_recaptcha_v2/flutter_recaptcha_v2.dart';

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
  RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();

  final databaseReference = Firestore.instance;
  bool tweakingProfSettings = false;

  String email = "";
  String password = "";
  String passVerf = "";
  String username = "";
  String userId = "";
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
  File userProfilePic = File("");

  
  bool termsAccepted = false;
  bool ageCorrect = false;
  bool northOrSouth = false;
  bool recaptchaGood = false;

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
    recaptchaV2Controller.show();
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
    double aspectRatio = sWidth / sHeight;

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
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(padding: EdgeInsets.only(top: statusBarHeight),),
                    bodyBannerBlock(sHeight / 5, sWidth / 2),
                    loginForm(sWidth, (4 * sHeight / 5) - statusBarHeight),

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

  
  Widget bodyBannerBlock(double sHeight, double sWidth)
  {
    //Part 1 of 2, vert -> hori split
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          child: Image(
            image: AssetImage("assets/images/LoginBanner.png"),
            fit: BoxFit.contain,
            height: sHeight,
          ),
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        ),
      ],
    );
  }

  Widget bodyInputButtons(double sHeight, double sWidth)
  {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: sWidth,
      height: sHeight,
      child: Column(
        children: [
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
                    Text("Log In with Google", style: TextStyle(color: Colors.white70, fontSize: 16)),
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
  bool finishedSignUp = false;
  try {
    if (!signingUp) {

      userId = await widget.auth.signIn(email.trim(), password);
      Firestore.instance.collection("userinfo").document(userId).get().then((value){
          if (value.data["AcctCreated"])
          {
            finishedSignUp = true;
            widget.loginCallback();
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

    print("Finished signup?: $finishedSignUp");

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
    double iWidth = sWidth - sWidth / 10;
    double iHeight = (sHeight - (sHeight / 8)) - (sHeight - (sHeight / 8)) / 10;
    double aspectRatio = iWidth / iHeight;

    return Container(
      child: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          width: tweakingProfSettings ? iWidth : 0,
          height: tweakingProfSettings ? iHeight : 0,
          child: Card (
            color: kevGrey,
            child: ListView(
              shrinkWrap: true,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("New Account", style: TextStyle(fontSize: 40, color: kevWhiteTextCol, fontFamily: "Fink"), softWrap: false, textAlign: TextAlign.center,),
                        ],
                      ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(sHeight / 10, 0, sHeight / 10, 16),
                  child: DecoratedBox(decoration: BoxDecoration(color: kevWhiteTextCol), child: Container( height: 3,),),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        aspectRatio < 1 ? Column (
                          children: [
                            profilePictureSelector(),
                            termAcceptButtons(sHeight, sWidth),
                            signUpLogin(),
                          ],
                        ) : Row(
                          children: [
                            Spacer(),
                            profilePictureSelector(),
                            Spacer(),
                            termAcceptButtons(sHeight, sWidth),
                            Spacer(),
                            signUpLogin(),
                            Spacer(),
                          ],
                        )
                      ],
                    ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
  
  Widget loginForm(double sWidth, double sHeight)
  {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          width: sWidth,
          height: sHeight,
          duration: Duration(milliseconds: 500),
          child: Container(
            child: Column (
              children: <Widget>[
              Spacer(),
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
            Spacer(),
            bodyInputButtons(creatingAccount ? 200 : 300, sWidth),
          ],
          ),
        ),
        ),
      ],
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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Column(
            children: [
              Text("Profile Picture", style: TextStyle(fontSize: 32, color: kevWhiteTextCol, fontFamily: "Fink"), softWrap: false, textAlign: TextAlign.center,),
              Padding(padding: EdgeInsets.symmetric(vertical: 8),),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Container(height: 200,),
                GestureDetector(
                  onTap: () {
                    chooseFile();
                  },
                  child: Container(
                    height: 200,
                    width: 200,
                    child: ClipRRect( 
                        child: usingStockImage ? (profPicURL != "" ? Image.network(profPicURL) : Container()) : Image.file(userProfilePic == null ? "" : userProfilePic),
                        borderRadius: BorderRadius.circular(180),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future chooseFile() async {    
    try{
      await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {    
        if (image == null) { return; }

        setState(() { 
          userProfilePic = image;
          usingStockImage = false;
        });    
      });    
    }
    catch(e)
    {
      print("EEEE");
      setState(() {
        usingStockImage = true;
        print("Prof pic URL: $profPicURL");
      });
    }
 } 

 Future<String> getFirebaseStorageURL(StorageReference ref) async
 {
   if (!tweakingProfSettings) return "";
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

 Widget termAcceptButtons(double sHeight, double sWidth)
 {
    double iWidth = sWidth - sWidth / 10;
    double iHeight = (sHeight - (sHeight / 8)) - (sHeight - (sHeight / 8)) / 10;
    double aspectRatio = iWidth / iHeight;

   return Container(
      constraints: BoxConstraints(maxHeight: aspectRatio < 1 ? iHeight / 2 : iHeight - iHeight / 10, maxWidth: double.maxFinite,),
      child: Column(
        children: <Widget>[
          Spacer(),
          Text("Fields marked with a * are required!", textAlign: TextAlign.center, style: TextStyle(color: kevWhiteTextCol, fontFamily: "Fink"),),
          Spacer(),
          Container(
            width: 300,
            height: 100,
            child: Stack(
              fit:StackFit.expand,
              children: [
                Container(
                  child: DecoratedBox(decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(45))),
                ),
                
                Row(
                  children: <Widget>[
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(),
                        Text("Do you agree to the", style: TextStyle(color: kevWhiteTextCol, fontFamily: "Fink", fontSize: 26), textAlign: TextAlign.left,),
                        InkWell(
                            child: Text("Terms and Conditions? *", style: TextStyle(color: Colors.blue, fontFamily: "Fink", fontSize: 24, fontStyle: FontStyle.italic), textAlign: TextAlign.left,),
                            onTap: () => launch('https://crossingcompanion.web.app/terms-of-use/index.html')
                        ),
                        Spacer(),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Spacer(),
                        Theme(
                          data: ThemeData(unselectedWidgetColor: kevWhiteTextCol),
                          child: Checkbox(
                            hoverColor: Colors.white,

                            activeColor: kevWhiteTextCol,
                            value: termsAccepted,
                            onChanged: (value) {
                              setState(() {
                                termsAccepted = !termsAccepted;
                              });
                            },
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            width: 300,
            height: 100,
            child: Stack(
              fit:StackFit.expand,
              children: [
                Container(
                  child: DecoratedBox(decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(45))),
                ),
                
                Row(
                  children: <Widget>[
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(),
                        Text("Are you 13 or older? *", style: TextStyle(color: kevWhiteTextCol, fontFamily: "Fink", fontSize: 26), textAlign: TextAlign.left,),
                        
                        Spacer(),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Spacer(),
                        Theme(
                          data: ThemeData(unselectedWidgetColor: kevWhiteTextCol),
                          child: Checkbox(
                            hoverColor: Colors.white,

                            activeColor: kevWhiteTextCol,
                            value: ageCorrect,
                            onChanged: (value) {
                              setState(() {
                                ageCorrect = !ageCorrect;
                              });
                            },
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      )
    );
  }

  Widget signUpLogin()
  {
    return Container(
      width: 300,
      height: 50,
      child: GestureDetector(
        onTap: () {
          if (ageCorrect && termsAccepted)
          {
            if (userProfilePic != null)
            {
              Firestore.instance.collection("userinfo").document(userId).setData({"AcctCreated": true}, merge: true);
              uploadFile("$userId/ProfilePic/", userProfilePic);
              
              submitFirebaseCredentials();
              widget.loginCallback();
            }
            else{
              Firestore.instance.collection("userinfo").document(userId).setData({"AcctCreated": true, "UsingStockPhoto": true}, merge: true);
              
              submitFirebaseCredentials();
              widget.loginCallback();
            }
          }
          else{
            alertMessage("Please accept the \nterms and verify age!");
          }
        },
        child: Stack(
          fit:StackFit.expand,
          children: [
            Container(
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(45))),
            ),
            
            Row(
              children: <Widget>[
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Text("Signup and Log in", style: TextStyle(color: Colors.blue, fontFamily: "Fink", fontSize: 26), textAlign: TextAlign.center,),
                    Spacer(),
                  ],
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future uploadFile(String path, File file) async {    
   StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('$path/${Path.basename(file.path)}');    
   StorageUploadTask uploadTask = storageReference.putFile(file);    
   await uploadTask.onComplete;    
   print('File Uploaded');
 }
}
