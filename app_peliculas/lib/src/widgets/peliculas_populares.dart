import 'package:app_peliculas/src/models/peliculas_models.dart';
import 'package:flutter/material.dart';


class PeliculasPopulares extends StatelessWidget {
  
  final List<Pelicula> peliculas;

  PeliculasPopulares({@required this.peliculas});
  
  @override
  Widget build(BuildContext context) {
    
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView(
        children: _tarjetas(context),
        controller: PageController(
          initialPage: 1,
          viewportFraction: 0.3
        ),
        pageSnapping: false,
      ),
    );
  }

  List<Widget> _tarjetas(BuildContext context) {

    return peliculas.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                image: NetworkImage(pelicula.getImagenPortada()),
                placeholder: AssetImage('assets/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption),
          ],
        ),
      );
    }).toList();
  }
}