import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:project_fly/src/blocs/provider.dart';
import 'package:project_fly/src/model/lugar_model.dart';
import 'package:project_fly/src/search/search_delegate.dart';


class CrearLugar extends StatefulWidget {

  @override
  _CrearLugarState createState() => _CrearLugarState();
}

class _CrearLugarState extends State<CrearLugar> {

  TextEditingController _lugarFieldNombre = new TextEditingController();
  TextEditingController _lugarFieldHora = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

  
  
  final Lugar lugarAux = ModalRoute.of(context).settings.arguments;
    FormulariosBloc formularioBloc = Provider.formularioBloc(context);

    //ejecucion si argumento de la pagina anteriro contiene un lugar
    if(lugarAux != null){
      setState(() {
        formularioBloc.changeLugar(lugarAux);
        _lugarFieldNombre.text = formularioBloc.lugar.nombre;
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: (){
            Navigator.of(context).pushReplacementNamed('dia');
          }
        ),
        title: Text('Añadir Lugar'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _imageHeader(),
                SizedBox(height: 30),
                _fieldNombreLugar(context, formularioBloc),
                SizedBox(height: 30),
                _fieldTime(context, formularioBloc),
                SizedBox(height: 30),
                _botonSubmit(lugarAux)
               
              ],
            )
          ),
        ),
       ),
    );
  }

  //widget creacion campo tiempo
  Widget _fieldTime(BuildContext context, FormulariosBloc formulariosBloc){

     if(formulariosBloc.hora != null){
       setState(() {
       _lugarFieldHora.text = formulariosBloc.hora;
       });
     }
      
    return TextFormField(  
      enableInteractiveSelection: false,
      controller: _lugarFieldHora,
      validator: MultiValidator([
          RequiredValidator(errorText: 'Campo requerido'),
          MaxLengthValidator(50, errorText: 'Máximo de 50 caracteres')
      ]),
      decoration: InputDecoration(
        labelText: 'Hora de visita',
        suffixIcon: Icon(Icons.access_time),
        border: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        TimeOfDay  timePicker = await showTimePicker(
          context: context, 
          initialTime: TimeOfDay(hour: 0,minute: 0), 
        );
        
        if(timePicker != null){
          setState(() {
            _lugarFieldHora.text =  _horaFormat(timePicker.format(context));
            formulariosBloc.changeHora(_lugarFieldHora.text);
          });
        } 
      } 
    );
  }

  //widget campo lugar nombre
 Widget _fieldNombreLugar(BuildContext context, FormulariosBloc formulariosBloc){
   
    return TextFormField(
      controller:  _lugarFieldNombre,
      enableInteractiveSelection: false,
    
      onChanged: (value) => _lugarFieldNombre.text = value,
      validator:  MultiValidator([
        RequiredValidator(errorText: 'Campo requerido'),
        MaxLengthValidator(320, errorText: 'Máximo de 320 caracteres')
      ]),
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.account_balance),
        labelText: 'Nombre',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
        )
      ),
      onTap: () async{
        FocusScope.of(context).requestFocus(new FocusNode());
        showSearch(
          context: context,
          delegate: DataSearch()
        );
        
      },
    );
  }

  // boton submit
  Widget _botonSubmit(Lugar lugar){

    
    Lugar lugarAux = lugar;
    final viajesBloc = Provider.viajesBloc(context);
    final diaBloc = Provider.diaBloc(context);
    final localidadBloc = Provider.localidadBloc(context);
    final lugarBloc = Provider.lugarBloc(context);

    return RaisedButton(
      child: Text('Añadir', style: TextStyle(color: Colors.white),),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 17),
      color: Theme.of(context).primaryColor,
      onPressed: (){
        
        if(!_formKey.currentState.validate()) return;
        _formKey.currentState.save();
        
        //referencia al documnento de la base de datos
        DocumentReference refDia = Firestore.instance.collection('travels')
        .document(viajesBloc.viaje.idViaje).collection('dias')
        .document(diaBloc.dia.idDia);
        DocumentReference refLocalidad = refDia.collection('localidades').document(localidadBloc.localidad.idLocalidad);
        
        DateTime horaLugar = DateTime.parse(_formatFecha(_lugarFieldHora.text, diaBloc.dia.dia));
        lugarAux.hora = horaLugar;
        lugarBloc.crearLugar(refLocalidad, lugarAux);
        diaBloc.cargarDia(refDia);
     
        Navigator.of(context).popUntil(ModalRoute.withName('dia'));
      }
    );
  }

  Widget _imageHeader(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(80),
      child: Container(
        child: Image(
          image: AssetImage('assets/img/lugar.png'),
          height: 300,
        ),
      ),
    );

  }

  //Metodo para formatear una fecha
  String _formatFecha(String hora, DateTime fecha){

    String fechaFormat = '';
    final formatter = new DateFormat('yyyy-MM-dd');
    fechaFormat = formatter.format(fecha);
    fechaFormat = '$fechaFormat $hora:00';

    return fechaFormat;
  }

  //metodo para formatear una hora
  String _horaFormat(String horaString){
    String horaFormat;
    int hora = int.parse(horaString.split(':')[0]);
    int min = int.parse(horaString.split(':')[1]);
    horaFormat = (hora <= 9) ? '0$hora:' : '$hora:';
    horaFormat += (min <= 9) ? '0$min' : min.toString();
    return horaFormat;
  }

}


