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
import 'location_access.dart' as location;

//import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:latlong/latlong.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'dart:convert';


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
    
    // Grab permissions
    if (!_permissionsGranted(requiredPermissions))
      _askPermissions();

    // Background Location Stream
    print("Testing");
    initBackgroundLocation();
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


// Location Services


int secSinceLastCheck = 895;
ReceivePort port = ReceivePort();
final Distance distance = new Distance();
LatLng _home;


void initBackgroundLocation() async {
  print('Init.');
  Timer.periodic(Duration(seconds:1), (timer) {
    secSinceLastCheck++;
  });

  location.getHome().then((home) {
    _home = home;
  });

  IsolateNameServer.registerPortWithName(port.sendPort, 'LocatorIsolate');
    port.listen((dynamic data) {
      LatLng current = new LatLng(data.latitude, data.longitude);


      var dist = distance.as(LengthUnit.Mile,
        new LatLng(current.latitude, current.longitude), new LatLng(_home.latitude, _home.longitude)); // Placeholder home

      if (dist > 5 && secSinceLastCheck > 900) { // API call if > 5 miles and 15 minutes have passed
        if (true) { // placeholder check if within an hour of sleep time
          recommendHome(current.latitude, current.longitude, _home.latitude, _home.longitude);
        }
        secSinceLastCheck = 0;
      }
    });

    initPlatformState();
    BackgroundLocator.registerLocationUpdate(callback,
              settings: LocationSettings(
                accuracy: LocationAccuracy.BALANCED,
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

void callback(LocationDto locationDto) async {
  print("Location in dart: ${locationDto.toString()}");
  final SendPort send = IsolateNameServer.lookupPortByName('LocatorIsolate');
  send?.send(locationDto);
}

void recommendHome(double currLat, double currLong, double homeLat, double homeLong) async {
  final travelTime = await getTravelTime(currLat, currLong, homeLat, homeLong);
  // TODO: Calculate time to leave by based off sleep time
  print(travelTime['text']);
  print(travelTime['value']);
}

Future<Map<String, dynamic>> getTravelTime(double currLat, double currLong, double homeLat, double homeLong) async {
  String apiKey = "AIzaSyAT8XbD5lDqqu81HYfhCqoOWIUtdS4P7jk&fbclid=IwAR19cGDGZCMmpQtOWffy6pg7c9wXvZmy6kLo5U9kxHSbAsIpnza1wxWNrvs";
  var client = new http.Client();
    try {
      final response = await client.get('https://maps.googleapis.com/maps/api/distancematrix/json?origins=$currLat,$currLong&destinations=$homeLat,$homeLong&key=$apiKey');
      var data = json.decode(response.body);
      print(data);
      return data['rows'][0]['elements'][0]['duration'];
    }
    finally {
      client.close();
    }
}

