import 'dart:convert';
import 'package:api_fetch/model/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TopRatedMovies extends StatefulWidget {
  const TopRatedMovies({Key? key}) : super(key: key);

  @override
  State<TopRatedMovies> createState() => _TopRatedMoviesState();
}

class _TopRatedMoviesState extends State<TopRatedMovies> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = fetchMovies();
  }

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      return results.map((movieJson) => Movie.fromJson(movieJson)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(child: Text('No movies available'));
          } else {
            // Data fetched successfully, display it
            final movies = snapshot.data!;

            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  title: Text(movie.title),
                  subtitle: Text(movie.overview),
                  // You can display more information about the movie here
                );
              },
            );
          }
        },
      ),
    );
  }
}
