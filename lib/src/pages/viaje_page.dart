import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_fly/src/blocs/provider.dart';
import 'package:project_fly/src/model/dia_model.dart';
import 'package:project_fly/src/model/viaje_model.dart';
import 'package:project_fly/src/utils/utils.dart';


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
          //stream del viaje cargado
          stream: viajeBloc.viajeStream,
          builder: (BuildContext context, AsyncSnapshot<Viaje> snapshot) {
            //comprobación si tiene datos y viaje ha sido cargado
            if(snapshot.hasData && !viajeBloc.cargando){
              //actulizamos el stream dias
              diaBLoc.changeDias(snapshot.data.dias);
               return StreamBuilder<List<Dia>>(
                 stream: diaBLoc.diasStream,
                 builder: (context, snapshot) {
                   return ListView.separated( 
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) { 
                      Dia dia = snapshot.data[index];
                      return ListTile(
                        title: Text(dia.nombreDia,style: TextStyle(fontSize: 20)),
                        trailing: IconButton(
                          icon: FaIcon(FontAwesomeIcons.mapMarkedAlt), 
                          onPressed: (){
                            //navega al mapa 
                            diaBLoc.changeDia(diaBLoc.dias[index]);  
                            if(diaBLoc.dia.localidades.length > 0){
                              Navigator.of(context).pushNamed('mapa');
                            }else{
                              mostrarAlerta(context,'Añada una localidad');
                            }
                          }
                        ),
                        //navega al itinerario del dia
                        onTap: () {
                          diaBLoc.changeDia(diaBLoc.dias[index]); 
                          Navigator.pushNamed(context, 'dia');
                        } 
                      );
                    }, separatorBuilder: (BuildContext context, int index) => Divider(),
              );
                 }
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