import 'package:flutter/material.dart';

import 'package:project_fly/src/blocs/evento_bloc.dart';
export 'package:project_fly/src/blocs/evento_bloc.dart';

import 'package:project_fly/src/blocs/dia_bloc.dart';
export 'package:project_fly/src/blocs/dia_bloc.dart';

import 'package:project_fly/src/blocs/formularios_bloc.dart';
export 'package:project_fly/src/blocs/formularios_bloc.dart';

import 'package:project_fly/src/blocs/localidad_bloc.dart';
export 'package:project_fly/src/blocs/localidad_bloc.dart';

import 'package:project_fly/src/blocs/lugar_bloc.dart';
export 'package:project_fly/src/blocs/lugar_bloc.dart';

import 'package:project_fly/src/blocs/new_viaje_bloc.dart';
export 'package:project_fly/src/blocs/new_viaje_bloc.dart';

import 'package:project_fly/src/blocs/viajes_bloc.dart';
export 'package:project_fly/src/blocs/viajes_bloc.dart';



//un widget que comparte una variable con todos los hijos widgets sin perder su instancia

class Provider extends InheritedWidget{

  final newViaje = NewViajeBloc();
  final viajeBloc = ViajesBloc();
  final formulariosBloc = FormulariosBloc();
  final _diaBloc = DiaBloc();
  final _eventoBloc = EventoBloc();
  final _localidadBloc = LocalidadBloc();
  final _lugarBloc = LugarBloc();

  Provider({Key key, Widget child})
    : super(key:key, child: child);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true; 

  
  static NewViajeBloc dates ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>().newViaje;
  }
  
  static ViajesBloc viajesBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>().viajeBloc;
  }
  
  static FormulariosBloc formularioBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>().formulariosBloc;
  }
  
  static DiaBloc diaBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._diaBloc;
  }

  static EventoBloc eventoBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._eventoBloc;
  }

  static LocalidadBloc localidadBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._localidadBloc;
  }
    
  static LugarBloc lugarBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._lugarBloc;
  }
    
}