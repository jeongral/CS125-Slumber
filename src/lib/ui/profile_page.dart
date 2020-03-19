import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'info_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  ScrollController scrollController;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    pageController = PageController(viewportFraction: 0.8);
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff374ABE), Color(0xff64B6FF)]
            )
        ),
        child: Stack(
          children: <Widget>[
            menu(context),
            dashboard(context),
          ],
        ),
      )
    );
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("John Doe", style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    color: Color.fromARGB(200, 255, 255, 255),
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold
                  )
                )),
                SizedBox(height: 30),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InfoPage())
                    );
                  },
                  child: Text("Change Profile", style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          color: Color.fromARGB(200, 255, 255, 255),
                          fontSize: 24.0
                      )
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
 
  Container profilePicture(String profileURL){
    return new Container(
      width: 130.0,
      height: 130.0,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
          fit: BoxFit.fill,
          image: new NetworkImage(
                 profileURL)
                 )
));
}
  Container reccIcon(String url){
    return new Container(
      width: 50.0,
      height: 50.0,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
          fit: BoxFit.fill,
          image: new NetworkImage(
                 url)
                 )
));
}

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          elevation: 0,
          color: Colors.transparent,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        child: Icon(Icons.menu, color: Colors.white),
                        onTap: () {
                          setState(() {
                            if (isCollapsed)
                              _controller.forward();
                            else
                              _controller.reverse();

                            isCollapsed = !isCollapsed;
                          });
                        },
                      ),
                      Text("Reccomendations", style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontSize: 24.0,
                          color: Color.fromARGB(200, 255, 255, 255),
                          fontWeight: FontWeight.bold
                        )
                      )),
                      Icon(Icons.settings, color: Color.fromARGB(200, 255, 255, 255))
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    height: 250,
                    width: 300,
                    child: PageView(
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      pageSnapping: true,
                      children: <Widget>[

                        FutureBuilder(
                          future: getRecs(),
                          builder: (_,snapshot){

                            if(snapshot.connectionState == ConnectionState.waiting){
                              return Center(child: Text("Loading..."));
                            }else{
                              return ListView.builder(
                              controller: pageController,
                              scrollDirection: Axis.horizontal,
                              
                              itemCount: 3,
                              itemBuilder: (_,index){
                                return Container(
                                  height: 250,
                                  width: 300,

                                child: Card(    
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(snapshot.data[index].data["Title"], style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 24, color: Color.fromARGB(200, 255, 255, 255), fontWeight: FontWeight.bold))),
                                    reccIcon(snapshot.data[index].data["Image"]),
                                    Text(snapshot.data[index].data["Details"], textAlign: TextAlign.center,style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 18, color: Color.fromARGB(200, 255, 255, 255)))),
                                  ]
                                  
                                )));
                            }
                              );
                            }
                          }
                      )]
                      )),
                  SizedBox(height: 10),
                  Text("Settings", style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 24, color: Color.fromARGB(200, 255, 255, 255), fontWeight: FontWeight.bold))),
                  SizedBox(height: 10),
                  FutureBuilder(
                    future: getData(),
                    builder: (_,snapshot){

                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: Text("Loading..."));
                      }else{
                          return ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (_,index){
                              return ListTile(    
                                title: Text(snapshot.data[index].data["Title"], style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 18, color: Color.fromARGB(200, 255, 255, 255), fontWeight: FontWeight.bold))),
                                trailing: Text(snapshot.data[index].data["Value"], style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 18, color: Color.fromARGB(200, 255, 255, 255))))
                                );
                            }
                            );
                        }
                      }
                    )
                  


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getData() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("UserSettings").orderBy('Order').getDocuments();
    return qn.documents;
  }
  Future getRecs() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("Recommendations").orderBy('Rank', descending: true).getDocuments();
    return qn.documents;
  }

  // Future addSampleRec() async{
  //       Firestore.instance.runTransaction((transaction) async {
  //         await transaction.set(Firestore.instance.collection("Recommendations").document(), {
  //           'Title': "This is a sample",
  //           'Details': "Test Test Test",
  //           'Image': "https://firebasestorage.googleapis.com/v0/b/slumber-5f1b1.appspot.com/o/bed.png?alt=media&token=4ee0888c-6eed-436a-882d-8573fbca8494",
  //         });
  //       });
  // }

   Widget userSettings(context){
     return new Container(
        child: FutureBuilder(
          future: getData(),
          builder: (_,snapshot){

            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: Text("Loading..."));
            }else{
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_,index){
                    return ListTile(
                      title: Text(snapshot.data[index].data["Title"]),
                      );
                  }
                  );
            }
          }
          ),
     );
  }
}