import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Location _locationController = Location();
  late GoogleMapController googleMapController;
  LatLng? _currentP;
  late int seconds;
  double? _currentSpeed;
  LatLng? _circleCenter;
  bool byBus=false;
  double _circleRadius = 600;
  bool _isInsideCircle = false;
  DateTime? _entryTime;
  DateTime? _exitTime;
  double? _entrySpeed;
  double? _exitSpeed;

  ///location for first station

  // postData() async {
  //   var response = http.post(
  //     Uri.parse("uri")
  //   )
  // }

//Linia 9

  bool isMenuOpen = false;
  bool isDrawerOpen = false; // Track the state of the drawer
  int selectedIndex = -1;
  int selectedSubItemIndex = -1;
  int selectedSubGroupIndex = -1;
  int selectedGroupIndex = -1;
  bool showSubItems = false;

  List<LatLng> polylineCoordinates9 = [
    stat91,
    stat92,
    stat93,
    stat94,
    stat95,
    stat96,
    stat97,
    stat98,
    stat99,
    stat910,
    stat911,
    stat912,
    stat913,
    stat914,
    stat915,
    stat916,
    stat917,
    stat918,
    destination9
  ];

  static const LatLng sourceLocation9 =
      LatLng(45.75057926493502, 21.20823088985292);
  static const LatLng stat91 = LatLng(45.74521848241877, 21.211127509382397);
  static const LatLng stat92 = LatLng(45.74389611744414, 21.207250912992144);
  static const LatLng stat93 = LatLng(45.742862979147645, 21.204194208358366);
  static const LatLng stat94 = LatLng(45.7417687325482, 21.20115738096914);
  static const LatLng stat95 = LatLng(45.74014998134018, 21.196087188616055);
  static const LatLng stat96 = LatLng(45.73658035461111, 21.197996185791975);
  static const LatLng stat97 = LatLng(45.73400987410829, 21.20141779267481);
  static const LatLng stat98 = LatLng(45.73259267084318, 21.208295888479174);
  static const LatLng stat99 = LatLng(45.732515678063244, 21.213097257683753);
  static const LatLng stat910 = LatLng(45.73288545967701, 21.218815529925784);
  static const LatLng stat911 = LatLng(45.734994029544204, 21.226491265792383);
  static const LatLng stat912 = LatLng(45.736393247233615, 21.230921817864594);
  static const LatLng stat913 = LatLng(45.73851034584318, 21.237916055001598);
  static const LatLng stat914 = LatLng(45.73835975809282, 21.240314216825425);
  static const LatLng stat915 = LatLng(45.737229567829175, 21.250015556878118);
  static const LatLng stat916 = LatLng(45.73352935051215, 21.258394513673863);
  static const LatLng stat917 = LatLng(45.7324153224276, 21.260700879074268);
  static const LatLng stat918 = LatLng(45.73049678886477, 21.264780583751477);
  static const LatLng destination9 =
      LatLng(45.72936751466094, 21.26894495081785);
//Linia 33

  List<LatLng> polylineCoordinates33 = [];

  static const LatLng stat331 = LatLng(45.722617669688994, 21.200636356810715);
  static const LatLng stat332 = LatLng(45.724890245557354, 21.202616629614177);
  static const LatLng stat333 = LatLng(45.72887792016451, 21.206166500073156);
  static const LatLng stat334 = LatLng(45.73311929620821, 21.209017106454432);
  static const LatLng stat335 = LatLng(45.739770062029635, 21.210454779548936);
  static const LatLng stat336 = LatLng(45.74339915782569, 21.213358530784728);
  static const LatLng stat337 = LatLng(45.74640700978766, 21.21633259182766);
  static const LatLng stat338 = LatLng(45.75090524741432, 21.224961359684706);
