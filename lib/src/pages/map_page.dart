import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_fly/src/blocs/provider.dart';
import 'package:project_fly/src/model/localidad_model.dart';


class MapPage extends StatelessWidget {


Completer<GoogleMapController> _controller = Completer();

final Set<Marker> _markers = Set();

void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
}

  @override
  Widget build(BuildContext context) {

    final diaBloc = Provider.diaBloc(context);
    //carga las coordenadas de la primera localidad
    final geopoint = diaBloc.dia.localidades[0].coordenadas; 
    CameraPosition _initialPosition = CameraPosition(target: LatLng(geopoint.latitude, geopoint.longitude),zoom: 10);

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
      infoWindow: InfoWindow(title: lugar.nombre),
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