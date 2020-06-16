import 'dart:convert';
import 'package:project_fly/src/model/dia_model.dart';

String viajeToJson(Viaje data) => json.encode(data.toJson());


class Viaje{

  String nombre;
  DateTime fechaIni;
  DateTime fechaFin;
  String idViaje;
  List<Dia> dias;

  Viaje(nombre, fechaIni, fechaFin){
    
    this.idViaje = '';
    this.nombre = nombre;
    this.fechaIni = fechaIni;
    this.fechaFin = fechaFin;
    this.dias = _initializeDays();
  }

  Viaje.provider(Map<String, dynamic> map){

    this.idViaje = '';
    this.nombre = map['nombre']; 
    this.fechaIni = DateTime.now();
    this.fechaFin = DateTime.now();
    // this.fechaIni = (map['fechaIni'] as Timestamp).toDate();
    // this.fechaFin = (map['fechaFin'] as Timestamp).toDate();
    this.dias = new List();
  }



  Map<String, dynamic> toJson() => {
      // "id"         : id,
      "nombre"    : this.nombre,
      "fechaIni"  : this.fechaIni,
      "fechaFin"  : this.fechaFin,
  };



  //Inicializar lista de dias con números de dias del viaje

  List<Dia> _initializeDays(){

    List<Dia> dias = new List();

    Duration duracion = this.fechaIni.difference(this.fechaFin);
    int numDias = duracion.inDays.abs() + 1; 
    
    for (var i = 0; i < numDias; i++) {
      DateTime diaInicial = this.fechaIni;
      dias.add(new Dia(diaInicial.add(Duration(days: i))));
    }

    return dias; 
  }

}

