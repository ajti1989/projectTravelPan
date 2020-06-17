import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_fly/src/blocs/provider.dart';
import 'package:project_fly/src/model/viaje_model.dart';



class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //cargar viajes
    final viajesBloc = Provider.viajesBloc(context);
    viajesBloc.cargarviajes();

    return WillPopScope(
      onWillPop: () async => false,
        child: Scaffold(
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
              //hasta que no vengan datos en el stream
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            
          },
        ),  

        //boton crear nuevo viaje
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.pushReplacementNamed(context, 'nuevoViaje');
          }
        ),
      ),
    );
  }

//contenedor de viaje
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
          //al pulsar carga en stream un viaje
          viajesBloc.cargarViajeId(viaje.idViaje.trim());
          Navigator.pushNamed(context, 'viaje');
        } 
      ),
    );
  }

  //recarga página al hacer scroll 
   Future<Null> _refreshPage(BuildContext context, viajesBloc) async {
    final duration = new Duration( seconds: 2 );

    new Timer(duration, (){
      viajesBloc.cargarviajes();
    });
  }

  //contenido del dismissible
  Widget _dismisContainer(){
    return Container(
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      color: Colors.grey[100],
      child: Icon(Icons.delete),
    );
  }


 
}