import 'package:api_fetch/custom_widget/custom_movie_tile.dart';
import 'package:api_fetch/custom_widget/route-animation.dart';
import 'package:api_fetch/model/movie_model.dart';
import 'package:api_fetch/screens/movie_info_screen.dart';
import 'package:api_fetch/services/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TopRatedMovies extends StatefulWidget {
  const TopRatedMovies({Key? key}) : super(key: key);

  @override
  State<TopRatedMovies> createState() => _TopRatedMoviesState();
}

class _TopRatedMoviesState extends State<TopRatedMovies> {
  late Future<List<Movie>> _moviesFuture;
  late TextEditingController _searchController = TextEditingController();
  late List<Movie> _allMovies;
  bool _isSearching = false;
  final fetchMovie = ApiServices().topRatedMovieFetch();
  @override
  void initState() {
    super.initState();
    _moviesFuture = fetchMovie;
  }

  Future<void> _refreshMovies() async {
    List<Movie> refreshedMovies = await fetchMovie;
    setState(() {
      _allMovies = refreshedMovies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        bottom: PreferredSize(
          preferredSize: _isSearching
              ? Size.fromHeight(kToolbarHeight + 10.sp)
              : const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0.sp)),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: _isSearching ? 30.w : kToolbarHeight,
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
                          prefixIcon: const Icon(Icons.search),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8.0.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0.sp),
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
                      child: const Text("Cancel"))
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshMovies,
        child: FutureBuilder<List<Movie>>(
          future: _moviesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return const Center(child: Text('No movies available'));
            } else {
              _allMovies = snapshot.data!;
              return _buildMovieList();
            }
          },
        ),
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
                    image: movie.posterPath,
                  ),
                ),
              );
            },
            child: CustomMovieTile(
                posterPath:
                    'https://image.tmdb.org/t/p/w342/${movie.posterPath}',
                title: movie.title,
                overview: movie.overview));
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
