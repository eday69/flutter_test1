import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

//void main() => runApp(MaterialApp(
//    home: MyHome(),
//));

String jsonString =
'''[
   {"device": 354008976,
    "lattitud": 51.031889,
    "longitud": -114.044040,
    "name": "New Blackline"},
   {"device": 354003498,
    "lattitud": 51.045414,
    "longitud": -114.044018,
    "name": "Fort Calgary"},
   {"device": 354005589,
    "lattitud": 51.038809,
    "longitud": -114.053207,
    "name": "Estampede"}
  ]''';

final data = json.decode(jsonString);

class Point {
  int deviceId;
  double lattitud;
  double longitud;
  String name;

  Point({this.deviceId, this.lattitud, this.longitud, this.name});


  factory Point.fromJson(Map<String, dynamic> json) {
    return new Point(
      deviceId: json["device"] as int,
      lattitud: json["lattitud"] as double,
      longitud: json["longitud"] as double,
      name: json["name"] as String,
    );
  }
}

class Points {
  final List<Point> points;

  Points({
    this.points,
  });

  factory Points.fromJson(List<dynamic> parsedJson) {

    List<Point> points = new List<Point>();
    points = parsedJson.map((i)=>Point.fromJson(i)).toList();

    return new Points(
      points: points,
    );
  }

}
class SecondScreen extends StatefulWidget {

  @override
  MyState createState() => MyState();

}

//class _MyState extends State<MyHome> {
class MyState extends State<SecondScreen> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(51.038214, -114.033881);
  final Points puntos = Points.fromJson(data);
//  PhotosList photosList = PhotosList.fromJson(jsonResponse);

  List<Marker> markers = <Marker> [];

  void onMapRoutes() {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        _center,
        14.0, // Zoom factor
      ),
    );
  }

  void onMapGoHome() {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        _center,
        14.0, // Zoom factor
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      mapController.addMarker(
        MarkerOptions(
          position: _center,
          infoWindowText: InfoWindowText("Home", "Blackline"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    });
  }

  void _onAddMarkerButtonPressed(lattitude, longitud, deviceId, name) {
    mapController.addMarker(
      MarkerOptions(
        position: LatLng(
          lattitude,
          longitud,
        ),
        infoWindowText: InfoWindowText(deviceId.toString(), name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    );
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(lattitude, longitud),
        15.0, // Zoom factor
      ),
    );
  }

  void addDevToMap() {

    print("we are here, hello Eric, what can I do for you?");
    var point = puntos.points.length;
    if (point > 0) {
      var item = puntos.points[point - 1];
      _onAddMarkerButtonPressed(
          item.lattitud, item.longitud, item.deviceId, item.name);
      puntos.points.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: new AppBar(title: new Text('Device')),
      body: new Column(
        children: <Widget>[
          showMap(),
        ],
      ),
      floatingActionButton: new FancyFab(addDevToMap, onMapGoHome, onMapRoutes),
    );
  }

  Widget showMap() {
    return new Container(
//      constraints: BoxConstraints.expand(),
      height: MediaQuery.of(context).size. height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        options: GoogleMapOptions(
          mapType: MapType.terrain,
          compassEnabled: true,
          cameraPosition: CameraPosition(
            target: _center,
            zoom: 13.0,
          ),
        ),
      ),
    );
  }

}

class FancyFab extends StatefulWidget {
  final MyCallback callback;
  final MyCallback callbackHome;
  final MyCallback callbackRoute;

  FancyFab(this.callback, this.callbackHome, this.callbackRoute);

//  final Function() onPressed;
//  final String tooltip;
//  final IconData icon;

//  const FancyFab({this.onPressed, this.tooltip, this.icon, this.addDevToMap});

  @override
  _FancyFabState createState() => _FancyFabState(callback, callbackHome, callbackRoute);
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  final MyCallback callback;
  final MyCallback callbackHome;
  final MyCallback callbackRoute;

  _FancyFabState(this.callback, this.callbackHome, this.callbackRoute);
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;

  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget add() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          callback();
          },
        tooltip: 'Add',
        child: Icon(Icons.add),
        heroTag: null,
      ),
    );
  }

  Widget home() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Home',
        child: Icon(Icons.home),
        heroTag: null,
      ),
    );
  }

  Widget route() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          callbackRoute();
        },
        tooltip: 'Route',
        child: Icon(Icons.router),
        heroTag: null,
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
        heroTag: null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
          Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value * 3.0,
              0.0,
            ),
            child: add(),
          ),
          Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value * 2.0,
              0.0,
            ),
            child: route(),
          ),
          Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value,
              0.0,
            ),
            child: home(),
          ),
          toggle(),
      ],
    );
  }
}

typedef void MyCallback();
