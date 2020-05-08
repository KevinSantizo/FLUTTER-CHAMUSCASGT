import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:football/src/pages/company.dart';


class DataSearch extends SearchDelegate<String> {

  String seleccion = '';
  final fieldProvider = Firestore.instance.collection('company');
  
  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon( Icons.clear ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close( context, null );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if ( query.isEmpty ) {
      return Container();
    }
    final sugestionsList = fieldProvider.where('name', isGreaterThan: query.toUpperCase());

    return StreamBuilder<QuerySnapshot>(
      stream: sugestionsList.snapshots(),
      builder: (BuildContext context, snapshot) {
          if( snapshot.hasData ) {
            final fields = snapshot.data.documents;
            return ListView.builder(
              itemCount: fields.length,
              itemBuilder: (BuildContext context, index) => ListTile(
              leading: FadeInImage(
                image: NetworkImage( fields[index]['logo_photo'] ),
                placeholder: AssetImage('assets/no-image.jpg'),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text(fields[index]['name']),
              subtitle: Text( '${fields[index]['address']}, ${fields[index]['city']}'),
              onTap: (){
                close( context, null);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => CompanyPage(
                //     ds: fields[index],
                //   ))
                // );
              },
            )
          );
        } else {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      },
    );
  }
  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Son las sugerencias que aparecen cuando la persona escribe

  //   final listaSugerida = ( query.isEmpty ) 
  //                           ? peliculasRecientes
  //                           : peliculas.where( 
  //                             (p)=> p.toLowerCase().startsWith(query.toLowerCase()) 
  //                           ).toList();


  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaSugerida[i]),
  //         onTap: (){
  //           seleccion = listaSugerida[i];
  //           showResults( context );
  //         },
  //       );
  //     },
  //   );
  // }

}

