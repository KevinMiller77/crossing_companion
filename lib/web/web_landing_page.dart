import 'dart:html';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 

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
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double headerTextSize = 75;
    double bannerSize = screenHeight / 8 >= headerTextSize ? screenHeight / 8 : headerTextSize;

    double footerSize = 75;
    double bodySize = screenHeight - bannerSize - footerSize;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: bannerSize,
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
                  padding: EdgeInsets.only(top: bannerSize - headerTextSize),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.black26]
                    )
                  ),
                  height: bannerSize,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //Describes Page
                      Container(
                        height: bodySize,
                        width: MediaQuery.of(context).size.width,
                        color: swatch,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("The app is still currently in development"),
                              Image(image: AssetImage("assets/images"))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //Footer
            Spacer(),
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
                            Spacer(),
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
                            Spacer(),
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