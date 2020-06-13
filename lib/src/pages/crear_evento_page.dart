import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_fly/src/blocs/provider.dart';
import 'package:project_fly/src/model/evento_model.dart';

class CrearEvento extends StatefulWidget {

  @override
  _CrearEventoState createState() => _CrearEventoState();
}

class _CrearEventoState extends State<CrearEvento> {

  TextEditingController _eventoFieldNombre = new TextEditingController();
  TextEditingController _eventoFieldDescripcion = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  

  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir evento'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _imageHeader(),
                _fieldNameEvent(),
                SizedBox(height: 30),
                _fieldDescriptionEvent(),
                SizedBox(height: 30),
                _botonSubmit(context)
              ],
            )
          ),
        ),
       ),
    );
  }


   // campo nombre evento
  Widget _fieldNameEvent(){
    return TextFormField(
      controller: _eventoFieldNombre,
      validator:  MultiValidator([
        RequiredValidator(errorText: 'Campo requerido'),
         MaxLengthValidator(100, errorText: 'Máximo de 100 caracteres')
      ]), 
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.event),
        labelText: 'Nombre',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
        )
      ),
    );
  }


  //campo descripcion evento
  Widget _fieldDescriptionEvent(){

      return TextFormField(
        controller: _eventoFieldDescripcion,
        maxLines: null,
        maxLength: 300,
        validator:  MultiValidator([
          RequiredValidator(errorText: 'Campo requerido'),
          MaxLengthValidator(300, errorText: 'Máximo de 100 caracteres')
      ]), 
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.event_note),
          labelText: 'Descripción',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)
          )
        ),
      );
    
  }

  Widget _botonSubmit(BuildContext context){

    ViajesBloc viajesBloc = Provider.viajesBloc(context);
    DiaBloc diaBloc = Provider.diaBloc(context);
    LocalidadBloc localidadBloc = Provider.localidadBloc(context);
    EventoBloc eventoBloc = Provider.eventoBloc(context);


    return RaisedButton(
      child: Text('Añadir', style: TextStyle(color: Colors.white),),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 17),
      color: Theme.of(context).primaryColor,
      onPressed: () {

        if(!_formKey.currentState.validate()) return;
        _formKey.currentState.save();
        
        Evento evento = Evento(_eventoFieldNombre.text, _eventoFieldDescripcion.text);

        DocumentReference refDia = Firestore.instance.collection('travels')
        .document(viajesBloc.viaje.idViaje).collection('dias')
        .document(diaBloc.dia.idDia);
        localidadBloc.localidad.idLocalidad;
        DocumentReference refLocalidad = refDia.collection('localidades').document(localidadBloc.localidad.idLocalidad);

        eventoBloc.crearEvento(refLocalidad, evento);
        diaBloc.cargarDia(refDia);
     
        Navigator.of(context).pop();
      }
    );
  }

   Widget _imageHeader(){
     
    return ClipRRect(
      borderRadius: BorderRadius.circular(80),
      child: Container(
        child: Image(
          image: AssetImage('assets/img/travel.png'),
          height: 300,
        ),
      ),
    );

  }


}


