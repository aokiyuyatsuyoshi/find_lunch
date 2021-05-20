import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class example1 extends StatefulWidget {
  @override
  _example1State createState() => _example1State();
}

class _example1State extends State<example1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(35.68131292899063, 139.76717584669254),
            zoom: 15,
          ),
        ),
      ),
    );
  }
}
