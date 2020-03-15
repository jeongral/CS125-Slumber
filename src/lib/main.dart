import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './ui/home_page.dart';
import './ui/journey_page.dart';
import './ui/profile_page.dart';
import 'dart:ui';
import 'dart:isolate';
import './ui/test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';

//import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';




void main() async {
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
  MenuDashboardPage three;
  List<Widget> pages;
  Widget currentPage;

  String javaSuccess = "Unknown";


  ReceivePort port = ReceivePort();
  dynamic currLocation;
  var requiredPermissions = [PermissionGroup.locationAlways, PermissionGroup.sensors, PermissionGroup.microphone, PermissionGroup.storage, PermissionGroup.notification];

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
    three = MenuDashboardPage();
    //three.createState();
    //one.createState();
    pages = [one,two,three];
    currentPage = one;
    if (!_permissionsGranted(requiredPermissions))
      _askPermissions();

    // Background Location Stream
    IsolateNameServer.registerPortWithName(port.sendPort, 'LocatorIsolate');
      port.listen((dynamic data) {
        setState(() {
          currLocation = data;
        });
        // TODO: Check if distance is greater than x from home then calc time
      });
      initPlatformState();
      BackgroundLocator.registerLocationUpdate(callback,
                settings: LocationSettings(
                    notificationTitle: "Keeping Track of Your Location",
                    notificationMsg: "Hey! :) We're tracking your location to help remind you to get home on time for a goodnight's sleep! You can edit this option in the settings.",
                    wakeLockTime: 20,
                    autoStop: false));
  }
  

  Future<void> initPlatformState() async {
    print("Initializing background location...");
    await BackgroundLocator.initialize();
    print("Done Initializing.");
  }

  static void callback(LocationDto locationDto) async {
    print("Location in dart: ${locationDto.toString()}");
    final SendPort send = IsolateNameServer.lookupPortByName('LocatorIsolate');
    send?.send(locationDto);
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


  void _askPermissions() {
    PermissionHandler().requestPermissions(requiredPermissions);
  }

  bool _permissionsGranted(List<PermissionGroup> permissions)
  {
    for (var p in permissions) {
      if (PermissionHandler().checkPermissionStatus(p) != PermissionStatus.granted)
        return false;
    }
    return true;
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



