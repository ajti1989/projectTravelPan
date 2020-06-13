import 'package:cloud_firestore/cloud_firestore.dart';

class Evento {

  String    _nombre;
  String    _descripcion;
  String    _idEvento;
  GeoPoint  _coordenadas;


  Evento(String nombre, String descripcion){
    
    this.nombre      = nombre;
    this.descripcion = descripcion;
    this.idEvento    = '';
    this.coordenadas = null;
  }

  Evento.provider( Map<String, dynamic> map){
    
    this.nombre      = map['nombre'];
    this.descripcion = map['descripcion'];
    this.idEvento    = '';
    this.coordenadas = null;
  }

  Map<String, dynamic> toJson() => {
    "nombre": this._nombre,
    "descripcion": this._descripcion,
    "coordernadas": this._coordenadas
  };

 //Getters
  String get nombre => this._nombre;
  String get descripcion => this._descripcion;
  String get idEvento => this._idEvento;
  GeoPoint get coordenadas => this._coordenadas;  

  //Setters
  set nombre(String nombre)  => this._nombre = nombre;
  set descripcion(String descripcion) => this._descripcion = descripcion;
  set idEvento(String idEvento) => this._idEvento = idEvento;
  set coordenadas(GeoPoint coordenadas) => this._coordenadas = coordenadas;  


}