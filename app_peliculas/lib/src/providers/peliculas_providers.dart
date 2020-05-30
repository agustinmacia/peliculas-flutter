import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_peliculas/src/models/peliculas_models.dart';

class PeliculasProvider {
  String _apiKey = '810627e7c174ff8dde87829fcec03027';
  String _url = 'api.themoviedb.org';
  String _idioma = 'es-ES';

  int _popularesPaginas = 0;

  List<Pelicula> _peliculasPopulares = new List();

  final _peliculasPopularesStreamController = StreamController<List<Pelicula>>.broadcast();

  
  Function(List<Pelicula>) get peliculasPopularesSink => _peliculasPopularesStreamController.sink.add; 

  Stream<List<Pelicula>> get peliculasPopularesStream => _peliculasPopularesStreamController.stream;
  
  
  void disposeStream() {
    _peliculasPopularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesadorDeRespuesta(Uri url) async{

    final respuesta = await http.get(url);

    final respuestaDecodificada = json.decode(respuesta.body);

    final peliculas = new Peliculas.fromJsonList(respuestaDecodificada['results']);

    return peliculas.itemsPeliculas;
  }

  Future<List<Pelicula>> getPeliculasEnCines() async{

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'  : _apiKey,
      'language' : _idioma
    });

    return await _procesadorDeRespuesta(url);
  }

  Future<List<Pelicula>> getPeliculasPopulares() async {
    
    _popularesPaginas++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'  : _apiKey,
      'language' : _idioma,
      'page'     : _popularesPaginas.toString(),
    });

    final respuesta = await _procesadorDeRespuesta(url);

    _peliculasPopulares.addAll(respuesta);

    peliculasPopularesSink(_peliculasPopulares);

    return respuesta;
  }

} 