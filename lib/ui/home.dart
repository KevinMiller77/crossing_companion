import "package:flutter/material.dart";
import 'package:crossing_companion/ui/root.dart';
import 'package:crossing_companion/utils/kev_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum CurrentPage {
  Turnip,
  Events,
  Exchange,
  Tracker,
  Planner
}


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
  MaterialColor kevWhiteTextCol = KevColor.getMatColor(0xFFAAAAAA);
  MaterialColor kevGrey = KevColor.getMatColor(0xFF444444);
  MaterialColor kevPurple = KevColor.getMatColor(0xFF4C30A2);

  String yourName = "";
  String username = "";
  CurrentPage currentPage = CurrentPage.Exchange;

  bool profileMenuActive = false;
  bool sideBarActive = false;
  bool tweakingProfSettings = false;


  @override
  Widget build(BuildContext context) {
    getUserName();
    // Firestore.instance.collection("userinfo").document(widget.userID).snapshots().first.then((value) {username = value.data["Username"]; });

    double notchSize = MediaQuery.of(context).padding.top;
    double sHeight = MediaQuery.of(context).size.height - notchSize;
    double sWidth = MediaQuery.of(context).size.width;



    return Scaffold(
        drawer: sideBarMenu(),
        body: Column(children: [
          SizedBox(
            height: notchSize,
            width: sWidth,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: kevGrey,
              ),
            ),
          ),
          homeTopBar(sHeight, sWidth),
          homeBody(sHeight, sWidth),
          homeNavBar(sHeight, sWidth),
        ],  
      ),
    );
  }

  Widget homeTopBar(double sHeight, double sWidth)
  {
    MaterialColor textCol = KevColor.getMatColor(0xFFFFDC00);
    MaterialColor textStrokeCol = KevColor.getMatColor(0xFFC88D32);

    double sidePadding = sWidth / 25;

    String topBarText = "";
    switch(currentPage)
    {
      case(CurrentPage.Events):   topBarText = "Coming Events";   break;
      case(CurrentPage.Exchange): topBarText = "Item Exchange";   break;
      case(CurrentPage.Planner):  topBarText = "Island Planner";  break;
      case(CurrentPage.Tracker):  topBarText = "Critter Tracker"; break;
      case(CurrentPage.Turnip):   topBarText = "Turnip Tracker";  break;
      default:  topBarText = "Unknown Page";  break;
    }

    return Container(
      height: sHeight / 16,
      width: sWidth, 
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          //Stack child 1
          Container(
            
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: kevPurple,
              ),
            ),
          ),
          //Stack child 2
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
              height: double.infinity,
              width: 60,
              child: FlatButton(
                onPressed: () {
                  if (profileMenuActive) profileMenuActive = false;
                  setState(() {sideBarActive = !sideBarActive;});
                },
                child: Icon(Icons.menu),
              ),
            ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: [
                  Text(
                    topBarText, 
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: "Fink",
                      letterSpacing: 3,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = textStrokeCol
                    ),
                  ),
                  Text(
                    topBarText,
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: "Fink",
                      color: textCol,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: double.infinity,
                width: 60,
                child: FlatButton(
                  onPressed: () {
                    if(sideBarActive) sideBarActive = false;
                    setState(() {profileMenuActive = !profileMenuActive;});
                  },
                  child: Icon(Icons.supervised_user_circle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget homeBody(double sHeight, double sWidth)
  {

    List<Widget> currentBody;
    switch(currentPage)
    {
      case(CurrentPage.Events):   currentBody = homeEventsView(); break;
      case(CurrentPage.Exchange): currentBody = homeExchangeView(); break;
      case(CurrentPage.Planner):  currentBody = homePlannerView(); break;
      case(CurrentPage.Tracker):  currentBody = homeTrackerView(); break;
      case(CurrentPage.Turnip):   currentBody = homeTurnipView(); break;
      default: currentBody = homeUnderConstruction();  break;
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: sWidth,
      height: sHeight - sHeight / 8, //Height minus top and bottom bars
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(image: AssetImage("assets/images/HomeBackdrop.jpg"), fit: BoxFit.fill,),
          SingleChildScrollView(
            child: Container(
              height: sHeight - sHeight / 8,
              child: ListView(
                children: currentBody,
              ),
            ),
          ),
          homeBodyOverlay(sHeight, sWidth),
        ],
      )
    );
  }

  Widget homeBodyOverlay(double sHeight, double sWidth)
  {
    bool active = profileMenuActive || sideBarActive || tweakingProfSettings;

    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      width: active ? sWidth : 0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: ((){ setState(() {profileMenuActive = false; sideBarActive = false; tweakingProfSettings = false;} ); }),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 250),
              opacity: active ? 0.8 : 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: KevColor.getMatColor(0xFF000000)
                )
              )
            ),
          ),
          Container(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 250),
              opacity: profileMenuActive ? 1 : 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    width: profileMenuActive ? sWidth / 2 : 0,
                    height: 150,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: kevGrey,
                      child: Column(
                        children: <Widget>[
                          getUserName(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: DecoratedBox(decoration: BoxDecoration(color: kevWhiteTextCol), child: Container(
                                height: 3,
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: (()
                            {
                              setState(() {
                                tweakingProfSettings = true;
                                profileMenuActive = false;
                              });
                            }), 
                            child: DecoratedBox(decoration: BoxDecoration(color: kevGrey), child: 
                                Text("Profile Settings", softWrap: false, textAlign: TextAlign.center, style: TextStyle(fontFamily: "Fink", fontSize: 20, color: kevWhiteTextCol),),
                            ),
                          ),
                          FlatButton(
                            onPressed: (()
                            {
                              if (profileMenuActive) widget.logoutCallback();
                            }), 
                            child: DecoratedBox(decoration: BoxDecoration(color: kevGrey), child: 
                                Text("Logout", softWrap: false, textAlign: TextAlign.center, style: TextStyle(fontFamily: "Fink", fontSize: 20, color: kevWhiteTextCol),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 250),
                width: sideBarActive ? sWidth / 2.5 : 0,
                height: (sHeight - sHeight / 8) / 2,
                
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: kevGrey,
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.symmetric(vertical: 8),),
                      
                    ],
                  ),
                ) 
              ),
            ],
          ),
          profileSettingsView(sWidth, sHeight)
        ],
      ),
    );
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
                        Text("Profile settings", style: TextStyle(fontSize: 40, color: kevWhiteTextCol, fontFamily: "Fink"), softWrap: false, textAlign: TextAlign.center,),
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
                  )
                ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

  Widget homeNavBar(double sHeight, double sWidth)
  {
    return Container(
      width: sWidth,
      height: sHeight / 16,
      child: Stack(
       fit: StackFit.expand,
       children: [
         DecoratedBox(
           decoration: BoxDecoration(
             color: kevGrey,
           ),
         ),
         Row(
           children: [
              Spacer(),
              FlatButton(
              child: Icon(Icons.graphic_eq, color: currentPage == CurrentPage.Turnip ? Colors.white : Colors.black,),
              onPressed: () {print("Change state"); setState(() {
                currentPage = CurrentPage.Turnip;
                });},
              ),
              Spacer(flex: 2),
              FlatButton(
              child: Icon(Icons.calendar_today, color: currentPage == CurrentPage.Events ? Colors.white : Colors.black,),
              onPressed: () {print("Change state"); setState(() {
                currentPage = CurrentPage.Events;
                });},
              ),
              Spacer(flex: 2),
              FlatButton(
              child: Icon(Icons.attach_money, color: currentPage == CurrentPage.Exchange ? Colors.white : Colors.black,),
              onPressed: () {print("Change state"); setState(() {
                currentPage = CurrentPage.Exchange;
                });},
              ),
              Spacer(flex: 2),
              FlatButton(
              child: Icon(Icons.bug_report, color: currentPage == CurrentPage.Tracker ? Colors.white : Colors.black,),
              onPressed: () {print("Change state"); setState(() {
                currentPage = CurrentPage.Tracker;
                });},
              ),
              Spacer(flex: 2),
              FlatButton(
              child: Icon(Icons.beach_access, color: currentPage == CurrentPage.Planner ? Colors.white : Colors.black,),
              onPressed: () {print("Change state"); setState(() {
                currentPage = CurrentPage.Planner;
                });},
              ),
              Spacer(),
           ],
         )
       ], 
      ),
    );
  }

  Widget getUserName()
  {
    return new StreamBuilder(
      stream: Firestore.instance.collection('userinfo').document(widget.userID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("");
        }
        return new Text(snapshot.data["Username"], style: TextStyle(color: kevWhiteTextCol, fontFamily: "Fink", fontSize: 30, fontWeight: FontWeight.bold), softWrap: false,);
      }
    );
  }

  List<Widget> homeEventsView()
  {
    return homeUnderConstruction();
  }

  List<Widget> homeExchangeView()
  {
    return homeUnderConstruction();
  }
  
  List<Widget> homePlannerView()
  {
    return homeUnderConstruction();
  }

  List<Widget> homeTrackerView()
  {
    return homeUnderConstruction();
  }

  List<Widget> homeTurnipView()
  {
    return [
      Text("This is the temp page for turnip tracker\n"),
      Text("There should be an icon over here"),
      Icon(Icons.airline_seat_flat)
    ];
  } 

  List<Widget> homeUnderConstruction()
  {
    return [
      Card(
        color: kevGrey,
        child: Text("Sorry, this page is still under\nconstruction. Be sure to check the\nstore and our website for more updates!", textAlign: TextAlign.center, style: TextStyle(fontFamily: "Fink", color: kevWhiteTextCol, fontSize: 24)),
      )
    ];
  }

  Widget sideBarMenu()
  {
    return Drawer(
      child: Row(
        children: [
          Text("This is a lot of text that would be hard to ignore!This is a lot of text that would be hard to ignore!This is a lot of text that would be hard to ignore!This is a lot of text that would be hard to ignore!This is a lot of text that would be hard to ignore!This is a lot of text that would be hard to ignore!This is a lot of text that would be hard to ignore!")
        ],
      ),
    );
  }

}