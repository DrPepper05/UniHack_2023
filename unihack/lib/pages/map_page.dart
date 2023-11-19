import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Location _locationController = Location();
  LatLng? _currentP;
  double? _currentSpeed;
  LatLng? _circleCenter;
  double _circleRadius = 600;
  bool _isInsideCircle = false;
  DateTime? _entryTime;
  DateTime? _exitTime;

  static const LatLng sourceLocation = LatLng(45.7503, 21.2078);
  static const LatLng destination = LatLng(45.6, 21.3);
  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(45.7, 21.3), zoom: 14);

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    // getPolyPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Routes",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: _currentP == null
          ? const Text("Loading...")
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              markers: {
                Marker(
                  markerId: MarkerId("currentP"),
                  position: _currentP!,
                ),
              },
              circles: {
                Circle(
                  circleId: CircleId("2"),
                  center: _circleCenter ?? sourceLocation,
                  radius: _circleRadius,
                  fillColor: Color.fromARGB(0, 217, 133, 240).withOpacity(0.5),
                  strokeWidth: 1,
                )
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                googleMapController = controller;
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _resetCameraPosition();
            _checkIfInsideCircle();
          });
        },
        tooltip: 'Reset Camera',
        child: Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      bottomNavigationBar: _currentP != null
          ? BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  //'Current Speed: ${_currentSpeed != null ? _currentSpeed!.toStringAsFixed(2) + ' m/s' : 'N/A'}\n'
                  'Time Inside Circle: ${_calculateTimeInsideCircle()}',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            )
          : null,
    );
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

  void _resetCameraPosition() {
    if (_currentP != null && googleMapController != null) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentP!, zoom: 14, tilt: 50),
        ),
      );
    }
  }

  void _checkIfInsideCircle() {
    if (_currentP != null) {
      LatLng circleCenter = _circleCenter ?? sourceLocation;
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
        _isInsideCircle = false;
      }
    }
  }

  double? _entrySpeed;
  double? _exitSpeed;

  String _calculateTimeInsideCircle() {
    if (_entryTime != null && _exitTime != null) {
      Duration timeInsideCircle = _exitTime!.difference(_entryTime!);

      int seconds = timeInsideCircle.inSeconds;

      return 'Entry Speed: ${_entrySpeed != null ? _entrySpeed!.toStringAsFixed(2) + ' m/s' : 'N/A'}\n'
          'Exit Speed: ${_exitSpeed != null ? _exitSpeed!.toStringAsFixed(2) + ' m/s' : 'N/A'}\n'
          'Time Inside Circle: ${seconds.toString().padLeft(2, '0')} seconds\n';
    } else {
      return 'N/A';
    }
  }
}
