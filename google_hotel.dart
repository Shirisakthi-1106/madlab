// ======================================================================
// HOW TO RUN:
// 1. Add these dependencies in pubspec.yaml:
//   dependencies:
//     flutter:
//       sdk: flutter
//     google_maps_flutter: ^2.2.0
//     geolocator: ^9.0.2
//     http: ^0.13.5
//
// 2. Add these permissions in AndroidManifest.xml (android/app/src/main):
//   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
//   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
//
// 3. For iOS, add these in Info.plist (ios/Runner):
//   <key>NSLocationWhenInUseUsageDescription</key>
//   <string>Need location to show nearby hotels</string>
//
// 4. Get Google Maps API key from:
//   https://console.cloud.google.com/google/maps-apis/
// 5. Enable the Places API
// 6. Replace 'YOUR_GOOGLE_MAPS_API_KEY' below with your actual key
// ======================================================================

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const String googleApiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with your API key

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hotel Finder',
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentLocation;
  List<dynamic> _nearbyHotels = [];
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _currentLocation = LatLng(position.latitude, position.longitude);
      _getNearbyHotels(_currentLocation!);

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(_currentLocation!, 15));

      setState(() {}); // Trigger rebuild after location and hotels are fetched

    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _getNearbyHotels(LatLng location) async {
    const radius = 1500; // 1.5km radius
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
            'location=${location.latitude},${location.longitude}'
            '&radius=$radius'
            '&type=lodging'
            '&key=$googleApiKey');

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        _nearbyHotels = data['results'];
        _updateMarkers(); // Update markers on the map

      } else {
        print("Error fetching hotels: ${data['status']}");
      }
      setState(() {});  // Rebuild after fetching hotels

    } catch (e) {
      print("Error fetching hotels: $e");
    }
  }

  void _updateMarkers() {
    _markers.clear();
    for (var hotel in _nearbyHotels) {
      final lat = hotel['geometry']['location']['lat'];
      final lng = hotel['geometry']['location']['lng'];
      final marker = Marker(
        markerId: MarkerId(hotel['place_id']),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: hotel['name']),
      );
      _markers.add(marker);
    }
    setState(() {}); // Rebuild map with new markers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Hotels')),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              markers: _markers,
            ),
    );
  }
}