//linia 40

  List<LatLng> polylineCoordinates40 = [
    stat401,
    stat402,
    stat403,
    stat404,
    stat405,
    stat406,
    stat407,
    stat408,
    stat409,
    stat4010,
    stat4011,
    stat4012,
    stat4013,
    stat4014,
    stat4015
  ];

  static const LatLng stat401 = LatLng(45.7546951726134, 21.233660740935353);
  static const LatLng stat402 = LatLng(45.76080007503016, 21.232885735760966);
  static const LatLng stat403 = LatLng(45.76721607908914, 21.23050863701988);
  static const LatLng stat404 = LatLng(45.76895472899073, 21.23240996232749);
  static const LatLng stat405 = LatLng(45.76769763209538, 21.238205460007368);
  static const LatLng stat406 = LatLng(45.76780228398388, 21.245097808954483);
  static const LatLng stat407 = LatLng(45.77302970570276, 21.245802854579882);
  static const LatLng stat408 = LatLng(45.775507449542296, 21.238369763737474);
  static const LatLng stat409 = LatLng(45.77678062815708, 21.233300553146524);
  static const LatLng stat4010 = LatLng(45.77321103345221, 21.231638781478424);
  static const LatLng stat4011 = LatLng(45.76920255313431, 21.23006687635919);
  static const LatLng stat4012 = LatLng(45.76920255313431, 21.230099708030714);
  static const LatLng stat4013 = LatLng(45.76553433967551, 21.231128501822948);
  static const LatLng stat4014 = LatLng(45.760450004520735, 21.232630882644198);
  static const LatLng stat4015 = LatLng(45.7546951726134, 21.233660740935353);
//Linia E1

// List<LatLng> polylineCoordinates911 = [stat9111,stat9112,stat9113,stat9114,stat9115,stat9116,stat9117,stat9118,stat9119,stat91110,stat91111,stat91112,stat91113,stat91114,stat91115,stat91116,stat91117,stat91118];

// static const LatLng stat9111=LatLng(45.722584941039635, 21.200701233528022);
// static const LatLng stat9112=LatLng(45.724887860809204 ,21.20265721610491);
// static const LatLng stat9113=LatLng(45.72887049391085 ,21.206185697082073);
// static const LatLng stat9114=LatLng(45.73311535448135 ,21.209020320917272);
// static const LatLng stat9115=LatLng(45.73947294646168 ,21.20976689215764);
// static const LatLng stat9116=LatLng(45.74391495685838 ,21.206650261224013);
// static const LatLng stat9117=LatLng(45.74955529569912 ,21.20277194116231);
// static const LatLng stat9118=LatLng(45.75028626879651 ,21.207478109042626);
// static const LatLng stat9119=LatLng(45.7603945250429 ,21.21871642366782);
// static const LatLng stat91110=LatLng(45.76316728473908, 21.221215870656483);
// static const LatLng stat91111=LatLng(45.764643407688226, 21.224822369325047);
// static const LatLng stat91112=LatLng(45.76913435237141 ,21.220154435766986);
// static const LatLng stat91113=LatLng(45.77309319512023 ,21.21597464975631);
// static const LatLng stat91114=LatLng(45.775677071316466 ,21.21339475031113);
// static const LatLng stat91115=LatLng(45.77727281502862 ,21.211674888213267);
// static const LatLng stat91116=LatLng(45.78337275584218 ,21.21926967225114);
// static const LatLng stat91117=LatLng(45.785706332739196 ,21.218362385851087);
// static const LatLng stat91118=LatLng(45.790252884780095 ,21.222839322303933);
//Linia 11

  List<LatLng> polylineCoordinates11 = [
    stat111,
    stat112,
    stat113,
    stat114,
    stat115,
    stat116,
    stat117,
    stat118,
    stat119,
    stat1110,
    stat1111,
    stat1112,
    stat1113,
    stat1114
  ];

  static const LatLng stat111 = LatLng(45.74908463662608, 21.199765124887993);
  static const LatLng stat112 = LatLng(45.7495423463654, 21.202724633994833);
  static const LatLng stat113 = LatLng(45.75043051052226, 21.208229789817008);
  static const LatLng stat114 = LatLng(45.75170007033979, 21.21626497482645);
  static const LatLng stat115 = LatLng(45.753203889233724, 21.222613473717104);
  static const LatLng stat116 = LatLng(45.75665158132033, 21.224870222712294);
  static const LatLng stat117 = LatLng(45.759176930618565, 21.227707205365967);
  static const LatLng stat118 = LatLng(45.758136360063716, 21.234289966174302);
  static const LatLng stat119 = LatLng(45.76038043719654, 21.24087400608778);
  static const LatLng stat1110 = LatLng(45.76262199334582, 21.24837725504052);
  static const LatLng stat1111 = LatLng(45.7634996494568, 21.25207970180493);
  static const LatLng stat1112 = LatLng(45.76376657831439, 21.256069963781492);
  static const LatLng stat1113 = LatLng(45.76580935881399, 21.261356475010434);
  static const LatLng stat1114 = LatLng(45.769659312740416, 21.26926707066574);
