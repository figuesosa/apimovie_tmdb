import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MovieInfoScreen(),
    );
  }
}

class MovieInfoScreen extends StatefulWidget {
  @override
  _MovieInfoScreenState createState() => _MovieInfoScreenState();
}

class _MovieInfoScreenState extends State<MovieInfoScreen> {
  final apiKey = '9e109e6e16261ccd07cd3591a9c7f4fb';
  final movieTitle =
      'Lost in Translation'; // Título de la película que deseas buscar

  String title = '';
  String overview = '';
  String imageUrl = ''; // Variable para la URL de la imagen

  @override
  void initState() {
    super.initState();
    fetchMovieData(apiKey, movieTitle);
  }

  void fetchMovieData(String apiKey, String movieTitle) async {
    final apiUrl =
        'https://api.themoviedb.org/3/search/movie?query=$movieTitle';

    final response = await http.get(Uri.parse('$apiUrl&api_key=$apiKey'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['results'].isNotEmpty) {
        final movie = jsonData['results']
            [0]; // Tomamos la primera película de la lista de resultados
        setState(() {
          title = movie['title'];
          overview = movie['overview'];
          imageUrl =
              'https://image.tmdb.org/t/p/w500${movie['poster_path']}'; // URL de la imagen
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información de la Película'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (imageUrl.isNotEmpty) // Verifica si hay una URL de imagen
              Image.network(imageUrl, width: 200.0), // Muestra la imagen

            Text(
              'Título: $title',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Resumen: $overview',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
