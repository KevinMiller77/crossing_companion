// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:platform_detect/platform_detect.dart';

import 'package:crossing_companion/utils/kev_utils.dart';

class WebLandingPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return WebLandingPageState();
  }
 
}

class WebLandingPageState extends State<WebLandingPage>
{
  @override
  Widget build(BuildContext context) {
   return Container(
     child: Column(children: <Widget>[
      PageHeader(),
     ],)
   );
  }
  
}

class PageHeader extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return PageHeaderState();
      }
    
}
class PageHeaderState extends State<PageHeader>
{
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return ViewingOnWebBody();
  }

}

class FutureFeaturesListView extends StatelessWidget
{

  FutureFeaturesListView({this.height});

  double height;
  double featureMaxHeight = 132;
  double paddingAllSides = 16;
  int numTiles = 0;
  int maxNumTiles = 0;


  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection('PlannedFeatures').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
      {
        numTiles = 0;
        if (!snapshot.hasData) {
          return new Text("Waiting...", textAlign: TextAlign.center, style: TextStyle(fontSize: 22),);
        }
        return new ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: snapshot.data.documents.map((document) 
          {
            numTiles++;
            if (numTiles > maxNumTiles) 
            {
              maxNumTiles = numTiles;
              height += featureMaxHeight + 2 * paddingAllSides;
              print(height);
            }
            return Container(
              height: featureMaxHeight,
              child: ListTile(
                title: Text("* " + document["Name"], maxLines: 3, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 22, color: Colors.white60),),
                subtitle: Text(document["Description"], maxLines: 3, textAlign: TextAlign.center, style: TextStyle(color: Colors.white60,fontSize: 20)),
                contentPadding: EdgeInsets.only(bottom: 60),
              ),
            );
          }).toList(),
        );
      });
  }
  
  double getViewHeight()
  {
    print("Returning ");
    print(height);
    return height;
  }

}

class ViewingOnWebBody extends StatelessWidget
{
  String email = "";
  String box = "";

  FocusNode emailFocus = FocusNode();
  FocusNode boxFocus = FocusNode();

  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _boxKey = GlobalKey<FormFieldState>();

  MaterialColor swatch = KevColor.getMatColor(0xFFD7AA73);
  MaterialColor swatch87 = KevColor.getMatColor(0xAAD7AA73);

  bool emailLinkColor = false;

  static var globalKey = RectGetter.createGlobalKey();
  var rectGetter = RectGetter(key: globalKey, child: null);
  
