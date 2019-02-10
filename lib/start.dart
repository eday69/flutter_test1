import 'package:flutter/material.dart';

import 'package:flutter_day/second.dart';

//void main() => runApp(new MyApp());

void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    // Start the app with the "/" named route. In our case, the app will start
    // on the FirstScreen Widget
    initialRoute: '/',
    routes: {
      // When we navigate to the "/" route, build the FirstScreen Widget
      '/': (context) => FirstScreen(),
//      // When we navigate to the "/second" route, build the SecondScreen Widget
//      '/second': (context) => SecondScreen(),
    },
  ));
}


class FirstScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/images/g7-img.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.red[800],
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondScreen()),
            );
          },
          tooltip: 'Enter',
          child:  Icon(Icons.input),
          heroTag: context,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
  }
}
