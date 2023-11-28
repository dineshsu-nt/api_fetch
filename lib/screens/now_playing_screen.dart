import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:api_fetch/model/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> _moviesFuture;
  late TextEditingController _searchController = TextEditingController();
  late List<Movie> _allMovies;
  @override
  void initState() {
    super.initState();
    _moviesFuture = fetchMovies();
  }

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'),
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
        title: Text('Now Playing Movies'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _allMovies = [];
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _allMovies = _filterMovies(value);
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by movie title...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
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
            _allMovies = snapshot.data!;
            return _buildMovieList();
          }
        },
      ),
    );
  }

  Widget _buildMovieList() {
    final moviesToDisplay = _searchController.text.isEmpty
        ? _allMovies
        : _filterMovies(_searchController.text);
    return ListView.builder(
      itemCount: moviesToDisplay.length,
      itemBuilder: (context, index) {
        final movie = moviesToDisplay[index];
        return ListTile(
          title: Column(
            children: [
              Row(
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/w342/${movie.posterPath}',
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Column(
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 2.h,
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        );
        // return ListTile(tileColor: Colors.orangeAccent,
        //   title: Text(movie.title,style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w700),),
        //   subtitle: Text(movie.overview),
        //   leading: ClipRRect(
        //     borderRadius: BorderRadius.circular(8.0),
        //     child: Image.network(
        //       'https://image.tmdb.org/t/p/w342/${movie.posterPath}',
        //       width: 70,
        //       height: 100,
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        //   // trailing: Image.network(
        //   //   'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
        //   //   width: 100,
        //   //   height: 100,
        //   //   fit: BoxFit.cover,
        //   // ),
        // );
      },
    );
  }

  List<Movie> _filterMovies(String query) {
    return _allMovies.where((movie) {
      final title = movie.title.toLowerCase();
      final searchLower = query.toLowerCase();
      return title.contains(searchLower);
    }).toList();
  }
}
