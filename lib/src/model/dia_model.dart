import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_fly/src/model/localidad_model.dart';
import 'package:intl/intl.dart';

class Dia{
  
  String _idDia;
  DateTime _dia;
  List<Localidad> _localidades = new List();

  Dia(this._dia);

  Dia.provider(Map<String, dynamic> map){

    this.idDia = '';
    this.dia = (map['dia'] as Timestamp).toDate(); 
  }


  ///// Getters ////////
  DateTime get dia =>  this._dia;
  String get idDia =>  this._idDia;
  List<Localidad> get localidades => this._localidades;
  
  String get nombreDia{
    final format = new DateFormat.MMMMd('es_ES');
    return format.format(this._dia);
  }

  Map<String, dynamic> toJson() => {
      "dia": this.dia
  };

  
  ////// Setters ////////
  set dia(DateTime dia) => this._dia = dia;
  set idDia(String idDia) => this._idDia = idDia;
  set localidades(List<Localidad> localidades) => this._localidades = localidades;

  //// Methods //////
  




  




  
  
}

  



    
   
   
   
