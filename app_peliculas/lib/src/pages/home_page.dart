import 'dart:ffi';

import 'package:app_peliculas/src/providers/peliculas_providers.dart';
import 'package:app_peliculas/src/search/search_delegate.dart';
import 'package:app_peliculas/src/widgets/card_swiper_widget.dart';
import 'package:app_peliculas/src/widgets/peliculas_populares.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  
  final PeliculasProvider pelProv = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    pelProv.getPeliculasPopulares();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Peliculas en Cartelera'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                context: context,
                delegate: BuscadorPelicula());
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _peliculasPopulares(context),
          ],
        ),
      ));
  }

  Widget _swiperTarjetas() {

    
    return FutureBuilder(
      future: pelProv.getPeliculasEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        
        if(snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
            height: 400,
            child: Center(
              child: CircularProgressIndicator()
              ));
        }
        
        
      },
    );
  }

  Widget _peliculasPopulares(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text('Populares', style: Theme.of(context).textTheme.subtitle1),
            padding: EdgeInsets.only(left: 20.0), 
            ),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: pelProv.peliculasPopularesStream,
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {

              if(snapshot.hasData) {
                return PeliculasPopulares(peliculas: snapshot.data, siguientePagina: pelProv.getPeliculasPopulares);
              } else {
                return Center(child:CircularProgressIndicator());
              }
            }
            ),
        ],
      ),
    );
  }
}