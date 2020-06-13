import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_fly/src/blocs/provider.dart';
import 'package:project_fly/src/model/dia_model.dart';
import 'package:project_fly/src/model/viaje_model.dart';


class ViajePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

   
    final diaBLoc = Provider.diaBloc(context);
    final viajeBloc = Provider.viajesBloc(context);

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: viajeBloc.viajeStream,
          builder: (BuildContext context, AsyncSnapshot<Viaje> snapshot){
            if(snapshot.hasData && !viajeBloc.cargando){
              return Text(snapshot.data.nombre);
            }else{
              return Text('Cargando...');
            }
          }
        )
      ),
      body: StreamBuilder (
          stream: viajeBloc.viajeStream,
          builder: (BuildContext context, AsyncSnapshot<Viaje> snapshot) {
            if(snapshot.hasData && !viajeBloc.cargando){
              diaBLoc.changeDias(snapshot.data.dias);
               return ListView.separated( 
                itemCount: diaBLoc.dias.length,
                itemBuilder: (BuildContext context, int index) { 
                  Dia dia = diaBLoc.dias[index];
                  return ListTile(
                    title: Text(dia.nombreDia,style: TextStyle(fontSize: 20)),
                    trailing: IconButton(
                      icon: FaIcon(FontAwesomeIcons.mapMarkedAlt), 
                      onPressed: (){
                        diaBLoc.changeDia(diaBLoc.dias[index]);  
                        Navigator.of(context).pushNamed('mapa');
                      }
                    ),
                    onTap: () {
                      diaBLoc.changeDia(diaBLoc.dias[index]); 
                      Navigator.pushNamed(context, 'dia');
                    } 
                  );
                }, separatorBuilder: (BuildContext context, int index) => Divider(),
              ); 
            }else{
              return Center(
                child: CircularProgressIndicator() ,
              );
            }
            
           
          },
        ),
    );
  }
}