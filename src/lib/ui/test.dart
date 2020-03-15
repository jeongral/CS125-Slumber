import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final Color backgroundColor = Color(0xFF161616);

class MenuDashboardPage extends StatefulWidget {
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage> with SingleTickerProviderStateMixin {
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
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context),
        ],
      ),
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
                Text("\t\t\tJohn Doe", style: TextStyle(color: Colors.grey, fontSize: 22)),
                profilePicture("https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cg_face%2Cq_auto:good%2Cw_300/MTE1ODA0OTcxOTA3NTgxNDUz/hugh-jackman-16599916-1-402.jpg"),
                
                SizedBox(height: 60),
                Text("Data", style: TextStyle(color: Colors.white, fontSize: 22)),
                SizedBox(height: 15),
                Text("Notifications", style: TextStyle(color: Colors.white, fontSize: 22)),
                SizedBox(height: 15),
                Text("About", style: TextStyle(color: Colors.white, fontSize: 22)),
                SizedBox(height: 15),
                Text("Settings", style: TextStyle(color: Colors.white, fontSize: 22)),
                SizedBox(height: 15),
                Text("Logout", style: TextStyle(color: Colors.white, fontSize: 22)),
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
          elevation: 8,
          color: backgroundColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
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
                      Text("Reccomendations", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                      Icon(Icons.settings, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 50),

                  Container(
                    height: 200,
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
                              
                              itemCount: snapshot.data.length,
                              itemBuilder: (_,index){
                                return Container(
                                  height: 150,
                                  width: 300,

                                child: Card(    
                                  color: Color(0xFF1d1d1e),
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[

                                    Text(snapshot.data[index].data["Title"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    reccIcon(snapshot.data[index].data["Image"]),
                                    Text(snapshot.data[index].data["Details"], style: TextStyle(fontSize: 12),),
                                  ]
                                  
                                )));
                              
                            }
                              );
                            }
                          }
                      )
                      ]

                      )
                      ),


                    
                  
                  SizedBox(height: 20),
                  Text("Settings", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10),

                  // ListView.separated(
                  //   shrinkWrap: true,
                  //     itemBuilder: (context, index) {
                  //   return ListTile(
                  //     title: Text("Macbook"),
                  //     subtitle: Text("Apple"),
                  //     trailing: Text("-2900"),
                  //   );
                  // }, separatorBuilder: (context, index) {
                  //   return Divider(height: 16);
                  // }, itemCount: 10)

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
                                title: Text(snapshot.data[index].data["Title"], style: TextStyle(fontSize: 18),),
                                trailing: Text(snapshot.data[index].data["Value"], style: TextStyle(fontSize: 18, color: Colors.grey))
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
    QuerySnapshot qn = await firestore.collection("UserSettings").getDocuments();
    return qn.documents;
  }
  Future getRecs() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("Recommendations").getDocuments();
    return qn.documents;
  }

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