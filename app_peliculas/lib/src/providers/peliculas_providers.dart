import 'dart:async';

import 'package:app_peliculas/src/models/actores_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_peliculas/src/models/peliculas_models.dart';

class PeliculasProvider {
  String _apiKey = '810627e7c174ff8dde87829fcec03027';
  String _url = 'api.themoviedb.org';
  String _idioma = 'es-ES';

  int _popularesPaginas = 0;
  bool _cargando = false;

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
    
    if(_cargando) return [];

    _cargando = true; 

    _popularesPaginas++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'  : _apiKey,
      'language' : _idioma,
      'page'     : _popularesPaginas.toString(),
    });

    final respuesta = await _procesadorDeRespuesta(url);

    _peliculasPopulares.addAll(respuesta);

    peliculasPopularesSink(_peliculasPopulares);

    _cargando = false;
    return respuesta;
  }

  Future<List<Actor>> getActoresDePelicula(String peliculaId) async {
    final url = Uri.https(_url, '3/movie/$peliculaId/credits', {
      'api_key'  : _apiKey,
      'language' : _idioma
    });

    final respuesta = await http.get(url);

    final respuestaDecodificada = json.decode(respuesta.body);

    final casting = new Casting.fromJsonList(respuestaDecodificada['cast']);

    return casting.actores;
     
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
      
    final url = Uri.https(_url, '3/search/movie', {
      'api_key'  : _apiKey,
      'language' : _idioma,
      'query'    : query,
    });


    return _procesadorDeRespuesta(url);
  }

} 