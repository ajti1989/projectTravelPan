import 'dart:convert';

import 'package:project_fly/src/model/localidad_model.dart';
import 'package:project_fly/src/model/lugar_model.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';

class GoPlaceProvider{

  final String _apiKey = 'AIzaSyCgeusmPcvK4MqjH6YwSBKHQN8nByVHsQk';

  //consulta autocompletado
  Future<List<Map<String, String>>> autoComplete(String busqueda) async{
    
    List<Map<String, String>> lugares = List();

    final resp = await http.get('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$busqueda&key=$_apiKey&language=es');
  
    final decoded = json.decode(resp.body); 
     
    for (var lugar in decoded['predictions']) {
        Map<String, String> place = {
          "descripcion": lugar['description'],
          "idPlace": lugar['place_id'],
          "name": lugar['structured_formatting']['main_text']
        };
        lugares.add(place);
    }

    return lugares;
  }
  

  //Consulta de un lugar
  Future<Lugar> lugarId(String idPlace) async {

    final resp = await http.get('https://maps.googleapis.com/maps/api/place/details/json?place_id=$idPlace&key=$_apiKey');  
    final decoded = json.decode(resp.body);

    String nombre = decoded['result']['name'];
    double latitud = decoded['result']['geometry']['location']['lat'];
    double longitud = decoded['result']['geometry']['location']['lng'];

    Lugar lugar = Lugar(nombre,idPlace, GeoPoint(latitud,longitud));
    
    print(lugar);

    return lugar;
  }

  Future<Localidad> localidadId(String idPlace) async {

    final resp = await http.get('https://maps.googleapis.com/maps/api/place/details/json?place_id=$idPlace&key=$_apiKey');  
    final decoded = json.decode(resp.body);

    String nombre = decoded['result']['name'];
    double latitud = decoded['result']['geometry']['location']['lat'];
    double longitud = decoded['result']['geometry']['location']['lng'];

    Localidad localidad = Localidad(nombre,idPlace ,GeoPoint(latitud,longitud));
    
    return localidad;
  }
  
  
 


}