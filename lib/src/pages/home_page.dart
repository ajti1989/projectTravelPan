import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_fly/src/blocs/provider.dart';
import 'package:project_fly/src/model/viaje_model.dart';
import 'package:project_fly/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:project_fly/src/providers/usuario_provider.dart';



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
        drawer: _drawer(context),
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
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black12)
          ),
        ),
        child: ListTile(
          title: Text(viaje.nombre, style: TextStyle(fontSize: 20 ),),
          trailing: Text(viaje.diaInicio),
          
          onTap: () {
            //al pulsar carga en stream un viaje
            viajesBloc.cargarViajeId(viaje.idViaje.trim());
            Navigator.pushNamed(context, 'viaje');
          } 
        ),
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

  Widget _drawer(BuildContext context){
      final _prefs = new PreferenciasUsuario();
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            //Cabecera Drawer
            DrawerHeader(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.blue
              ),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(height: 20,),
                  Text(_prefs.email, style: TextStyle(color: Colors.white),)
                ],
              ) 
            ),
            //Añadir viaje
            ListTile(
              trailing: Icon(Icons.add_location),
              title: Text('Añadir viaje', style: TextStyle(fontSize: 18),),
            ),
            Divider(),
            //Cerrar sesion
            ListTile(
              title: Text('Cerrar sesión', style: TextStyle(fontSize: 18)),
              trailing: Icon(Icons.exit_to_app),
              onTap: (){

                final usuarioProvider = UsuarioProvider();
                if(usuarioProvider.getCurrentUser() != null){
                  usuarioProvider.singnOut();
                }else{
                  usuarioProvider.logOut();
                }
                Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                
              },
            )
          ],
        ),
      ),
    );
  }
 
}