
import 'package:crossing_companion/cc.dart';
import 'package:crossing_companion/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus
{
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN
}

class KevRootPage extends StatefulWidget
{
  KevRootPage({this.auth});

  final String title = "CC Root page";
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() {
    return KevRootState();
  }
}

class KevRootState extends State<KevRootPage>
{
  
  AuthStatus _authStatus = AuthStatus.NOT_LOGGED_IN;
  String _user;

  @override
  void initState()
  {
    super.initState();
    widget.auth.getCurrentUser().then( (user) {
      setState(() {
        if (user != null)
        {
          _user = user?.uid;
        }
        _authStatus = user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void LoginCallback()
  {
    widget.auth.getCurrentUser().then((user)
    {
      setState(() {
        _user = user.uid.toString();
      });
    });

    setState(() {
      _authStatus = AuthStatus.LOGGED_IN; 
    });
    print("User logged in");
  }

  void LogoutCallback()
  {
    setState(() {
      _authStatus = AuthStatus.NOT_LOGGED_IN;
      _user = "";
    });
    print("User logged out");
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Add a waiting page
    switch (_authStatus) {
      case AuthStatus.NOT_DETERMINED:
      case AuthStatus.NOT_LOGGED_IN:
      return KevLoginPage(auth: widget.auth, loginCallback: LoginCallback);
      break;

      case AuthStatus.LOGGED_IN:
      return CCHomePage(auth: widget.auth, userID: _user, logoutCallback: LogoutCallback);
      break;

      default:
      return KevLoginPage(auth: widget.auth, loginCallback: LoginCallback);
      break;
    }  
  }
  
}

abstract class BaseAuth {

  Future<String> signIn(String email, String password);
  Future<String> googleSignIn();

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> resetPassword();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignInFunc = GoogleSignIn();
  bool signedInWithGoogle = false;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return result.user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    if (signedInWithGoogle)
    {
      signedInWithGoogle = false;
      return await googleSignInFunc.signOut();
    }
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();    
    return user.isEmailVerified;
  }

  Future<void> resetPassword() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    //TODO: Add in the reset password jiggle
  }

  Future<String> googleSignIn() async {
    GoogleSignInAccount googleSignInAccount;
    try
    {
       googleSignInAccount = await googleSignInFunc.signIn();
    }
    catch(e)
    {
      if (e.code == "sign_in_failed" || e.code == "sign_in_canceled")
      {
        return "";
      }
    }
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    signedInWithGoogle = true;
    return user.uid;
  }

}