import "package:flutter/material.dart";

class CCHomePage extends StatefulWidget {
  CCHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CCHomePageState createState() => _CCHomePageState();
}

class _CCHomePageState extends State<CCHomePage> {
  int _counter = 0;
  ScrollController _controller;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 80,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Main menu", textAlign: TextAlign.center),
            ),
          ),
        
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Color _col = Colors.blue;
                Widget _but = Container(width: 0, height: 0,);

                if (index < 5)
                {
                  _col = Colors.red;
                  _but = OutlineButton(
                    child: Text("Button"),
                    onPressed: () {
                      
                    },
                  );
                }

                return SizedBox (
                  // color: Colors.blue,
                  // margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  // alignment: Alignment.center,
                  child: Container (
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container (
                      child: _but
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
      
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _incrementCounter,              
              ),
            IconButton(
              onPressed: _incrementCounter,
              icon: Icon(Icons.lock),
            )
          ],
        ),
      ),
    );
  }
}