import 'package:app_peliculas/src/models/peliculas_models.dart';

class PeliculasProvider {
  String _apiKey = '810627e7c174ff8dde87829fcec03027';
  String _url = 'api.themoviedb.orb';
  String _idioma = 'es-ES';


  Future<List<Pelicula>> getPeliculasEnCines() async{

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'  : _apiKey,
      'language' : _idioma
    });

    
    

  }


} 