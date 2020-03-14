import 'package:flutter/material.dart';

class Profile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Color(0xFF1d1d1e),
      appBar: buildAppBar(),
      body: new Center(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          profilePicture("https://i.pinimg.com/564x/f8/27/ed/f827ed9a704146f65b96226f430abf3c.jpg"),
          Text("John Doe", style: new TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          ),),
          Container(

          )
          
        ],
      ),
    ));
  }

    AppBar buildAppBar(){
    return new AppBar(
      title: Text("Profile"),
      centerTitle: true,

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
static Image getImg(String str) {
  return new Image(image: new NetworkImage(
                 str)
                 );
}

  Widget userCard(String imageURL){

              return Container( 
                margin: EdgeInsets.all(16.0),
                
                child: Container(   
                decoration: new BoxDecoration(
                 color: Color(0xFF252527),
                 boxShadow: [
                   BoxShadow(
            color: Colors.black,
            blurRadius: 20.0, // has the effect of softening the shadow
            spreadRadius: 5.0, // has the effect of extending the shadow
            offset: Offset(
              10.0, // horizontal, move right 10
              10.0, // vertical, move down 10
            ),
          )
                 ],
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(30.0),
                      bottomLeft:  const Radius.circular(30.0),
                      bottomRight:  const Radius.circular(30.0),
                      topRight: const Radius.circular(30.0))),

                  // child: Card(
                  //   margin: new EdgeInsets.all(16.0),
                  // elevation: 10.0,
                  // color: Color(0xFF252527),
                  
                  child: new Column(mainAxisSize: MainAxisSize.min, children: <
                      Widget>[
                    ListTile(
                        leading: new Container(
                          child:
                            new Image.asset("assets/images/gear.png"),
                          height: 52.0,
                          width: 52.0,
                        ),
                        title: new Text("User Preferences"))])
                ));
                        
  }
}