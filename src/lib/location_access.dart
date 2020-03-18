import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'dart:convert';



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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

Future<Map<String, dynamic>> getTravelTime(double currLat, double currLong, double homeLat, double homeLong) async {
  String apiKey = "AIzaSyAT8XbD5lDqqu81HYfhCqoOWIUtdS4P7jk&fbclid=IwAR19cGDGZCMmpQtOWffy6pg7c9wXvZmy6kLo5U9kxHSbAsIpnza1wxWNrvs";
  var client = new http.Client();
    try {
      print("https://maps.googleapis.com/maps/api/distancematrix/json?origins=$currLat,$currLong&destinations=$homeLat,$homeLong&key=$apiKey");
      final response = await client.get('https://maps.googleapis.com/maps/api/distancematrix/json?origins=$currLat,$currLong&destinations=$homeLat,$homeLong&key=$apiKey');
      var data = json.decode(response.body);
      print(data);
      return data['rows'][0]['elements'][0]['duration'];
    }
    finally {
      client.close();
    }
}