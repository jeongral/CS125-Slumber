import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InfoPage extends StatefulWidget {
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  int _genderRadioValue = -1;
  int _activityRadioValue = -1;
  PageController _controller;

  int _age = 21;
  String _gender = "Male";
  String _activityLevel = "Very High";
  String _ssleepTime = DateFormat.jm().format(DateTime.now());
  DateTime _sleepTime = DateTime.now();
  String _wakeTime = DateFormat.jm().format(DateTime.now());
  int _idealHours = 8;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleGenderRadioValue(int value) {
    setState(() {
      _genderRadioValue = value;
      switch (_genderRadioValue) {
        case 0:
          _gender = "Male";
          break;
        case 1:
          _gender = "Female";
          break;
      }
    });
  }

  void _handleActivityRadioValue(int value) {
    setState(() {
      _activityRadioValue = value;
      switch (_activityRadioValue) {
        case 0:
          _activityLevel = "Very Low";
          break;
          break;
        case 1:
          _activityLevel = "Low";
          break;
        case 2:
          _activityLevel = "Average";
          break;
        case 3:
          _activityLevel = "High";
          break;
        case 4:
          _activityLevel = "Very High";
          break;
      }
    });
  }

  void _addToFirebase() async {
    Firestore.instance.collection('UserSettings').document('Age').setData({
      'Title': 'Age',
      'Order': 1,
      'Value': '$_age'
    });
    Firestore.instance.collection('UserSettings').document('Activity Level').setData({
      'Title': 'Activity Level',
      'Order': 3,
      'Value': _activityLevel
    });
    Firestore.instance.collection('UserSettings').document('Gender').setData({
      'Title': 'Gender',
      'Order': 2,
      'Value': _gender
    });
    Firestore.instance.collection('UserSettings').document('Sleep Time').setData({
      'Title': 'Sleep Time',
      'Order': 4,
      'Value': _ssleepTime
    });
    Firestore.instance.collection('UserSettings').document('Ideal Hours').setData({
      'Title': 'Ideal Hours',
      'Order': 6,
      'Value': '$_idealHours'
    });
    Firestore.instance.collection('UserSettings').document('Wake Time').setData({
      'Title': 'Wake Time',
      'Order': 5,
      'Value': _wakeTime
    });

    int rank_getMoreSleep = 0;
    int rank_tooMuchSleep = 0;
    int rank_tooBusyToSleep = 0;
    int rank_increaseActivity = 0;
    int rank_nightOwl = 0;

    if (_age < 20) {
      rank_getMoreSleep = 1;
      if (_idealHours < 8)
        rank_getMoreSleep = 4;
    }
    Firestore.instance.collection('Recommendations').document('Get More Sleep').updateData({
      'Rank': rank_getMoreSleep
    });

    if (_idealHours > 10) {
      rank_tooMuchSleep = 4;
    }
    Firestore.instance.collection('Recommendations').document('Too Much Sleep').updateData({
      'Rank': rank_tooMuchSleep
    });

    if (_activityLevel == 'Very High')
      rank_tooBusyToSleep = 3;
    else if (_activityLevel == 'High')
      rank_tooBusyToSleep = 2;
    else if (_activityLevel == 'Average')
      rank_increaseActivity = 1;
    else if (_activityLevel == 'Low')
      rank_increaseActivity = 2;
    else if (_activityLevel == 'Very Low')
      rank_increaseActivity = 3;

    Firestore.instance.collection('Recommendations').document('Too Busy to Sleep').updateData({
      'Rank': rank_tooBusyToSleep
    });

    Firestore.instance.collection('Recommendations').document('Increase Physical Activity').updateData({
      'Rank': rank_increaseActivity
    });

    if (_sleepTime.hour > 2 && _sleepTime.hour < 6)
      rank_nightOwl = 4;

    Firestore.instance.collection('Recommendations').document('Night Owl').updateData({
      'Rank': rank_nightOwl
    });
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
                                  colors: [Color(0xff374ABE), Color(0xff64B6FF)]
                              )
                          ),
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    width: 300,
                                    child: Text(
                                        'How old are you?',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                fontSize: 32.0,
                                                color: Color.fromARGB(200, 255, 255, 255)
                                            )
                                        )
                                    )
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          NumberPicker.horizontal(
                                            initialValue: _age,
                                            minValue: 0,
                                            maxValue: 100,
                                            onChanged: (newValue) =>
                                                setState(() => _age = newValue)
                                          )
                                        ]
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
                                'What is your gender?',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 32.0,
                                    color: Color.fromARGB(200, 255, 255, 255)
                                  )
                                )
                              )
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Radio(
                                          value: 0,
                                          groupValue: _genderRadioValue,
                                          onChanged: _handleGenderRadioValue,
                                          activeColor: Color.fromARGB(200, 255, 255, 255),
                                        ),
                                        Text(
                                            'Male',
                                            style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                    fontSize: 24,
                                                    color: Color.fromARGB(200, 255, 255, 255)
                                                )
                                            )
                                        )
                                      ]
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: _genderRadioValue,
                                          onChanged: _handleGenderRadioValue,
                                          activeColor: Color.fromARGB(200, 255, 255, 255),
                                        ),
                                        Text(
                                            'Female',
                                            style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                    fontSize: 24,
                                                    color: Color.fromARGB(200, 255, 255, 255)
                                                )
                                            )
                                        )
                                      ]
                                  )
                                ]
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
                                  width: 300,
                                    child: Text(
                                        'Choose your activity level:',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                fontSize: 32.0,
                                                color: Color.fromARGB(200, 255, 255, 255)
                                            )
                                        )
                                    )
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Radio(
                                                  value: 0,
                                                  groupValue: _activityRadioValue,
                                                  onChanged: _handleActivityRadioValue,
                                                  activeColor: Color.fromARGB(200, 255, 255, 255),
                                                ),
                                                Text(
                                                    'Very low',
                                                    style: GoogleFonts.quicksand(
                                                        textStyle: TextStyle(
                                                            fontSize: 24,
                                                            color: Color.fromARGB(200, 255, 255, 255)
                                                        )
                                                    )
                                                )
                                              ]
                                          ),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Radio(
                                                  value: 1,
                                                  groupValue: _activityRadioValue,
                                                  onChanged: _handleActivityRadioValue,
                                                  activeColor: Color.fromARGB(200, 255, 255, 255),
                                                ),
                                                Text(
                                                    'Low',
                                                    style: GoogleFonts.quicksand(
                                                        textStyle: TextStyle(
                                                            fontSize: 24,
                                                            color: Color.fromARGB(200, 255, 255, 255)
                                                        )
                                                    )
                                                )
                                              ]
                                          ),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Radio(
                                                  value: 2,
                                                  groupValue: _activityRadioValue,
                                                  onChanged: _handleActivityRadioValue,
                                                  activeColor: Color.fromARGB(200, 255, 255, 255),
                                                ),
                                                Text(
                                                    'Average',
                                                    style: GoogleFonts.quicksand(
                                                        textStyle: TextStyle(
                                                            fontSize: 24,
                                                            color: Color.fromARGB(200, 255, 255, 255)
                                                        )
                                                    )
                                                )
                                              ]
                                          ),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Radio(
                                                  value: 3,
                                                  groupValue: _activityRadioValue,
                                                  onChanged: _handleActivityRadioValue,
                                                  activeColor: Color.fromARGB(200, 255, 255, 255),
                                                ),
                                                Text(
                                                    'High',
                                                    style: GoogleFonts.quicksand(
                                                        textStyle: TextStyle(
                                                            fontSize: 24,
                                                            color: Color.fromARGB(200, 255, 255, 255)
                                                        )
                                                    )
                                                )
                                              ]
                                          ),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Radio(
                                                  value: 4,
                                                  groupValue: _activityRadioValue,
                                                  onChanged: _handleActivityRadioValue,
                                                  activeColor: Color.fromARGB(200, 255, 255, 255),
                                                ),
                                                Text(
                                                    'Very high',
                                                    style: GoogleFonts.quicksand(
                                                        textStyle: TextStyle(
                                                            fontSize: 24,
                                                            color: Color.fromARGB(200, 255, 255, 255)
                                                        )
                                                    )
                                                )
                                              ]
                                          ),
                                        ]
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
                                    width: 300,
                                    child: Text(
                                        'What time do you usually go to sleep?',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                fontSize: 32.0,
                                                color: Color.fromARGB(200, 255, 255, 255)
                                            )
                                        )
                                    )
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              _ssleepTime,
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                  fontSize: 60.0,
                                                  color: Color.fromARGB(200, 255, 255, 255)
                                                )
                                              )
                                            )
                                          ),
                                          Container(
                                            child: RaisedButton(
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
                                                        _sleepTime = time;
                                                        _ssleepTime = DateFormat.jm().format(time);
                                                        setState(() {});
                                                      },
                                                      currentTime: DateTime.now(),
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
                                          )
                                        ]
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
                                    width: 300,
                                    child: Text(
                                        'What time do you usually wake up?',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                fontSize: 32.0,
                                                color: Color.fromARGB(200, 255, 255, 255)
                                            )
                                        )
                                    )
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              child: Text(
                                                  _wakeTime,
                                                  style: GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                          fontSize: 60.0,
                                                          color: Color.fromARGB(200, 255, 255, 255)
                                                      )
                                                  )
                                              )
                                          ),
                                          Container(
                                            child: RaisedButton(
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
                                                        _wakeTime = DateFormat.jm().format(time);
                                                        setState(() {});
                                                      },
                                                      currentTime: DateTime.now(),
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
                                          )
                                        ]
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
                                    width: 300,
                                    child: Text(
                                        'How many hours do you think you need for sleep?',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                fontSize: 32.0,
                                                color: Color.fromARGB(200, 255, 255, 255)
                                            )
                                        )
                                    )
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          NumberPicker.horizontal(
                                              initialValue: _idealHours,
                                              minValue: 1,
                                              maxValue: 24,
                                              onChanged: (newValue) =>
                                                  setState(() => _idealHours = newValue)
                                          )
                                        ]
                                    )
                                ),
                                Container(
                                  child: RaisedButton(
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
                                      _addToFirebase();
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 200.0,
                                      height: 50.0,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'SUBMIT',
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 32.0,
                                            color: Color.fromARGB(200, 255, 255, 255)
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              ]
                          )
                      ),
                    ],
                    controller: _controller,
                  ),
                  Container(
                    alignment: Alignment(0.0, 1.0),
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 100.0),
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: 6,
                      effect: ColorTransitionEffect(
                        dotColor: Color.fromARGB(50, 255, 255, 255),
                        activeDotColor: Color.fromARGB(200, 255, 255, 255)
                      )
                    )
                  ),
                  Container(
                    alignment: Alignment(-1.0, -1.0),
                    padding: EdgeInsets.fromLTRB(10.0, 50.0, 0.0, 0.0),
                    child: BackButton(
                      color: Color.fromARGB(200, 255, 255, 255)
                    )
                  ),
                ]
            )
        )
    );
  }
}