//Linia 14

  List<LatLng> polylineCoordinates14 = [
    stat141,
    stat142,
    stat143,
    stat144,
    stat145,
    stat146,
    stat147,
    stat148,
    stat149,
    stat1410,
    stat1411,
    stat1412
  ];

  static const LatLng stat141 = LatLng(45.74908463662608, 21.199765124887993);
  static const LatLng stat142 = LatLng(45.7495423463654, 21.202724633994833);
  static const LatLng stat143 = LatLng(45.75043051052226, 21.208229789817008);
  static const LatLng stat144 = LatLng(45.75170007033979, 21.21626497482645);
  static const LatLng stat145 = LatLng(45.753203889233724, 21.222613473717104);
  static const LatLng stat146 = LatLng(45.75665158132033, 21.224870222712294);
  static const LatLng stat147 = LatLng(45.765688318531865, 21.22544281577786);
  static const LatLng stat148 = LatLng(45.76810456012368, 21.22685431803312);
  static const LatLng stat149 = LatLng(45.76976944395817, 21.23060594255047);
  static const LatLng stat1410 = LatLng(45.772861062430366, 21.23179444910961);
  static const LatLng stat1411 = LatLng(45.7771841953166, 21.233630206885817);
  static const LatLng stat1412 = LatLng(45.780060168690426, 21.234851545142995);
