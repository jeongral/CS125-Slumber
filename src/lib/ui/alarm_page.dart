import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'home_page.dart';

class AlarmPage extends StatefulWidget {
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  String s;
  @override
  void initState() {
    super.initState();
    if (DateTime.now().hour < 11)
      s = 'Morning!';
    else if (DateTime.now().hour >= 11 && DateTime.now().hour < 17)
      s = 'Afternoon!';
    else if (DateTime.now().hour >= 17 && DateTime.now().hour < 20)
      s = 'Evening!';
    else
      s = 'Night!';
    FlutterRingtonePlayer.playAlarm(
      volume: 0.5,
      looping: true,
      asAlarm: true
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
                                  colors: [Color(0xffF39F86), Color(0xffF9D976)]
                              )
                          ),
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    child: Text(
                                        "Good",
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                fontSize: 60.0,
                                                color: Color.fromARGB(200, 255, 255, 255)
                                            )
                                        )
                                    )
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                        s,
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                fontSize: 60.0,
                                                color: Color.fromARGB(200, 255, 255, 255)
                                            )
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
                                      FlutterRingtonePlayer.stop();
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