import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_fly/src/blocs/provider.dart';


class MapPage extends StatelessWidget {

CameraPosition _initialPosition = CameraPosition(target: LatLng(40.4167754, -3.7037902),zoom: 10);
Completer<GoogleMapController> _controller = Completer();

final Set<Marker> _markers = Set();

void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
}

  @override
  Widget build(BuildContext context) {

    final diaBloc = Provider.diaBloc(context);
    
    LatLng latLng = LatLng(36.841523, -2.4921361);


    _markers.add( Marker(
      markerId: MarkerId('una marca'),
      position: latLng,
      infoWindow: InfoWindow(title: 'aver',snippet: 'klkfsdj'),

    ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi viaje'),
      ),
      body: GoogleMap(    
          
          onMapCreated: _onMapCreated,
          initialCameraPosition: _initialPosition,
          markers: _crearMarcas(diaBloc)
        ),
    );
  }



  Set<Marker> _crearMarcas(DiaBloc diaBloc){
    Set<Marker> markers = Set();

    diaBloc.dia.localidades.forEach((localidad) {
      localidad.lugares.forEach((lugar) { 
      
      
      Marker marker = Marker(
      markerId: MarkerId(lugar.idLugar),
      position: latLngToGeopoint(lugar.coordenadas),
      infoWindow: InfoWindow(title: lugar.nombre, snippet: 'klkfsdj'),
      icon: BitmapDescriptor.defaultMarker
      );
      
      markers.add(marker);
      print(lugar.coordenadas.latitude);
      print(lugar.coordenadas.longitude);
      
      });
    });

    return markers;
  }

  LatLng latLngToGeopoint(GeoPoint coordenada){
    double lat = coordenada.latitude;
    double lng = coordenada.longitude;
    return LatLng(lat, lng);
  }
}