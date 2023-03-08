import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_series_application/models/genre_class.dart';
import 'package:movie_series_application/models/movie_class.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key, required this.movie, required this.genres});

  final Movie movie;
  final List<Genre> genres;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<String> movieGenres = [];

  _getGenres() {
    for (var tvGenre in widget.movie.genreIds) {
      for (var element in widget.genres) {
        if (tvGenre == element.id) {
          movieGenres.add(element.name);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _getGenres();
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
            "${widget.movie.title} (${widget.movie.releaseDate.substring(0, 4)})"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              AspectRatio(
                aspectRatio: 0.9,
                child: Container(
                  foregroundDecoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(0, 14, 14, 14),
                        Color(0xFF201c1c),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.5, 1],
                    ),
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: FractionalOffset.topCenter,
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                    ),
                  )),
                ),
              ),
              AspectRatio(
                aspectRatio: 0.9,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.stars,
                                color: Colors.blue,
                                size: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 40,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.movie.voteAverage
                                        .toStringAsPrecision(2),
                                    style: GoogleFonts.firaSans(
                                      fontSize: 40,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
            Container(
              margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
              width: width,
              child: Text(
                "Movie Synopsis",
                textAlign: TextAlign.left,
                style: GoogleFonts.firaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Text(
                widget.movie.overview,
                style: GoogleFonts.firaSans(),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
              width: width,
              child: Text(
                "Genre",
                textAlign: TextAlign.left,
                style: GoogleFonts.firaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (String element in movieGenres)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ActionChip(
                        label: Text(
                          element,
                          style: GoogleFonts.firaSans(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
