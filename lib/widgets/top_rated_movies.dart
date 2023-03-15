import 'package:flutter/material.dart';
import 'package:movie_series_application/enums/loader.enum.dart';
import 'package:movie_series_application/models/genre_class.dart';
import 'package:movie_series_application/models/movie_class.dart';
import 'package:movie_series_application/pages/movie_details.dart';
import 'package:movie_series_application/widgets/skeleton_loader.dart';

class TopRatedMovies extends StatefulWidget {
  const TopRatedMovies({super.key, required this.movies, required this.genre});
  final List<Movie> movies;
  final List<Genre> genre;

  @override
  State<TopRatedMovies> createState() => TopRatedMoviesState();
}

class TopRatedMoviesState extends State<TopRatedMovies> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MovieDetails(
                    movie: widget.movies[index],
                    genres: widget.genre,
                    isTopRated: true,
                  ),
                ),
              );
            },
            child: SizedBox(
              width: 160.0,
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${widget.movies[index].posterPath}',
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12.5),
                      height: 200.0,
                      width: 160.0,
                      child: const SkeletonLoader(type: Loader.image),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
