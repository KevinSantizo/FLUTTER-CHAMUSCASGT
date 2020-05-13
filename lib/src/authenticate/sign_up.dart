import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:newsport/src/components/theme.dart';


class SignUpPage extends StatefulWidget {

  final Function toogleViews;

  SignUpPage({ this.toogleViews });

  @override
  _SignUpPage createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {

  String textButton = 'Crear mi cuenta';
  final _formKey = GlobalKey<FormState>();

  
  String error    = '';
  String email    = '';
  String password = '';
  String name     = '';
  String username = '';
  String phone    = '';   
  final _color = myTheme.primaryColor;

  bool _obscureText = true;

  void chagedStateIcon(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: Colors.white,
        child: Container(
          // height: 75.0,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('¿Ya tienes cuenta?'),
            FlatButton(
              child: Text('Inicia sesión', style: TextStyle(color: Colors.lightBlue)),
              onPressed: () {
                widget.toogleViews();
              },
            ),
           ],
          ),
        ),    
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    color: myTheme.primaryColor,
                    iconSize: 28.0,
                    icon: Icon(Feather.x), onPressed: () => widget.toogleViews()
                  ),
                ),
                SizedBox(height: 30.0,),
                Text('Regístrate con tu e-mail',textScaleFactor: 1.7,),
                SizedBox(height: 35.0,),
                _loginForm(context),
              ],
            ),
          ),
        ),
      )
    );
  }
  
  Widget _loginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _createNameField(),
          SizedBox( height: 25.0 ),
          _createEmail(),
          SizedBox( height: 25.0 ),
          _createPhone(),
          SizedBox( height: 25.0 ),
          _createPassword(),
          SizedBox( height: 25.0 ),
          _createUserNameField(),
          SizedBox( height: 30.0 ),
          _createButton(context),
        ],
      ),
    );
  }

 Widget _createNameField() {
   return Container(
      child: TextFormField(
        validator: (val) => val.isEmpty ? 'Ingrese un nombre' : null,
        onChanged: (val) {
          setState(() => name = val);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _color),
            borderRadius: BorderRadius.circular(5.0)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _color),
            borderRadius: BorderRadius.circular(5.0)
          ),
          filled: true,
          prefixIcon: Icon( Feather.user, color: Colors.grey,),
          hintText: 'Ingresa tu nombre y apellidos',
          labelText: 'Nombre completo',

          // labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15, color: Colors.grey)),
          // hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15.0, color: Colors.grey))
        ),
      ),
    );
  }

  Widget _createEmail() {
    return Container(
      child: TextFormField(
        validator: (val) => val.isEmpty ? 'Ingrese un correo' : null,
        onChanged: (val) {
          setState(() => email = val);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _color),
            borderRadius: BorderRadius.circular(5.0)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _color),
            borderRadius: BorderRadius.circular(5.0)
          ),
          filled: true,
          prefixIcon: Icon( Feather.mail, color: Colors.grey,),
          hintText: 'Ingrese su email',
          labelText: 'Email',
          // labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15.0, color: Colors.grey)),
          // hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15.0, color: Colors.grey))
        ),
      ),  
    );
  }

   Widget _createPhone() {
    return Container(
      child: TextFormField(
        validator: (val) => val.length < 8 ? 'Ingrese su teléfono de 8 números' : null,
        onChanged: (val) {
          setState(() => phone = val);
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _color),
            borderRadius: BorderRadius.circular(5.0)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _color),
            borderRadius: BorderRadius.circular(5.0)
          ),
          filled: true,
          prefixIcon: Icon( Feather.phone, color: Colors.grey,),
          hintText: 'Ingrese su teléfono',
          labelText: 'Teléfono',
          // labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15.0, color: Colors.grey)),
          // hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15.0, color: Colors.grey))
        ),
      ),  
    );
  }

  Widget _createPassword() {
    return Container(
        child: TextFormField(
          validator: (val) => val.length < 6 ? 'Ingrese una contraseña mayor de 6 caracteres' : null,
          onChanged: (val) {
            setState(() => password = val);
          },
          obscureText: _obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0.0),
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _color),
              borderRadius: BorderRadius.circular(5.0)
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _color),
              borderRadius: BorderRadius.circular(5.0)
            ),
          filled: true,
          labelText: 'Contraseña',
          hintText: 'Ingrese su contraseña',
          // labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15.0, color: Colors.grey)),
          // hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15.0, color: Colors.grey)),
          prefixIcon: _obscureText ? _lockIconClosed() : _lockIconOpen(),
          suffixIcon: IconButton(
            icon: _obscureText ? _iconButtonVisibilityOn() : _iconButtonVisibilityOff(), 
            onPressed:  chagedStateIcon,
          ),
        ),
      ),
    );
  }

  Widget _createUserNameField(){
    return Container(
      child: TextFormField(
        validator: (val) => val.isEmpty ? 'Ingrese un nombre de usuario' : null,
        onChanged: (val) {
          setState(() => username = val);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _color),
            borderRadius: BorderRadius.circular(5.0)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _color),
            borderRadius: BorderRadius.circular(5.0)
          ),
          filled: true,
          prefixIcon: Icon( Feather.at_sign, color: Colors.grey),
          hintText: 'Elija un nombre de usuario',
          labelText: 'Nombre de usuario',
          // labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15.0, color: Colors.grey)),
          // hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15.0, color: Colors.grey))
        ),
      ),
    );
 }

  Widget _createButton(BuildContext context) {
     return Container(
        child: FlatButton.icon(
          onPressed:()  async {
            if(_formKey.currentState.validate()){
              setState(() {
                textButton = 'Registrando...';
              });
            await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((currentUser){
                var data = {
                  "uid"       : currentUser.user.uid,
                  "name"      : name,
                  "username"  : username,
                  "email"     : email,
                  "phone"     : phone,
                };
                return Firestore.instance.collection('users').document(currentUser.user.uid).setData(data);
              }
            );
          }
        },
        // onPressed: snapshot.hasData ? () => _singUp(bloc, context): null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
        ),
        color: _color,
        textColor: Colors.white,
        icon: Icon(Feather.chevron_right),
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 13.0),
          child: Text(textButton, textScaleFactor: 1.1),
        ),
      ),
    );
  }

  Widget _iconButtonVisibilityOn() => Icon(Feather.eye, color: Colors.grey,);
  Widget _iconButtonVisibilityOff() => Icon(Feather.eye_off, color: Colors.grey,);
  Widget _lockIconClosed() => Icon(Feather.lock, color: Colors.grey,);
  Widget _lockIconOpen()   => Icon(Feather.unlock, color: Colors.grey,);

}