//Linia 17

  List<LatLng> polylineCoordinates17 = [
    stat171,
    stat172,
    stat173,
    stat174,
    stat175,
    stat176,
    stat177,
    stat178,
    stat179
  ];

  static const LatLng stat171 = LatLng(45.76258469934511, 21.244714908643264);
  static const LatLng stat172 = LatLng(45.76086683825551, 21.241458006792364);
  static const LatLng stat173 = LatLng(45.75904813832859, 21.23646102618907);
  static const LatLng stat174 = LatLng(45.75875036063755, 21.232041883090076);
  static const LatLng stat175 = LatLng(45.76611689491116, 21.225377984988096);
  static const LatLng stat176 = LatLng(45.77077957593329, 21.223090026642);
  static const LatLng stat177 = LatLng(45.776119084471894, 21.221175106183395);
  static const LatLng stat178 = LatLng(45.77847523827693, 21.220547867135103);
  static const LatLng stat179 = LatLng(45.78371712451807, 21.219167982794477);
  List<Circle> stations = [
    Circle(
      circleId: CircleId("33"),
      center: stat331,
      radius: 35,
      fillColor: Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
      strokeWidth: 1,
    ),
    Circle(
      circleId: CircleId("33"),
      center: stat332,
      radius: 35,
      fillColor: Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
      strokeWidth: 1,
    ),
    Circle(
      circleId: CircleId("33"),
      center: stat333,
      radius: 35,
      fillColor: Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
      strokeWidth: 1,
    ),
    Circle(
      circleId: CircleId("33"),
      center: stat334,
      radius: 35,
      fillColor: Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
      strokeWidth: 1,
    ),
    Circle(
      circleId: CircleId("33"),
      center: stat335,
      radius: 35,
      fillColor: Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
      strokeWidth: 1,
    ),
    Circle(
      circleId: CircleId("33"),
      center: stat336,
      radius: 35,
      fillColor: Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
      strokeWidth: 1,
    ),
    Circle(
      circleId: CircleId("33"),
      center: stat337,
      radius: 35,
      fillColor: Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
      strokeWidth: 1,
    ),
    Circle(
      circleId: CircleId("33"),
      center: stat338,
      radius: 35,
      fillColor: Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
      strokeWidth: 1,
    ),
  ];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCRJK_16LGvvWsP56FM9_xcCM5WACPD2u4",
      PointLatLng(stat331.latitude, stat331.longitude),
      PointLatLng(stat338.latitude, stat338.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates33.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _currentSpeed = currentLocation.speed;
          _checkIfInsideCircle();
        });
      }
    });
  }

  void _checkIfInsideCircle() {
    if (_currentP != null) {
      LatLng circleCenter = stat332;
      final currentPosMp =
          toolkit.LatLng(_currentP!.latitude, _currentP!.longitude);
      final pointMp =
          toolkit.LatLng(circleCenter.latitude, circleCenter.longitude);
      num distance = toolkit.SphericalUtil.computeDistanceBetween(
        toolkit.LatLng(pointMp.latitude, pointMp.longitude),
        currentPosMp,
      );

      if (distance <= _circleRadius && !_isInsideCircle) {
        // User enters the circle
        _entryTime = DateTime.now();
        _entrySpeed = _currentSpeed; // Capture entry speed
        _isInsideCircle = true;
      } else if (distance > _circleRadius && _isInsideCircle) {
        // User exits the circle
        _exitTime = DateTime.now();
        _exitSpeed = _currentSpeed; // Capture exit speed
        seconds = 0;
        _isInsideCircle = false;
      }
    }
  }

  String _calculateTimeInsideCircle() {
    if (_entryTime != null && _exitTime != null) {
      Duration timeInsideCircle = _exitTime!.difference(_entryTime!);

      seconds = timeInsideCircle.inSeconds;
      if (seconds > 1 && _entrySpeed! < 15 && _exitSpeed! > 20) {
        print(
            'circle condition======================================================================================================================================================================================================================');
        byBus = true;
      }
      return //'Entry Speed: ${_entrySpeed != null ? _entrySpeed!.toStringAsFixed(2) + ' m/s' : 'N/A'}\n'
          //'Exit Speed: ${_exitSpeed != null ? _exitSpeed!.toStringAsFixed(2) + ' m/s' : 'N/A'}\n'
          '${seconds.toString().padLeft(2, '0')} seconds\n';
    } else {
      return 'N/A';
    }
  }

  @override
  void initState() {
    getPolyPoints();
    getLocationUpdates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          title: Row(
            children: [
              SearchBar(),
              const Spacer(),
              // IconButton(
              //   icon: const Icon(Icons.person),
              //   color: Color.fromARGB(255, 179, 157, 219),
              //   onPressed: () {
              //     Navigator.of(context).push(customPageRoute(SecondPage()));
              //   },
              // ),
            ],
          ),
        ),
      ),
      body: _currentP == null
          ? const Text("Loading...")
          : Stack(
              children: [
                Center(
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: sourceLocation9, zoom: 15),
                    circles: {
                      Circle(
                        circleId: CircleId("33"),
                        center: stat331,
                        radius: 35,
                        fillColor:
                            Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
                        strokeWidth: 1,
                      ),
                      Circle(
                        circleId: CircleId("33"),
                        center: stat332,
                        radius: 35,
                        fillColor:
                            Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
                        strokeWidth: 1,
                      ),
                      Circle(
                        circleId: CircleId("33"),
                        center: stat333,
                        radius: 35,
                        fillColor:
                            Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
                        strokeWidth: 1,
                      ),
                      Circle(
                        circleId: CircleId("33"),
                        center: stat334,
                        radius: 35,
                        fillColor:
                            Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
                        strokeWidth: 1,
                      ),
                      Circle(
                        circleId: CircleId("33"),
                        center: stat335,
                        radius: 35,
                        fillColor:
                            Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
                        strokeWidth: 1,
                      ),
                      Circle(
                        circleId: CircleId("33"),
                        center: stat336,
                        radius: 35,
                        fillColor:
                            Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
                        strokeWidth: 1,
                      ),
                      Circle(
                        circleId: CircleId("33"),
                        center: stat337,
                        radius: 35,
                        fillColor:
                            Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
                        strokeWidth: 1,
                      ),
                      Circle(
                        circleId: CircleId("33"),
                        center: stat338,
                        radius: 35,
                        fillColor:
                            Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
                        strokeWidth: 1,
                      ),
                    },
                    polylines: {
                      Polyline(
                        polylineId: PolylineId("linia9"),
                        points: polylineCoordinates9,
                        color: Colors.blue,
                      ),
                      Polyline(
                        polylineId: PolylineId("linia33"),
                        points: polylineCoordinates33,
                        color: Colors.greenAccent,
                      ),
                      Polyline(
                        polylineId: PolylineId("linia40"),
                        points: polylineCoordinates40,
                        color: Colors.green,
                      ),
                      // Polyline(
                      //   polylineId: PolylineId("liinaE1"),
                      //   points: polylineCoordinates911,
                      //   color: Colors.yellow,
                      // ),
                      Polyline(
                        polylineId: PolylineId("linia11"),
                        points: polylineCoordinates11,
                        color: Colors.pink,
                      ),
                      Polyline(
                        polylineId: PolylineId("linia14"),
                        points: polylineCoordinates14,
                        color: Colors.purple,
                      ),
                      Polyline(
                        polylineId: PolylineId("linia17"),
                        points: polylineCoordinates17,
                        color: Colors.brown,
                      ),
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId("currentP"),
                        position: _currentP!,
                      ),
                      const Marker(
                        markerId: MarkerId("source9"),
                        position: sourceLocation9,
                      ),
                      const Marker(
                        markerId: MarkerId("destination9"),
                        position: destination9,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat91,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat92,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat93,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat94,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat95,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat96,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat97,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat98,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat99,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat910,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat911,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat912,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat913,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat914,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat915,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat916,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat917,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: stat918,
                      ),
                      const Marker(
                        markerId: MarkerId("firstStation9"),
                        position: destination9,
                      )
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      googleMapController = controller;
                    },
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  bottom: isMenuOpen
                      ? 0
                      : -MediaQuery.of(context).size.height * 0.7,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 40,
                          color: Color.fromARGB(255, 179, 157, 219),
                          child: const Center(
                            child: Text(
                              'Menu Header',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildMenuItem(
                                  'Buses', 'assets/images/bus_icon.png', 0),
                              _buildMenuItem(
                                  'Hours', 'assets/images/time-icon.png', 1),
                              _buildMenuItem(
                                  'Places', 'assets/images/tree-icon.png', 2),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Colors.black),
                        if (showSubItems)
                          if (selectedGroupIndex == 0)
                            Column(
                              children: [
                                _buildSubItemsRow(['33', '40', 'E1'], 'Bus', 1),
                                _buildSubItemsRow(['2', '7', '9'], 'Tram', 2),
                                _buildSubItemsRow(
                                    ['11', '14', '17'], 'Trolley', 3),
                              ],
                            ),
                        if (selectedGroupIndex == 1)
                          Column(
                            children: [
                              _buildSubItemsRow(
                                  ['Bus', 'Tramv', "Trolley"], 'Transport', 4),
                            ],
                          ),
                        const Expanded(
                          child: Center(
                            child: Text('Choose an option'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 16.0),
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       setState(() {
      //         isMenuOpen = !isMenuOpen;
      //       });
      //     },
      //     child: Icon(
      //         isMenuOpen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      bottomNavigationBar: _currentP != null
          ? BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: byBus==false?
                Text(
                  'Current Speed: ${_currentSpeed != null ? _currentSpeed!.toStringAsFixed(2) + ' m/s' : 'N/A'}\n'
                  'Time Inside Circle: ${_calculateTimeInsideCircle()}',
                  style: TextStyle(fontSize: 18.0))
                :Text('You are now travelling by bus', style: TextStyle(fontSize: 18.0),
              ),)
            )
          : null,
      //if you want to test exit speed, entry speed, time spend , etc...
    );
  }

  Widget _buildMenuItem(String title, String imagePath, int index) {
    bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGroupIndex = index;
          selectedSubGroupIndex = index;
          selectedSubItemIndex = -1;
          selectedIndex = index;
          showSubItems = title == 'Buses'; // Show sub items only for 'Buses'
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepPurple[200] : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubItemsRow(
      List<String> subItems, String subtitle, int groupId) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int k = 0; k < subItems.length; k++)
                _buildSubItem(subItems[k], k + 1, groupId),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubItem(String title, int index, int groupIndex) {
    bool isSelected = ((index == selectedSubItemIndex) &&
        (groupIndex == selectedSubGroupIndex));
    //print("Index, selIndex, grIndex, selGrIndex $index, $selectedSubItemIndex, $groupIndex, $selectedGroupIndex, -> $isSelected");
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSubItemIndex = index;
          selectedSubGroupIndex = groupIndex;
          if (selectedGroupIndex == 0) isMenuOpen = false;
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepPurple[200] : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          // Show a search box when the user taps on the search bar
          showSearch(
            context: context,
            delegate: BusLineSearchDelegate([
              'Bus Line 33',
              'Bus Line 40',
              'Bus Line E1',
              'Tram 2',
              'Tram 7',
              'Tram 9',
              'Trolley 11',
              'Trolley 14',
              'Trolley17'
            ]),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(8.0),
          child: const Icon(
            Icons.search,
            size: 24.0,
            color: Color.fromARGB(255, 179, 157, 219),
          ),
        ),
      ),
    );
  }
}

class BusLineSearchDelegate extends SearchDelegate<String> {
  final List<String> busLines;

  BusLineSearchDelegate(this.busLines);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> filteredList = busLines
        .where((line) => line.toLowerCase().contains(query.toLowerCase()))
        .toList();
    filteredList.sort();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredList[index]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusLineDetailsPage(
                  index: busLines.indexOf(filteredList[index]),
                  busLine: filteredList[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class BusLineDetailsPage extends StatelessWidget {
  final int index;
  final String busLine;

  BusLineDetailsPage({required this.index, required this.busLine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Line $index Details'),
      ),
      body: Center(
        child: Text('Details about $busLine'),
      ),
    );
  }
}
