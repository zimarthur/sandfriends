import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sandfriends/Common/Model/Store/StoreUser.dart';

import '../../../../Common/Model/Store/StoreComplete.dart';

class CourtMap extends StatefulWidget {
  final StoreUser store;
  const CourtMap({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  State<CourtMap> createState() => _CourtMapState();
}

class _CourtMapState extends State<CourtMap> {
  GoogleMapController? mapController; //contrller for Google map
  Set<Marker> markers = {}; //markers for google map
  LatLng? showLocation;

  @override
  void initState() {
    showLocation = LatLng(
      widget.store.latitude,
      widget.store.longitude,
    );
    markers.add(Marker(
      //add marker on google map
      markerId: MarkerId(showLocation.toString()),
      position: showLocation!, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: widget.store.name,
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      //Map widget from google_maps_flutter package
      zoomGesturesEnabled: true, //enable Zoom in, out on map
      initialCameraPosition: CameraPosition(
        //innital position in map
        target: showLocation!, //initial position
        zoom: 13.0, //initial zoom level
      ),
      markers: markers, //markers to show on map
      mapType: MapType.normal, //map type
      onMapCreated: (controller) {
        //method called when map is created
        setState(() {
          mapController = controller;
        });
      },
    );
  }
}
