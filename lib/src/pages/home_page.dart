import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_fly/src/blocs/provider.dart';
import 'package:project_fly/src/model/viaje_model.dart';
import 'package:project_fly/src/providers/go_place_provider.dart';



class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final viajesBloc = Provider.viajesBloc(context);
    viajesBloc.cargarviajes();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Mis viajes'),

      ),

      body: StreamBuilder(
        stream: viajesBloc.viajesStream,
        builder: (BuildContext context, AsyncSnapshot<List<Viaje>> snapshot) {
          if(snapshot.hasData){
            final viajes = snapshot.data;
            return RefreshIndicator(
              onRefresh: () => _refreshPage(context, viajesBloc),
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: viajes.length,
                itemBuilder: (BuildContext context, int index) { 
                  return _itemViaje(viajesBloc, viajes[index], context);
                }, 
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          
        },
      ),  
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushReplacementNamed(context, 'nuevoViaje');
        }
      ),
    );
  }

  Widget _itemViaje( ViajesBloc viajesBloc, Viaje viaje , BuildContext context ){
    return Dismissible(
      background: _dismisContainer(),
      key: UniqueKey(),
      onDismissed: (d) => viajesBloc.borrarViaje(viaje.idViaje),
      direction: DismissDirection.startToEnd,
      child: ListTile(
        title: Text(viaje.nombre, style: TextStyle(fontSize: 20 ),),
        trailing: Icon(Icons.more_horiz),
        onTap: () {
          
          viajesBloc.cargarViajeId(viaje.idViaje.trim());
          Navigator.pushNamed(context, 'viaje');
        } 
      ),
    );
  }


   Future<Null> _refreshPage(BuildContext context, viajesBloc) async {
    final duration = new Duration( seconds: 2 );

    new Timer(duration, (){
      viajesBloc.cargarviajes();
    });
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