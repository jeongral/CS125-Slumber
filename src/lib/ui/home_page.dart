import 'package:flutter/material.dart';


class  HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Color(0xFF1d1d1e),
      body: new Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(top:30),
                  height:75,
                  child:  new Image.asset("images/slumber.png"),
                )
              ],
              ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Sleep time Selector
                new Text('Sleep Time Selector')
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Wake time Selector
                new Text('Wake Time Selector')
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Graph
                new Text('Graph')
              ],
            )
          ],
        )
      ),
    );
  }
}
  
