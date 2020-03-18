import 'dart:async';
import 'package:mfcc/mfcc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


List<List<double>> genMfcc(List<double> signal, int sampleRate) {
    print("Singal Length ${signal.length}");
    //var features = MFCC.mfccFeats(signal, 44100, 3, 3, 512, 32, 32, preEmphasis: 0.97);
    List<List<double>> features = MFCC.mfccFeats(signal, sampleRate, 512, 499, 512, 32, 32, preEmphasis: 0.97);
    for (var i = 0; i < features.length; i++) {
      for (var j = 0; j < features[0].length; j++) {
        features[i][j] = round(features[i][j], 4);
      }
    }
    return features;
  }

Future<int> detectSnoring(List<List<List<double>>> mfccList) async {
  var client = new http.Client();
  var data = json.encode({"mfcc": mfccList});
  data = data.replaceAll(' ', '');
  String url = "http://justindude521.pythonanywhere.com/";
    try {
      final response = await client.get('$url/api?mfcc=$data');
      var jsonData = json.decode(response.body);
      return jsonData['response'];
    }

    finally {
      client.close();
    }
}

double round(double val, int places){ 
   double mod = pow(10.0, places); 
   return ((val * mod).round().toDouble() / mod); 
}

void updateSnoringLength(int snoringLength) async {
  print ("Setting Home.");
  var firestore = Firestore.instance;
  var date = DateFormat('MM-dd-yyyy').format(DateTime.now());
  try {
    firestore.collection("Journey").document("${date}").updateData({
      'snoringLength' : snoringLength
    });
  }
  catch(e) {
    print(e);
  }
}