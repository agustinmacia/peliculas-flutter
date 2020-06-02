import 'package:app_peliculas/src/models/peliculas_models.dart';
import 'package:app_peliculas/src/providers/peliculas_providers.dart';
import 'package:flutter/material.dart';

class BuscadorPelicula extends SearchDelegate{
  
  final peliculasProvider = new PeliculasProvider();

  String seleccion = '';
  
  @override
  List<Widget> buildActions(BuildContext context) {
      // Acciones de nuestro AppBar Icono para cerrar la busqueda por eje
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
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
        onPressed: () {
          close(context, null);
        },
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // Crea los resultados de la busqueda que vamos a mostrar
      return Center(
        child: Container(
          ///child: buscadorPelicula(),
        ),
      );
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // Sugerencias de busqueda
      if (query.isEmpty) {
        return Container();
      } else {

        return FutureBuilder(
          future: peliculasProvider.buscarPelicula(query),
          builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
            
            if(snapshot.hasData) {
              
              final peliculas = snapshot.data;
              
              return ListView(
                children: peliculas.map((pelicula) {
                  return ListTile(
                    leading: FadeInImage(
                      image: NetworkImage(pelicula.getImagenPortada()),
                      placeholder: AssetImage('assets/no-image.jpg'),
                      fit: BoxFit.contain,
                    ),
                    title: Text(pelicula.title),
                    onTap: () {
                      close(context, null);
                      pelicula.uniqueId = '';
                      Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                    },
                  );
                }
              ).toList());
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      }
    }
}