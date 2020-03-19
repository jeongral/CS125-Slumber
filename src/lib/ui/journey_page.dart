import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

//import 'package:carousel_slider/carousel_slider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'dart:io';
import 'dart:core';




class Journey extends StatefulWidget {
  @override
  _JourneyState createState() => _JourneyState();
}

class _JourneyState extends State<Journey> {
  List<int> _sleepDuration = [];
  List<SleepSeries> _sleepData = [];

//  ScrollController scrollController;
//
//  @override
//  void initState() {
//    super.initState();
//    scrollController = ScrollController();
//  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                                  colors: [Color(0xff374ABE), Color(0xff64B6FF)]
                              )
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 10.0, right: 260.0),
                                  child: Text(
                                      'Hours of Sleep',
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                              color: Color.fromARGB(200, 255, 255, 255)
                                          )
                                      )
                                  )
                              ),

                              Container( //GRAPH
                                  child: sleepGraph(context),
                              ),
                              Container(
//                                padding: EdgeInsets.symmetric(vertical: 40.0),
                                color: Colors.white, height: 0.5, width: 500,
                              ),
                              Container(
                                child: sleepScore(context),
                              ),
                              Container(
//                                padding: EdgeInsets.symmetric(vertical: 30.0),
                                color: Colors.white, height: 0.5, width: 500,
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 10.0, right: 260.0),
                                  child: Text(
                                      'Last Night:',
                                      style: GoogleFonts.oswald(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color: Color.fromARGB(200, 255, 255, 255)
                                          )
                                      )
                                  )
                              ),
                              Container(
                                child: previousNightSummary(context),
                              ),

                            ],
                          )
                      )
                    ],
                  )
                ]
            )
        )
    );
  }
  Future getSleepData() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("Journey").getDocuments();
    return qn.documents;
  }

  Widget sleepGraph(context){
    return new Container(
      child: FutureBuilder(
          future: getSleepData(),
          builder: (_,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: Text("Loading..."));
            }else{
                  for (int i=0; i < snapshot.data.length; i++) {
                    Map<String, dynamic> map = snapshot.data[i].data;
                    map["date"] = map["date"].substring(0,5) + '-' + map["date"].substring(8,10);

                    //change sleepLength to hours(int)
                    var time =  snapshot.data[i].data["sleepLength"].split(':');
                    double hours = double.parse(time[0]) + double.parse(time[1])/(60);
                    map["length"] = hours;

                    //get sleep hours for later use
                    _sleepDuration.add(hours.round());

                    SleepSeries sleepData = new SleepSeries.fromMap(map);
                    _sleepData.add(sleepData);

                }
              List<charts.Series<SleepSeries, String>> series
              = [
                charts.Series(
                    id: "hours",
                    data: _sleepData,
                    domainFn: (SleepSeries series, _) => series.date,
                    measureFn: (SleepSeries series, _) => series.hours
                ),
              ];


              return Container(
//                  height: 170.0,
                  height: MediaQuery.of(context).size.height*3.3/10,
                  child: Card(
                        child: charts.BarChart(
                            series,
                            animate: true,
                          behaviors: [
                            new charts.SlidingViewport(),
                            new charts.PanAndZoomBehavior(),

                          ],
                          // Set an initial viewport to demonstrate the sliding viewport behavior on
                          // initial chart load.
                          domainAxis: new charts.OrdinalAxisSpec(
                              viewport: new charts.OrdinalViewport(_sleepData[_sleepData.length-7].date, 7),
                              renderSpec: charts.SmallTickRendererSpec(
                              labelRotation: 5,
                            ),
                          )

                        ),
                      )
//                  )
              );
            }
          }
      ),
    );
  }

  Widget sleepScore(context){
    return new Container(
      child: FutureBuilder(
          future: getSleepData(),
          builder: (_,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: Text("Loading..."));
            }else{
              for (int i=0; i < snapshot.data.length; i++) {
                Map<String, dynamic> map = snapshot.data[i].data;
                var time =  snapshot.data[i].data["sleepLength"].split(':');
                double hours = double.parse(time[0]) + double.parse(time[1])/(60);
                map["length"] = hours;

                //get sleep hours for later use
                _sleepDuration.add(hours.round());

              }

              //calculate consistency
              int count = 1, tempCount;
              int popular = _sleepDuration[0];
              double score = 100;
              int temp = 0;
              for (int i = 0; i < (_sleepDuration.length-1 ); i++)
              {
                temp = _sleepDuration[i];
                tempCount = 0;
                for (int j = 1; j < _sleepDuration.length; j++)
                {
                  if (temp == _sleepDuration[j])
                    tempCount++;
                }
                if (tempCount > count)
                {
                  popular = temp;
                  count = tempCount;
                }
              }
              for (int i=0; i < _sleepDuration.length; i++)
              {
                if (_sleepDuration[i] != popular)
                {
                  score = score - ((popular - _sleepDuration[i]).abs()/10);
                }
              }
              int consistency = score.round();

              return Container(
                  height: MediaQuery.of(context).size.height/5,
                  child: CircularPercentIndicator(
                      radius: 85.0,
                      percent: consistency/100.round(),
                      lineWidth: 10.0,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.grey,
                      progressColor: Color(0xFF099FFF),
                      center: Text(
                        consistency.toString()+'%',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                        ),
                      ),
                      footer: Text(
                        "Sleep Consistency",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0
                        ),
                      )
                  )
              );
            }
          }
      ),
    );
  }

  Widget previousNightSummary(context){
    return new Container(

      child: FutureBuilder(
          future: getSleepData(),
          builder: (_,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: Text("Loading..."));
            }else{
              List<String> summary = [];

                int previousNight = snapshot.data.length-1;
                Map<String, dynamic> map = snapshot.data[previousNight].data;

              List<String> sleep = map["sleepTime"].split(' ')[1].split(':');
              List<String> wake = map["wakeTime"].split(' ')[1].split(':');
              List<String> duration = map["sleepLength"].split(':');
              String sleepTime;
              String wakeTime;
              String sleepLength;
              //sleep time
              if (int.parse(sleep[0]) > 12)
                {
                  sleepTime = (int.parse(sleep[0]) - 12).toString() + ':' + sleep[1] + ' PM';
                }
              else
                {
                    sleepTime = sleep[0] + ':' + sleep[1];
                    if (int.parse(sleep[0]) == 12)
                      sleepTime += ' PM';
                    else
                      sleepTime += ' AM';
                }
              //wake time
              if (int.parse(wake[0]) > 12)
              {
                wakeTime = (int.parse(wake[0]) - 12).toString() + ':' + wake[1] + ' PM';
              }
              else
              {
                wakeTime = wake[0] + ':' + wake[1];
                if (int.parse(wake[0]) == 12)
                  wakeTime += ' PM';
                else
                  wakeTime += ' AM';
              }
//              sleepLength = (int.parse(wake[0]) - int.parse(sleep[0])).toString()
//                            + '.'
//                            + ((int.parse(wake[1]) - int.parse(sleep[1]))/60).ceil().toString()
//                            + ' hours';
                sleepLength = (int.parse(wake[0]) - int.parse(sleep[0])).toString()
                              + ' hours '
                              + ((int.parse(wake[1]) - int.parse(sleep[1]))).toString()
                              + ' minutes';
              summary.add(map["date"]);
              summary.add(sleepTime);
              summary.add(wakeTime);
              summary.add(sleepLength);
              summary.add(map["snoringLength"].toString() + ' minutes');

              List<IconData> icon = [
                Icons.calendar_today,
                Icons.brightness_3,
                Icons.wb_sunny,
                Icons.av_timer,
                Icons.hearing
              ];

              List<String> subtitle = [
                'Date',
                'Sleep Time',
                'Wake Time',
                'Sleep Duration',
                'Snoring Length'
              ];

              return Container(
//                 height: 150.0,
                height: MediaQuery.of(context).size.height*2.5/10,
                child: ListView.builder(
                    itemCount: summary.length,
                    itemBuilder: (context, index){
                      return Container (
                        child: ListTile(
                          title: Text(summary[index]),
                          subtitle: Text(subtitle[index]),
                          leading: Icon(icon[index]),
                        ),
                      );
                    }
                ),
              );
            }
          }
      ),

    );
  }
}

class SleepSeries{
  String date;
  double hours;
  SleepSeries();
  SleepSeries.fromMap(Map<String, dynamic> map) {
    date = map["date"];
    hours = map["length"];
  }
}

//NOT USE
class GetJourneyFromDb {
  static Future<List> getItems( ) async {
    Completer<List> completer = new Completer<List>();
    FirebaseDatabase.instance
      .reference()
      .child("Journey")
      .once()
      .then( (DataSnapshot snapshot) {
//  print(snapshot.value);
  List map = snapshot.value;
  completer.complete(map);
  } );

    return completer.future;
  }
}



