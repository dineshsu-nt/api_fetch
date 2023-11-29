import 'dart:convert';
import 'package:api_fetch/custom_widget/custom_movie_tile.dart';
import 'package:api_fetch/custom_widget/route-animation.dart';
import 'package:http/http.dart' as http;
import 'package:api_fetch/model/movie_model.dart';
import 'package:flutter/material.dart';

import 'movie_info_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> _moviesFuture;
  late TextEditingController _searchController = TextEditingController();
  late List<Movie> _allMovies;
  bool _isSearching = false;
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
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        bottom: PreferredSize(
          preferredSize: _isSearching
              ? const Size.fromHeight(kToolbarHeight + 10)
              : const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0)),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: _isSearching ? 40.0 : kToolbarHeight,
                      child: TextField(
                        controller: _searchController,
                        textAlignVertical: TextAlignVertical.center,
                        onTap: () {
                          setState(() {
                            _isSearching = true;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            // Your filtering logic here
                            //_allMovies = _filterMovies(value);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      )),
                ),
                if (_isSearching)
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _isSearching = false;
                        });
                      },
                      child: Text("Cancel"))
              ],
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
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              AnimatedRoute().createRoute(
                MovieInfoScreen(
                    id: movie.id.toString(),
                    releaseDate: movie.releaseDate,
                    overView: movie.overview,
                    title: movie.title,
                    image: movie.posterPath),
              ),
            );
          },
          child: CustomMovieTile(
              posterPath: 'https://image.tmdb.org/t/p/w342/${movie.posterPath}',
              title: movie.title,
              overview: movie.overview),
        );
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
