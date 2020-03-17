import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoPage extends StatefulWidget {
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  @override
  void initState() {
    super.initState();
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
                            colors: [Color(0xff374ABE), Color(0xff64B6FF)]
                          )
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'How old are you?',
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 24.0,
                                    color: Color.fromARGB(200, 255, 255, 255)
                                  )
                                )
                              )
                            )
                          ]
                        )
                      )
                    ],
                  ),
                ]
            )
        )
    );
  }
}