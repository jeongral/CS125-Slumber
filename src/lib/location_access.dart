import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';

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