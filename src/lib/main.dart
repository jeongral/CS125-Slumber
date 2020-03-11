import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './ui/home_page.dart';
import './ui/journey_page.dart';
import './ui/profile_page.dart';
//import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';


void main(){
  try {//perhaps surround this with a if(sdkVersion)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarIconBrightness: Brightness.light));// ,systemNavigationBarColor: Color(0xFF2E2E2E)));

    //compatability issues
    //FlutterStatusbarcolor.setStatusBarColor(Color(0xFF2E2E2E));
  } on PlatformException catch (e) {
    print(e);
  }

  runApp(new MaterialApp(
    home: new TabView(),
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xff64B6FF),
        accentColor: Color.fromARGB(200, 255, 255, 255),
        splashColor: Color(0xff64B6FF),
        cardColor: Color(0xff64B6FF),
        canvasColor: Color(0xff64B6FF)

    ),
  ));
}


class TabView extends StatefulWidget{

  static var browseWorkoutPage;
  @override
  State<StatefulWidget> createState() {

    return new TabState();
  }
}

GlobalKey myKey = new GlobalKey();

class TabState extends State<TabView> with SingleTickerProviderStateMixin{

  static const platform = const MethodChannel('workoutapp.flutter.io/notifications');
  static TabController _tabController;
  int currentTab = 0;
  HomePage one;
  Journey two;
  Profile three;
  List<Widget> pages;
  Widget currentPage;

  String javaSuccess = "Unknown";

//IGNORE
  // Future<Null> _createNotification() async{
  //   String _javaSuccess;
  //   try {
  //     final int result = await platform.invokeMethod('createNotification');
  //     _javaSuccess = 'Java returned $result % .';
  //   } on PlatformException catch (e) {
  //     _javaSuccess= "An error has occured";
  //   }

  //   setState(() {
  //     javaSuccess = _javaSuccess;
  //   });

  //   print(javaSuccess);
  // }

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
    one = HomePage();
    two = Journey(); // probably don't need any of these params
    three = Profile();
    //three.createState();
    //one.createState();
    pages = [one,two,three];
    currentPage = one;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: myKey,
        backgroundColor: Color(0xff64B6FF),//Color(0xFF222222),

        body: currentPage,
        bottomNavigationBar:new Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
                canvasColor: Color(0xff64B6FF),
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Color(0xff64B6FF),
                textTheme: Theme
                    .of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Color.fromARGB(150, 255, 255, 255)))),


            child: BottomNavigationBar(

                currentIndex: currentTab,
                onTap: (int index){
                  setState(() {
                    currentTab = index;
                    currentPage = pages[index];
                  });
                },
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text("Home"),
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.book),
                      title: Text("Journey")
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      title: Text("Profile")
                  ),

                ]
            )
        ));
  }

  void changeTab(int index){
    setState(() {
      currentTab = index;
      currentPage = pages[index];
    });
  }
//IGNORE
// Widget launchNotification(){
//   return new Center(
//     child: new IconButton(
//       icon: Icon(Icons.message),
//       onPressed: _createNotification,
//     )
//   );
// }
}
