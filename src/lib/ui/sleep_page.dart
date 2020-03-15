import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sensors/sensors.dart';

class SleepPage extends StatefulWidget {
  DateTime _sleepTime;
  DateTime _wakeTime;
  SleepPage(this._sleepTime, this._wakeTime);
  _SleepPageState createState() => _SleepPageState(this._sleepTime, this._wakeTime);
}

class _SleepPageState extends State<SleepPage> {
  DateTime _sleepTime;
  DateTime _wakeTime;
  _SleepPageState(this._sleepTime, this._wakeTime);

  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _streamSubscriptions
        .add(gyroscopeEvents.listen((GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
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
    final List<String> gyroscope =
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
                                  colors: [Color(0xff374ABE), Color(0xff64B6FF)]
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
                                RaisedButton(
                                    color: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    elevation: 0,
                                    onPressed: () {
                                      DatePicker.showTimePicker(
                                          context,
                                          theme: DatePickerTheme(),
                                          showTitleActions: true,
                                          onConfirm: (time) {
                                            final DateTime now = DateTime.now();
                                            if (time.hour < _sleepTime.hour)
                                              _wakeTime = DateTime(now.year, now.month, now.day + 1, time.hour, time.minute, time.second);
                                            else
                                              _wakeTime = DateTime(now.year, now.month, now.day, time.hour, time.minute, time.second);
                                            setState(() {});
                                          },
                                          currentTime: _wakeTime,
                                          locale: LocaleType.en
                                      );
                                    },
                                    child: Container(
                                        child: Text(
                                            'Change Time',
                                            style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Color.fromARGB(200, 255, 255, 255)
                                                )
                                            )
                                        )
                                    )
                                ),
                                Container(
                                  child: Text(
                                    'Gyroscope: $gyroscope',
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