import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:geolocator/geolocator.dart';
import 'sleep_page.dart';
import 'info_page.dart';


class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Duration _timerDuration = Duration(seconds: 1);
  bool _isStarted = false;
  bool _isVisible = false;

  Position _home;
  DateTime _sleepTime;
  DateTime _wakeTime;
  String _sSleepTime;
  String _sWakeTime;

  Map<String, String> _cycles = {'first': '', 'second': '', 'third': '', 'fourth': ''};
  String _scycles = '';

  PageController _controller;

  @override
  void initState() {
    super.initState();

    final DateTime now = DateTime.now();
    _sleepTime = now;
    _wakeTime = DateTime(now.year, now.month, now.day, now.hour + 8);
    _sSleepTime = _formatDateTime(_sleepTime);
    _sWakeTime = _formatDateTime(_wakeTime);

    _controller = PageController();
    Timer.periodic(_timerDuration, (Timer t) {
      if (_isStarted)
        t.cancel();
      else
        _getTime();
    });
  }

  @override
  void dispose() {
    _isStarted = true;
    super.dispose();
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    _sleepTime = now;
    if (_wakeTime.isBefore(_sleepTime))
      _wakeTime = DateTime(now.year, now.month, now.day + 1, _wakeTime.hour, _wakeTime.minute, _wakeTime.second);
    final String formattedSleepTime = _formatDateTime(now);
    setState(() {
      _sSleepTime = formattedSleepTime;
    });
  }

  @override
  Widget build(BuildContext) {
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
                                          'Sleep at',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontSize: 24.0,
                                                  color: Color.fromARGB(200, 255, 255, 255)
                                              )
                                          )
                                      )
                                  ),
                                  Container(
                                      child: Text(
                                          _sSleepTime,
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontSize: 60.0,
                                                  color: Color.fromARGB(200, 255, 255, 255)
                                              )
                                          )
                                      )
                                  ),
                                  Container(
                                      child: Text(
                                          'Wake up at',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontSize: 24.0,
                                                  color: Color.fromARGB(200, 255, 255, 255)
                                              )
                                          )
                                      )
                                  ),
                                  Container(
                                      child: Text(
                                          _sWakeTime,
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontSize: 60.0,
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
                                              _isVisible = false;
                                              final DateTime now = DateTime.now();
                                              if (_wakeTime.isBefore(_sleepTime))
                                                _wakeTime = DateTime(now.year, now.month, now.day + 1, time.hour, time.minute, time.second);
                                              else
                                                _wakeTime = DateTime(now.year, now.month, now.day, time.hour, time.minute, time.second);
                                              _sWakeTime = _formatDateTime(_wakeTime);
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
                                  RaisedButton(
                                      color: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      elevation: 0,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => InfoPage())
                                        );
                                      },
                                      child: Container(
                                          child: Text(
                                              'Proceed to info page',
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
                                      height: 10
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
                                        _isVisible = false;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SleepPage(_sleepTime, _wakeTime, _home))
                                        );
                                      },
                                      child: Container(
                                          width: 200.0,
                                          height: 50.0,
                                          alignment: Alignment.center,
                                          child: Text(
                                              'START',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontSize: 32.0,
                                                      color: Color.fromARGB(200, 255, 255, 255)
                                                  )
                                              )
                                          )
                                      )
                                  )
                                ]
                            )
                        ),
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
                                          'I have to wake up at...',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontSize: 24.0,
                                                  color: Color.fromARGB(200, 255, 255, 255)
                                              )
                                          )
                                      )
                                  ),
                                  Container(
                                      child: Text(
                                          _sWakeTime,
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontSize: 60.0,
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
                                              _isVisible = false;
                                              final DateTime now = DateTime.now();
                                              if (time.hour < _sleepTime.hour)
                                                _wakeTime = DateTime(now.year, now.month, now.day + 1, time.hour, time.minute, time.second);
                                              else
                                                _wakeTime = DateTime(now.year, now.month, now.day, time.hour, time.minute, time.second);
                                              _sWakeTime = _formatDateTime(_wakeTime);
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
                                      height: 10
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
                                        _cycles['first'] = _formatDateTime(_wakeTime.add(Duration(minutes: -540)));
                                        _cycles['second'] = _formatDateTime(_wakeTime.add(Duration(minutes: -450)));
                                        _cycles['third'] = _formatDateTime(_wakeTime.add(Duration(minutes: -360)));
                                        _cycles['fourth'] = _formatDateTime(_wakeTime.add(Duration(minutes: -270)));
                                        _scycles = _cycles['first'] + ' or ' + _cycles['second'] + ' or ' + _cycles['third'] + ' or ' + _cycles['fourth'];
                                        _isVisible = true;
                                      },
                                      child: Container(
                                          width: 200.0,
                                          height: 50.0,
                                          alignment: Alignment.center,
                                          child: Text(
                                              'CALCULATE',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontSize: 32.0,
                                                      color: Color.fromARGB(200, 255, 255, 255)
                                                  )
                                              )
                                          )
                                      )
                                  ),
                                  Container(
                                      height: 20
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Visibility(
                                      visible: _isVisible,
                                      child: Text(
                                        'You should try to fall asleep at',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          fontSize: 24.0,
                                          color: Color.fromARGB(200, 255, 255, 255)
                                        )
                                      )
                                    )
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 400,
                                    child: Visibility(
                                      visible: _isVisible,
                                      child: Text(
                                        '$_scycles',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          fontSize: 36.0,
                                          color: Color.fromARGB(200, 255, 255, 255)
                                        )
                                      )
                                    )
                                  )
                                ]
                            )
                        )
                      ],
                      controller: _controller
                  ),
                  // PageView Indicator
                  Container(
                      alignment: Alignment(0.0, 1.0),
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
                      child: SmoothPageIndicator(
                        controller: _controller,
                        count: 2,
                        effect: ColorTransitionEffect(
                            dotColor: Color.fromARGB(50, 255, 255, 255),
                            activeDotColor: Color.fromARGB(200, 255, 255, 255)
                        ),
                      )
                  )
                ]
            )
        )
    );
  }
}