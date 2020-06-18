import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/src/blocs/provider.dart';
import 'package:project_fly/src/model/dia_model.dart';
import 'package:project_fly/src/model/localidad_model.dart';
import 'package:project_fly/src/model/lugar_model.dart';
import 'package:project_fly/src/search/search_Localidad.dart';


class DiaPage extends StatefulWidget {

  @override
  _DiaPageState createState() => _DiaPageState();
}

class _DiaPageState extends State<DiaPage> {

  @override
  Widget build(BuildContext context) {

    // final Dia dia = ModalRoute.of(context).settings.arguments;
    
    final diaBloc = Provider.diaBloc(context);
    final localidadBloc = Provider.localidadBloc(context);
    final eventosBloc = Provider.eventoBloc(context);
    final lugarBloc = Provider.lugarBloc(context);
    final viajeBloc = Provider.viajesBloc(context);
    
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Dia>(
          stream: diaBloc.diaStream,
          builder: (context, snapshot) {
            return (snapshot.hasData) ? Text(diaBloc.dia.nombreDia) : Text('Dia');
          }
        ),
      ),
      body: StreamBuilder<Dia>(
        stream: diaBloc.diaStream,
        builder: (context, snapshot) {

          if(snapshot.hasData){
            localidadBloc.changeLocalidades(snapshot.data.localidades);
            return RefreshIndicator(
              onRefresh: () => _refreshPage(context),
              child: ListView.builder(
              itemCount: localidadBloc.localidades.length,
              itemBuilder: (BuildContext context, int index) {
                localidadBloc.changeLocalidad(localidadBloc.localidades[index]);
                return Column(
                  children: <Widget>[
                    _containerLocalidad(context, localidadBloc, eventosBloc, viajeBloc, diaBloc),
                    _listaEventosLugares(localidadBloc.localidad, lugarBloc, eventosBloc, viajeBloc, diaBloc )
                   
                  ],
                );
              },
            ),
            );
          }else{
            return CircularProgressIndicator();
          }
         
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showSearch(context: context, delegate: SearchLocalidad()),
      ),
      
    );
  }

  //widget container localidad
  Widget _containerLocalidad( BuildContext context, LocalidadBloc localidadBloc, EventoBloc eventosBloc, ViajesBloc viajesBloc, DiaBloc diaBloc){
    Localidad localidad = localidadBloc.localidad;
    
    return Dismissible(
      key: UniqueKey(),
      background: _dismisContainer(),
      onDismissed: (d) async {
        localidadBloc.borrarLocalidad(
          Firestore.instance.collection('travels')
          .document(viajesBloc.viaje.idViaje).collection('dias')
          .document(diaBloc.dia.idDia).collection('localidades')
          .document(localidad.idLocalidad)
        );
        viajesBloc.cargarViajeId(viajesBloc.viaje.idViaje);
        diaBloc.cargarDia(Firestore.instance.collection('travels')
        .document(viajesBloc.viaje.idViaje).collection('dias')
        .document(diaBloc.dia.idDia));
      },
      child: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment(-1.0,0.0),
        color: Colors.grey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(localidad.nombre, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.add_circle_outline), 
              onPressed: () {
                localidadBloc.changeLocalidad(localidad);
                // eventosBloc.changeEventos(localidad.eventos);
                _menuOption(context);
              }
            )
          ],
        ),
      ),
    );
  }

  //Widget para mostra la lista de lugares y eventos
  Widget _listaEventosLugares(Localidad localidad, LugarBloc lugarBloc, EventoBloc eventoBloc, ViajesBloc viajesBloc, DiaBloc diaBloc){
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: localidad.eventosLugares.length,
      itemBuilder: (BuildContext context, int index) {
        dynamic eventoLugar = localidad.eventosLugares[index];
        return Dismissible(
          background: _dismisContainer(),
          direction: DismissDirection.startToEnd,
          onDismissed: (eventoLugar is Lugar)
            ? (d) {  lugarBloc.borrarLugar(
              Firestore.instance.collection('travels')
                .document(viajesBloc.viaje.idViaje).collection('dias')
                .document(diaBloc.dia.idDia).collection('localidades')
                .document(localidad.idLocalidad).collection('lugares')
                .document(localidad.eventosLugares[index].idLugar));
              viajesBloc.cargarViajeId(viajesBloc.viaje.idViaje);
            }
            : (d) { eventoBloc.borrarEvento(Firestore.instance.collection('travels')
                .document(viajesBloc.viaje.idViaje).collection('dias')
                .document(diaBloc.dia.idDia).collection('localidades')
                .document(localidad.idLocalidad).collection('eventos')
                .document(localidad.eventosLugares[index].idEvento));
              viajesBloc.cargarViajeId(viajesBloc.viaje.idViaje);
            },
          key: UniqueKey(),
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 30),
            title: (eventoLugar is Lugar)
              ? Text(eventoLugar.nombre)
              : Text(eventoLugar.nombre
            ),
            subtitle: (eventoLugar is Lugar)
            ? (eventoLugar.hora != null) ? Text(_horaFormat(eventoLugar.hora)) : Text('')
            : Text(''),
           
          ),
        );
      }, 
    );
  }

 //menu modal
  _menuOption(BuildContext context){
  
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          content: Container(
            height: 130,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('Añadir Lugar'),
                  onTap: () => Navigator.pushReplacementNamed(context, 'crearLugar'),
                ),
                Divider(),
                ListTile(
                  title: Text('Añadir Evento'),
                  onTap: (){
                    Navigator.pushReplacementNamed(context, 'crearEvento');
                  },
                ),
                
              ],
            ),
          ),
        );
      },
    );
  }

  //acción para refrescar la página
  Future<Null> _refreshPage(BuildContext context) async {
    final duration = new Duration( seconds: 2 );
    new Timer(duration, (){
      final viajesBloc = Provider.viajesBloc(context);
      viajesBloc.cargarviajes();
    });
  }


  String _horaFormat(DateTime fecha){
    String format = '';
    int hora = fecha.hour;
    int min = fecha.minute;
    
    format = (hora <= 9) ? '0$hora:' : '$hora:';
    format += (min <= 9) ? '0$min' : '$min';
    return format;
  }

   Widget _dismisContainer(){
    return Container(
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      color: Colors.grey[100],
      child: Icon(Icons.delete),
    );
  }
}           