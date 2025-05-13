import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationUserProvider extends StatefulWidget {
  const LocationUserProvider({
    super.key,
    required this.longitude,
    required this.latitude,
  });

  final double longitude;
  final double latitude;

  @override
  State<LocationUserProvider> createState() => _LocationUserProviderState();
}

class _LocationUserProviderState extends State<LocationUserProvider> {
  final Location location = Location();
  final Completer<GoogleMapController> _controller = Completer();

  PermissionStatus _permissionGranted = PermissionStatus.denied;
  bool _serviceEnabled = false;
  LocationData? locationData;

  late Marker initialMarker;
  Marker? userMarker;
  Polyline? routePolyline;

  @override
  void initState() {
    super.initState();
    _initializeMarkersAndRoute();
  }

  Future<void> _initializeMarkersAndRoute() async {
    initialMarker = Marker(
      markerId: const MarkerId("initial_position"),
      position: LatLng(widget.latitude, widget.longitude),
      infoWindow: InfoWindow(
        title: "Initial Position",
        snippet: "(${widget.latitude}, ${widget.longitude})",
      ),
    );

    if (await _isPermissionGranted() && await _isServicesEnabled()) {
      locationData = await location.getLocation();

      if (locationData != null) {
        final userPosition = LatLng(
          locationData!.latitude!,
          locationData!.longitude!,
        );

        userMarker = Marker(
          markerId: const MarkerId("user_position"),
          position: userPosition,
          infoWindow: InfoWindow(
            title: "Your Location",
            snippet: "(${userPosition.latitude}, ${userPosition.longitude})",
          ),
        );

        routePolyline = Polyline(
          polylineId: const PolylineId("route"),
          points: [
            userPosition,
            LatLng(widget.latitude, widget.longitude),
          ],
          color: Colors.blue,
          width: 5,
        );

        setState(() {});

        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newLatLng(userPosition),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: GoogleMap(
          mapType: MapType.hybrid,
          zoomControlsEnabled: false,
          cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
              northeast: const LatLng(31.916667, 35.000000),
              southwest: const LatLng(22.000000, 25.000000),
            ),
          ),
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longitude),
            zoom: 18.0,
          ),
          markers: {
            initialMarker,
            if (userMarker != null) userMarker!,
          },
          polylines: {
            if (routePolyline != null) routePolyline!,
          },
          onMapCreated: (controller) => _controller.complete(controller),
        ),
      ),
    );
  }

  Future<bool> _isPermissionGranted() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }
    return _permissionGranted == PermissionStatus.granted;
  }

  Future<bool> _isServicesEnabled() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
    return _serviceEnabled;
  }
}
