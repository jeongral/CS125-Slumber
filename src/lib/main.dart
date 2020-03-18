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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'location_access.dart' as location;

//import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:latlong/latlong.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;


class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

int sleepTimeSeconds;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });


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
    sleepTimeSeconds = getSleepTimeSeconds();
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
    initBackgroundLocation();
    showNotification("test");
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
    print(secSinceLastCheck);
  });

  location.getHome().then((home) {
    _home = home;
  });

  IsolateNameServer.registerPortWithName(port.sendPort, 'LocatorIsolate');
    port.listen((dynamic data) {
      LatLng current = new LatLng(data.latitude, data.longitude);


      var dist = distance.as(LengthUnit.Mile,
        new LatLng(current.latitude, current.longitude), new LatLng(_home.latitude, _home.longitude)); // Placeholder home

      if (dist > 5 && secSinceLastCheck > 10) { // API call if > 5 miles and 15 minutes (900 seconds) have passed
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
  final SendPort send = IsolateNameServer.lookupPortByName('LocatorIsolate');
  send?.send(locationDto);
}


int getSleepTimeSeconds() {
  var firestore = Firestore.instance;
    try {
      var docRef = firestore.collection("UserSettings").document("SleepTime").get().then((doc) {
        print('test');
        if (doc.exists) {
          print(doc.data);
          var time = doc.data['Value'].split(':'); // time[0]: hour, time[1]: minute in str
          print(time);
          var seconds = int.parse(time[0]) * 3600 + int.parse(time[1] * 60);
          print("seconds $seconds");
          return seconds;
        }
      });
    }
    catch(e) {
      return 0;
    }
    finally {
      return 0;
    }
}

Future<void> showNotification(String message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Get home for bed!', message, platformChannelSpecifics,
        payload: 'item x');
  }

Future<void> recommendHome(double currLat, double currLong, double homeLat, double homeLong) async {
  print('Recommending to go home.');
  await location.getTravelTime(currLat, currLong, homeLat, homeLong).then((travelTime) {
    String timeToLeaveMsg = "It will take you ${travelTime['text']} to get home. Plan accordingly to sleep on time!";
    showNotification(timeToLeaveMsg);
  });
}