  void dispose()
  {
    emailFocus.dispose();
    boxFocus.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double headerSize = 75;

    double leftHeaderPadding = screenWidth / 20;

    // double bannerSize = screenHeight / 8 >= headerTextSize ? screenHeight / 8 : headerTextSize;

    double footerSize = 40;
    double bodySize = screenHeight - footerSize;

    double featuresHeight = 0;
    FutureFeaturesListView features = FutureFeaturesListView(height: featuresHeight);

    Color black68 = Colors.black54;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: screenWidth,
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    //Body
                    Container(
                      child: Stack(
                        children: <Widget>[
                          //Describes Page
                          Container(
                            height: bodySize,
                            width: MediaQuery.of(context).size.width,
                            child: Image(
                              image: AssetImage("assets/images/BodyBackdrop.jpg"),
                              fit:BoxFit.fill,
                              colorBlendMode: BlendMode.darken,
                            ),
                          ),
                          Container(
                            color: black68,
                            height: bodySize,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        Stack(
                                        children: <Widget>[
                                          Container(
                                            height: headerSize,
                                            width: screenWidth,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                AnimatedDefaultTextStyle(
                                                                  child: Text("Crossing Companion", textAlign: TextAlign.center), 
                                                                  style: TextStyle(color: swatch, fontWeight: FontWeight.bold, fontFamily: "Fink",fontSize: screenWidth > 410 ? (screenWidth > 600 ? (screenWidth > 1400 ? 42 : 34) : 22) : 12), 
                                                                  duration: Duration(milliseconds: 150)
                                                                ),
                                              ],
                                            ),
                                          ),
                                            //Contains top row
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [Colors.transparent, black68]
                                              )
                                            ),
                                            height: 75,
                                            width: MediaQuery.of(context).size.width,
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center, 
                                                  children: <Widget>[
                                                    Padding(padding: EdgeInsets.only(right: leftHeaderPadding,)),
                                                    Container(height: 75, width: 75, child: Image(image: AssetImage("assets/images/CCLogo.png"),fit: BoxFit.fitHeight)),
                                                    
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(padding: EdgeInsets.only(top: 50)),
                                        AnimatedDefaultTextStyle(
                                                      child: Text("App info page!", style: TextStyle( decoration: TextDecoration.underline), textAlign: TextAlign.center), 
                                                                  style: TextStyle(color: swatch, fontWeight: FontWeight.bold, fontFamily: "Fink",fontSize: screenWidth > 410 ? (screenWidth > 600 ? (screenWidth > 1400 ? 42 : 34) : 22) : 16), 
                                                                  duration: Duration(milliseconds: 150)
                                                    ),
                                        Padding(padding: EdgeInsets.only(top: 75)),
                                        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                            AnimatedDefaultTextStyle(
                                              child: Text("The app is still currently in development!\nHopefully we'll be launching within the next few weeks!", textAlign: TextAlign.center), 
                                              style: TextStyle(color: swatch, fontFamily: "Calibri", fontSize: screenWidth > 410 ? (screenWidth > 600 ? (screenWidth > 1400 ? 36 : 26) : 18) : 14), 
                                              duration: Duration(milliseconds: 150)
                                            ),],
                                        ),
                                        Container(
                                          width: screenWidth,
                                          child: Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(padding: EdgeInsets.only(top: 25),),
                                                  // Padding(padding: EdgeInsets.all(16.0),),
                                                  ConstrainedBox(
                                                    constraints: BoxConstraints(maxWidth: screenWidth, maxHeight: 1650),
                                                    child: Column(
                                                      children: <Widget>[
                                                          Container(
                                                            width: screenWidth,
                                                            child: MeasureSize( 
                                                              onChange: (size) {
                                                                print(size);
                                                              },
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(16.0),
                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                                                      AnimatedDefaultTextStyle(
                                                                        child: Text("Below is a list of the current intended features.\nIf you have any suggestions, please feel free to send it over below!", textAlign: TextAlign.center), 
                                                                        style: TextStyle(color: Colors.white60, fontFamily: "Calibri", fontSize: screenWidth > 410 ? (screenWidth > 600 ? (screenWidth > 1400 ? 28 : 20) : 14) : 12), 
                                                                        duration: Duration(milliseconds: 150)
                                                                      ),
                                                                    ]),
                                                                  ),
                                                                  // features,                                                         //TODO: TAKE OUT MINUS 236
                                                                  AnimatedContainer(duration: Duration(milliseconds: 150), child: ConstrainedBox(constraints: BoxConstraints(maxWidth: screenWidth > 600 ? (screenWidth > 1400 ? screenWidth / 2 : screenWidth / 2) : screenWidth/2, maxHeight: 1500), child: features)),
                                                                  AnimatedContainer(
                                                                    duration: Duration(milliseconds: 150),
                                                                    height: screenWidth > 410 ? (screenWidth > 600 ? (screenWidth > 1400 ? 650 : 600) : 550) : 500,
                                                                    width: screenWidth > 410 ? (screenWidth > 600 ? (screenWidth > 1400 ? 700 : 600) : 400) : 350,
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Spacer(),
                                                                        Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: TextFormField(
                                                                          key: _emailKey,
                                                                          focusNode: emailFocus,
                                                                          decoration: InputDecoration(
                                                                            labelText: "  Email (optional)",
                                                                            labelStyle: TextStyle(
                                                                              color: Colors.black87,
                                                                              fontFamily: "Calibri"
                                                                            ),
                                                                            fillColor: swatch87,
                                                                            filled: true,
                                                                            border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(45.0),
                                                                              borderSide: BorderSide(),
                                                                            ),
                                                                            enabledBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(45.0),
                                                                              borderSide: BorderSide(color: swatch),
                                                                            ),
                                                                            focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(45.0),
                                                                              borderSide: BorderSide(color: swatch),
                                                                            ),
                                                                          ),
                                                                          textInputAction: TextInputAction.next,
                                                                          onFieldSubmitted: (String fieldData) {
                                                                            _fieldFocusChange(context, emailFocus, boxFocus);
                                                                          },
                                                                          keyboardType: TextInputType.emailAddress,
                                                                          style: TextStyle(
                                                                            color: Colors.black87,
                                                                            fontSize: 32,
                                                                          ),
                                                                          ),
                                                                        ),
                                                                        Spacer(),
                                                                        Container(
                                                                          height: screenWidth > 410 ? (screenWidth > 600 ? (screenWidth > 1400 ? 350 : 300) : 250) : 200,
                                                                          child: TextFormField(
                                                                            maxLines: 20,
                                                                            key: _boxKey,
                                                                            focusNode: boxFocus,
                                                                            decoration: InputDecoration(
                                                                              labelText: "  Suggestion / Concern",
                                                                              labelStyle: TextStyle(
                                                                                color: Colors.black87,
                                                                                fontFamily: "Calibri",
                                                                                fontSize: 32,
                                                                              ),
                                                                              fillColor: swatch87,
                                                                              filled: true,
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(45.0),
                                                                                borderSide: BorderSide(),
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(45.0),
                                                                                borderSide: BorderSide(color: swatch),
                                                                              ),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(45.0),
                                                                                borderSide: BorderSide(color: swatch),
                                                                              ),
                                                                            ),
                                                                            onFieldSubmitted: (String fieldData) {
                                                                              _fieldFocusChange(context, boxFocus, null);
                                                                            },
                                                                            validator: (val)
                                                                            {
                                                                              if (val.length == 0)
                                                                              {
                                                                                return "Please enter a suggestion!";
                                                                              }
                                                                              if (val.length > 200)
                                                                              {
                                                                                return "Suggestion too long! Please keep suggestion under 200 characters.";
                                                                              }
                                                                              box = val;
                                                                              return null;
                                                                            },
                                                                            style: TextStyle(
                                                                              color: Colors.black87,
                                                                              fontSize: 26,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Spacer(),
                                                                        Row(
                                                                          children: <Widget>[
                                                                            Spacer(),
                                                                            RaisedButton(
                                                                              textTheme: ButtonTextTheme.normal,
                                                                              color: swatch,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(45.0),
                                                                                side: BorderSide(color: swatch),
                                                                              ), 
                                                                              child: Text("Submit feedback", style: TextStyle(color: Colors.black87, fontSize: 18),), 
                                                                              onPressed: () 
                                                                              {
                                                                                _submitFeedback();
                                                                              },
                                                                            ),
                                                                            Spacer(),
                                      
                                                                          ],
                                                                        ),
                                                                        // Spacer(flex: 5),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                                             
                                                        Container(
                                                          padding: EdgeInsets.only(top: 50),
                                                          width: screenWidth,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: <Widget>[
                                                                  
                                                                      Text("Feel free to email me any questions!", style: TextStyle(fontSize: 18, color: swatch)),
                                                                      InkWell(
                                                                        child: Text("kevinamiller77@gmail.com", style: TextStyle(fontSize: 16, color: Colors.blue, fontStyle: FontStyle.italic),),
                                                                        onTap: () => { launch("mailto:kevinamiller77@gmail.com?subject=Crossing%20Companion%20Inquiry")},
                                                                      ),
                                                                    ],
                                                                  ),
                                                            ],
                                                          ),
                                                        ),
                                                        
                                                        Spacer(), 
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Footer
                    AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      child: Container(
                        height: footerSize,
                        child: Stack(
                          children: <Widget>[
                            //Contains top row
                            Container(
                              color: Colors.grey,
                              height: footerSize,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: footerSize,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Spacer(flex: 3),
                                            InkWell(
                                              child: Text("Cookie Policy(link)", style: TextStyle(fontSize: 12, color: Colors.white, fontStyle: FontStyle.italic),),
                                              onTap: () => { launch("https://app.termly.io/document/cookie-policy/be3fb851-7620-4c9d-9c60-4752281ea432")},
                                            ),
                                            Spacer(),
                                            InkWell(
                                              child: Text("Privacy Policy (link)", style: TextStyle(fontSize: 12, color: Colors.white, fontStyle: FontStyle.italic),),
                                              onTap: () => { launch("https://app.termly.io/document/privacy-policy/f0044ebc-16b2-42ae-a7af-cdc7eb3cb24e")},
                                            ),
                                            Spacer(),
                                            InkWell(
                                              child: Text("Terms & Conditions (link)", style: TextStyle(fontSize: 12, color: Colors.white, fontStyle: FontStyle.italic),),
                                              onTap: () => { launch("https://app.termly.io/document/terms-of-use-for-website/61eaa3cd-ce2d-41f5-8ff3-900e97ada432")},
                                            ),
                                            Spacer(flex: 3),
                                          ],
                                          ),
                                      ),
                                    ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _submitFeedback()
  {
    if (_boxKey.currentState.validate())
    {
      Firestore.instance.collection('Suggestions').document()
          .setData({"Email": email.length > 0 ? "N/A" : email, "Feedback": box});

      _emailKey.currentState.reset();
      _boxKey.currentState.reset();
    }
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);  
  }
}