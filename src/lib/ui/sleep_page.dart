import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slumber/snoring_analysis.dart';
import 'alarm_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';



class SleepPage extends StatefulWidget {
  DateTime _sleepTime;
  DateTime _wakeTime;
  LatLng _home;
  SleepPage(this._sleepTime, this._wakeTime, this._home);
  _SleepPageState createState() => _SleepPageState(this._sleepTime, this._wakeTime, this._home);
}

class _SleepPageState extends State<SleepPage> {
  DateTime _sleepTime;
  DateTime _wakeTime;
  LatLng _home;
  Duration _difference;
  _SleepPageState(this._sleepTime, this._wakeTime, this._home);

  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  List<Map<DateTime, List<double>>> _gyroscope = [];

  @override
  void initState() {
    super.initState();

    // Add necessary permissions if not yet granted
    if (!_permissionsGranted([PermissionGroup.microphone, PermissionGroup.storage, PermissionGroup.sensors, PermissionGroup.locationAlways]))
        _askPermissions();
    // Set coords slept at as home
    Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((coords) {
        setHome(new LatLng(coords.latitude, coords.longitude));
        getHome().then((home) {
          _home = home;
        });
      });
      
    _difference = _wakeTime.difference(_sleepTime);
    Timer(Duration(seconds: _difference.inSeconds), () {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlarmPage())
      );
    });

    _streamSubscriptions
        .add(gyroscopeEvents.listen((GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
          _gyroscope.add({DateTime.now(): _gyroscopeValues});
    }));
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    List<String> gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    return Scaffold(
        body: Container(
            child: Stack(
                children: <Widget>[
                  PageView(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xff89216B), Color(0xffDA4453)]
                              )
                          ),
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    child: Text(
                                        'Alarm ' + _formatDateTime(_wakeTime),
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                fontSize: 36.0,
                                                color: Color.fromARGB(200, 255, 255, 255)
                                            )
                                        )
                                    )
                                ),
                                Container(
                                  child: Text(
                                    'Gyroscope: $gyroscope',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 18.0,
                                      color: Color.fromARGB(200, 255, 255, 255)
                                    )
                                  )
                                ),
                                Container(
                                  child: Text(
                                    'Home: ${_home}',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 16.0,
                                      color: Color.fromARGB(200, 255, 255, 255)
                                    )
                                  )
                                ),
                                RaisedButton(
                                    color: Color.fromARGB(50, 255, 255, 255),
                                    focusColor: Color.fromARGB(200, 255, 255, 255),
                                    hoverColor: Color.fromARGB(200, 255, 255, 255),
                                    highlightColor: Color.fromARGB(200, 255, 255, 255),
                                    splashColor: Color.fromARGB(200, 255, 255, 255),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0)
                                    ),
                                    elevation: 0,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        width: 200.0,
                                        height: 50.0,
                                        alignment: Alignment.center,
                                        child: Text(
                                            'STOP',
                                            style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                    fontSize: 36.0,
                                                    color: Color.fromARGB(200, 255, 255, 255)
                                                )
                                            )
                                        )
                                    )
                                )
                              ]
                          )
                      ),
                    ],
                  ),
                ]
            )
        )
    );
  }
}


void _askPermissions() {
  PermissionHandler().requestPermissions([PermissionGroup.locationAlways, PermissionGroup.sensors, PermissionGroup.microphone, PermissionGroup.storage]);
}

bool _permissionsGranted(List<PermissionGroup> permissions)
{
  for (var p in permissions) {
    if (PermissionHandler().checkPermissionStatus(p) != PermissionStatus.granted)
      return false;
  }
  return true;
}

Future<LatLng> getHome() async {
    print("Getting Home.");
    var firestore = Firestore.instance;
    try {
      var home = await firestore.collection("Location").document("Home").get();
      return new LatLng(home['latitude'], home['longitude']);
    }
    catch(e) {
      return null;
    }
  }

void setHome(LatLng home) async {
  print ("Setting Home.");
  var firestore = Firestore.instance;
  try {
    firestore.collection("Location").document("Home").updateData({
      'latitude' : home.latitude,
      'longitude' : home.longitude
    });
  }
  catch(e) {
    print(e);
  }
}