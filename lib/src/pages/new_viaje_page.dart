import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_fly/src/blocs/new_viaje_bloc.dart';
import 'package:project_fly/src/blocs/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_fly/src/model/viaje_model.dart';

class NewViajePage extends StatefulWidget {

  @override
  _NewViajePageState createState() => _NewViajePageState();
}

class _NewViajePageState extends State<NewViajePage> {

  //controladores de campo formulario
  final TextEditingController _inputFieldDateControllerStart = new TextEditingController();
  final TextEditingController _inputFieldDateControllerEnd = new TextEditingController();

  //key del formualrio
  final _formKey = GlobalKey<FormState>();

  bool submit = false;
  bool afterDate = false;
  String _nombre = '';

  @override
  Widget build(BuildContext context) {

    final _viajesBloc = Provider.viajesBloc(context);
    final bloc = Provider.dates(context);
  
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Viaje'),
      ),
      body:SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _imageHeader(),
                SizedBox(height: 30,),
                _fieldTravelName(),
                SizedBox(height: 15,),
                 _fieldDateStart(context, bloc),
                SizedBox(height: 15,),
                _fieldDateEnd(context, bloc),
                SizedBox(height: 50,),
                _botonSubmit( bloc, _viajesBloc ),
              ],
            ),
          ),
        ),
      ),
      
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

  //campo formulario nombre
   Widget _fieldTravelName(){

    return TextFormField(
      validator: RequiredValidator(errorText: 'Campo requerido'),
      onChanged: (value){
        setState(() {
          _nombre = value;
        }); 
      },
      initialValue: _nombre,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.beach_access),
        labelText: 'Nombre del viaje',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
        )
      ),
    );
  }

  //campo formulario fecha inicio
  Widget _fieldDateStart(BuildContext context, NewViajeBloc bloc){

        return TextFormField(  
          validator: RequiredValidator(errorText: 'Campo requerido'),
          enableInteractiveSelection: false,
          controller: _inputFieldDateControllerStart,
          decoration: InputDecoration(
            labelText: 'Fecha de inicio',
            suffixIcon: Icon(Icons.flight_takeoff),
            border: OutlineInputBorder( 
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            DateTime  datePicker = await showDatePicker(
              context: context, 
              initialDate: DateTime.now(), 
              firstDate: DateTime.now(), 
              lastDate: DateTime.now().add(Duration(days: 3000)),
            );
            if(datePicker != null){

              final formatter = new DateFormat('dd-MM-yyyy');
              
              bloc.changeDateIni(datePicker);
              _inputFieldDateControllerStart.text = formatter.format(datePicker);
            }

          },
        );
  }


  //campo formulario fecha fin
  Widget _fieldDateEnd(BuildContext context, NewViajeBloc bloc){
     
        return TextFormField(  
          validator: MultiValidator([
            RequiredValidator(errorText: 'Campo requerido'),
          ]), 
          enableInteractiveSelection: false,
          controller: _inputFieldDateControllerEnd,
          decoration: InputDecoration(
            labelText: 'Fecha de fin',
            suffixIcon: Icon(Icons.flight_land),
            errorText: (afterDate) ? 'fecha fin no puede ser inferior a fecha de inicio' : null,
            border: OutlineInputBorder( 
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onTap: (bloc.dateIni != null) ?  () async {

            FocusScope.of(context).requestFocus(new FocusNode());
            DateTime  datePicker = await showDatePicker(
              context: context, 
              initialDate: (bloc.dateIni != null) ? bloc.dateIni.add(Duration(days: 1)) : null, 
              firstDate: (bloc.dateIni != null) ? bloc.dateIni.add(Duration(days: 1)) : null,  
              lastDate: DateTime.now().add(Duration(days: 3000)),

            );

            if(datePicker != null){
              final formatter = new DateFormat('dd-MM-yyyy');
              bloc.changeDateEnd(datePicker);
              _inputFieldDateControllerEnd.text = formatter.format(datePicker);
            } 
          } : () {FocusScope.of(context).requestFocus(new FocusNode());},
        );
  }

  //boton enviar formulario
  Widget _botonSubmit(NewViajeBloc bloc, ViajesBloc viajesBloc){

    return RaisedButton(

      child: Text('Crear viaje'),
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      color: Colors.blueAccent,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      onPressed: (!submit) ? () {

        //comprueba errores formulario
        if(!_formKey.currentState.validate()) return;

        //comrpueba que la fecha de inicio no sea superior a la de fin
        if(bloc.dateIni.isAfter(bloc.dateEnd)){
          setState(() {
            afterDate = true;            
          });
          return;
        }

        Viaje viaje = new Viaje(_nombre, bloc.dateIni, bloc.dateEnd);

        //Crea y carga el viaje
        viajesBloc.crearViaje(viaje);
        viajesBloc.cargarviajes();
        _formKey.currentState.save();

        setState(() {submit = true;});

        Navigator.of(context).pushReplacementNamed('home');

      } : null
    );
  }

  
}


