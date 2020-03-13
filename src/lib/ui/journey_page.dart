import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'sleep_page.dart';

//import 'package:carousel_slider/carousel_slider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
//import 'package:shared_preferences/shared_preferences.dart';


class Journey extends StatefulWidget {
  @override
  _JourneyState createState() => _JourneyState();
}

class _JourneyState extends State<Journey> {
  int _sleepConsistency = 80 ;
  List<String> _notes = [
    "Sleep early!",
    "Wake up early!",
    "Need more sleep!",
    "SLEEP!!!!"
  ];

  void callSetState() {
    setState((){}); // it can be called without parameters. It will redraw based on changes done in _SecondWidgetState
  }
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
                                  padding: EdgeInsets.only(left: 10.0, right: 300.0),
                                  child: Text(
                                      'Sleep History',
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                              color: Color.fromARGB(200, 255, 255, 255)
                                          )
                                      )
                                  )
                              ),
                              Container(
                                height: 200.0,
                                width: 600.0,
                                color: Colors.grey,
                                child: Text('place holder for graph'),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 30.0),
                                color: Colors.white, height: 1, width: 500,
                              ),
                              Container(
                                  child: CircularPercentIndicator(
                                      radius: 100.0,
                                      percent: _sleepConsistency/100,
                                      lineWidth: 10.0,
                                      circularStrokeCap: CircularStrokeCap.round,
                                      backgroundColor: Colors.grey,
                                      progressColor: Color(0xFF099FFF),
                                      center: Text(
                                        _sleepConsistency.toString()+'%',
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
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 30.0),
                                color: Colors.white, height: 1, width: 500,
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 10.0, right: 250.0, top: 5),
                                  child: Text(
                                      'Recomendations:',
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
                                height: 200.0,
                                child: ListView.builder(
                                    itemCount: _notes.length,
                                    itemBuilder: (context, index){
                                      return Card (
                                        child: ListTile(
                                          title: Text(_notes[index]),

                                        ),
                                      );
                                    }
                                ),
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
}



