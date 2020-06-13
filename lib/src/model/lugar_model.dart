import 'package:cloud_firestore/cloud_firestore.dart';

class Lugar {

  String    _nombre;
  String    _idPlace;
  String    _idLugar;
  GeoPoint  _coordenadas;
  DateTime  _hora; 


  Lugar(String nombre, String idPlace, GeoPoint coordendas){
  
    this._nombre      = nombre;
    this._idPlace     = idPlace;
    this._idLugar     = '';
    this._coordenadas = coordendas;
  }

  Lugar.provider( Map<String, dynamic> map){
    
    this._nombre      = map['nombre'];
    this._idPlace     = map['idPlace'];
    this._idLugar     = '';
    this._coordenadas = map['coordenadas'];
    this._hora        = (map['hora'] != null) ? (map['hora'] as Timestamp).toDate() : DateTime.parse('00000000');

  }

  Map<String, dynamic>toJson() =>{
    "idPlace": this._idPlace,
    "nombre": this._nombre,
    "coordenadas": this._coordenadas, 
    "hora": this._hora
  };

 //Getters
  String get nombre  =>   this._nombre;
  String get idPlace => this._idPlace;
  String get idLugar => this._idLugar;
  GeoPoint get coordenadas => this._coordenadas;  
  DateTime get hora => this._hora;  

  //Setters
  set nombre(String nombre)  => this._nombre = nombre;
  set idPlace(String idPlace) => this._idPlace = idPlace;
  set idLugar(String idLugar) => this._idLugar = idLugar;
  set coordenadas(GeoPoint coordenadas) => this._coordenadas = coordenadas;  
  set hora(DateTime hora) => this._hora = hora;  
}