import 'package:flutter/material.dart';
import 'package:movie_series_application/model/movie_class.dart';

class TopRatedMovies extends StatefulWidget {
  const TopRatedMovies({super.key, required this.movies});
  final List<Movie> movies;

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
          return SizedBox(
            width: 160.0,
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${widget.movies[index].posterPath}',
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
