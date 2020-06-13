
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_fly/src/model/evento_model.dart';
import 'package:project_fly/src/model/lugar_model.dart';

class Localidad {
  
  String _nombre;
  String _idLocalidad;
  String _idPlace;
  GeoPoint _coordenadas;
  List<Lugar> _lugares  = new List();
  List<Evento> _eventos = new List();
  
  Localidad(String nombre,String idPlace ,GeoPoint coordenadas,){
    this._nombre      = nombre;
    this._idPlace = idPlace;
    this._coordenadas = coordenadas;
  }

  Localidad.provider( Map<String, dynamic> map){
    this._nombre      = map['nombre'];
    this._idPlace     = map['idPlace'];
    this._idLocalidad = '';
    this._coordenadas = map['location'];
  }

  // Getters
  String get nombre => this._nombre;
  String get idLocalidad => this._idLocalidad;
  String get idPlace => this._idPlace;
  GeoPoint get coordenadas => this._coordenadas;
  List<Lugar> get lugares => this._lugares;
  List<Evento> get eventos => this._eventos;

  // Setters
  set nombre(String nombre) => this._nombre = nombre;
  set idLocalidad(String idLocalidad) => this._idLocalidad = idLocalidad;
  set idPlace(String idPlace) => this._idPlace = idPlace;
  set coordenadas(GeoPoint coordenadas) => this._coordenadas = coordenadas;
  set lugares(List<Lugar> lugares) => this._lugares; 
  set eventos(List<Evento> eventos) => this._eventos; 
  
  List<dynamic> get eventosLugares{
   
    List<dynamic> eventosLugares = new List();
    
    lugares.forEach((element) {
      eventosLugares.add(element);
    });

    eventos.forEach((element) {
      eventosLugares.add(element);
    });

    return eventosLugares;
  }   

  Map<String, dynamic> toJson() => {
    "nombre": this._nombre,
    "idPlace": this._idPlace,
    'location': this._coordenadas
  };


}