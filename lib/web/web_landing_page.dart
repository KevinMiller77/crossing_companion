import 'dart:html';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

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
  MaterialColor swatch = KevColor.getMatColor(0xFFD7AA73);
  bool emailLinkColor = false;

  @override
  void initState() {
    super.initState();

  }
  

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double headerSize = 75;
    // double bannerSize = screenHeight / 8 >= headerTextSize ? screenHeight / 8 : headerTextSize;

    double footerSize = 75;
    double bodySize = screenHeight - headerSize - footerSize;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: headerSize,
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                    image: AssetImage("assets/images/WebBackdrop.jfif"),
                    color: Colors.black38,
                    fit:BoxFit.fitWidth,
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                  //Contains top row
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.black26]
                    )
                  ),
                  height: headerSize,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: <Widget>[
                          Spacer(),
                          Container(height: 75, child: Image(image: AssetImage("assets/images/CCLogo.png"),fit: BoxFit.fitHeight)),
                          Spacer(),
                          Text("Welcome to the Crossing Companion app info page!", textAlign: TextAlign.center, style: TextStyle(color: swatch, fontFamily: "FinkHeavy",fontSize: 42)),
                          Spacer(flex: 3),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                      color: Colors.black38,
                      fit:BoxFit.fill,
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),
                  Container(
                    color: Colors.black45,
                    height: bodySize,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(top: 30)),
                              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                  Text("The app is still currently in development!\nHopefully we'll be launching within a few weeks though!", textAlign: TextAlign.center, style: TextStyle(fontFamily: "Calibri", fontSize: 28)), ],),
                              Container(
                                width: screenWidth,
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(padding: EdgeInsets.only(top: 50),),
                                        Row(children: <Widget>[
                                            Text("Below is a list of the current intended features.\nIf you have any suggestions, please feel free to send a suggestion!",textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontFamily: "Calibri", fontSize: 22)), ],),
                                        Padding(padding: EdgeInsets.all(16.0),),
                                        Container(
                                          child: Row(children: <Widget>[
                                            SingleChildScrollView(
                                              
                                              child: Container(
                                                width: screenWidth / 2,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: <Widget>[
                                                        Container(width: screenWidth / 2, height: 2000, child: FutureFeaturesListView()),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 300,
                                      child: Column(
                                        children: [
                                          Container(
                                          width: screenWidth / 2,
                                          child: Padding(
                                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                                              child: TextFormField(
                                                // key: _emailKey,
                                                // focusNode: emailFocus,
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
                                                    borderSide: BorderSide(color: swatch),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(45.0),
                                                    borderSide: BorderSide(color: swatch),
                                                  ),
                                                ),
                                                textInputAction: TextInputAction.next,
                                                onFieldSubmitted: (String fieldData) {
                                                },
                                                validator: (val)
                                                {
                                                },
                                                keyboardType: TextInputType.emailAddress,
                                                style: TextStyle(
                                                  color: swatch,
                                                  fontSize: 32,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: screenWidth / 2,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                                              child: TextFormField(
                                                // key: _passKey,
                                                // focusNode: passwordFocus,
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
                                                    borderSide: BorderSide(color: swatch),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(45.0),
                                                    borderSide: BorderSide(color: swatch),
                                                  ),
                                                  
                                                  ),
                                                textInputAction: TextInputAction.next,
                                                onFieldSubmitted: (String fieldData) {
                                                },
                                                validator: (val)
                                                {
                                                },
                                                obscureText: true,
                                                keyboardType: TextInputType.text,
                                                style: TextStyle(
                                                  color: swatch,
                                                  fontSize: 32,
                                                ),
                                                
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Footer
            Container(
              color: Colors.black87,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: footerSize,
                    width: MediaQuery.of(context).size.width,
                    child: Image(
                      image: AssetImage("assets/images/WebBackdrop.jfif"),
                      color: Colors.black38,
                      fit:BoxFit.fitWidth,
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),
                    //Contains top row
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                        colors: [Colors.black54, Colors.black26]
                      )
                    ),
                    height: footerSize,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                            
                                Text("Feel free to email me any questions!", style: TextStyle(fontSize: 32, color: swatch)),
                                InkWell(
                                  child: Text("kevinamiller77@gmail.com", style: TextStyle(fontSize: 32, color: Colors.deepPurple),),
                                  onTap: () => { launch("mailto:kevinamiller77@gmail.com?subject=Crossing%20Companion%20Inquiry")},
                                ),
                              ],
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
    );
  }

}

class FutureFeaturesListView extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection('PlannedFeatures').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
      {
        if (!snapshot.hasData) return new Text("Waiting...");
        return new ListView(
          children: snapshot.data.documents.map((document) 
          {
            print(document["Name"]);
            return ListTile(
              title: Text(document["Name"], textAlign: TextAlign.center, style: TextStyle(fontSize: 22),),
              subtitle: Text(document["Description"], textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
            );
          }).toList(),
        );
      });
  }
  
}