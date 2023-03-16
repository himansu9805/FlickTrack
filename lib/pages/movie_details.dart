import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_series_application/enums/loader.enum.dart';
import 'package:movie_series_application/models/genre_class.dart';
import 'package:movie_series_application/models/movie_class.dart';
import 'package:movie_series_application/models/movie_detail_class.dart';
import 'package:movie_series_application/services/api_request.dart';
import 'package:movie_series_application/widgets/gradient_animated_icon.dart';
import 'package:movie_series_application/widgets/skeleton_loader.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails(
      {super.key,
      required this.movie,
      required this.genres,
      required this.isTopRated});

  final Movie movie;
  final List<Genre> genres;
  final bool isTopRated;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<String> movieGenres = [];
  double offset = 0.375;
  bool hasLoaded = false;
  late MovieDetail movieDetails;

  API api = API();

  _getGenres() {
    if (movieGenres.isEmpty) {
      for (var tvGenre in widget.movie.genreIds) {
        for (var element in widget.genres) {
          if (tvGenre == element.id) {
            movieGenres.add(element.name);
          }
        }
      }
    }
  }

  bool updateOffsetAccordingToScroll(
      DraggableScrollableNotification draggableScrollNotification) {
    setState(() => offset = draggableScrollNotification.extent);
    return true;
  }

  _fetchData() {
    api.getDetails("movie", widget.movie.id).then((response) {
      setState(() {
        final data = json.decode(response.body);
        movieDetails = MovieDetail.fromJson(data);
        hasLoaded = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    _getGenres();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height / 9,
        title: Text(
            "${widget.movie.title} (${widget.movie.releaseDate.substring(0, 4)})"),
      ),
      body: Stack(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Container(
              foregroundDecoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(0, 14, 14, 14),
                    Color(0xFF201c1c),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.5, 1],
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  alignment: FractionalOffset.topCenter,
                  image: NetworkImage(
                    'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                  ),
                  opacity: 1.35 - offset,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.isTopRated
                            ? GradientAnimatedIcon(
                                icon: Icons.military_tech_rounded,
                                colors: const [
                                  Color.fromARGB(255, 255, 120, 120),
                                  Color.fromARGB(255, 222, 79, 50),
                                  Color.fromARGB(255, 77, 33, 27)
                                ],
                                size: height / 12,
                              )
                            : const SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.star_rounded,
                                color: Colors.amber, size: height / 15),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.movie.voteAverage.toStringAsPrecision(2),
                              style: GoogleFonts.firaSans(
                                fontSize: height / 25,
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
          SizedBox.expand(
            child: DraggableScrollableSheet(
                maxChildSize: 1,
                initialChildSize: .375,
                minChildSize: .375,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return NotificationListener<DraggableScrollableNotification>(
                    onNotification: updateOffsetAccordingToScroll,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(32.5 * (1 - offset)),
                          color: ThemeData.dark(useMaterial3: true)
                              .scaffoldBackgroundColor,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(
                                  15.0, 15.0, 15.0, 5.0),
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
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              child: Text(
                                widget.movie.overview,
                                style: GoogleFonts.firaSans(),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(
                                  15.0, 15.0, 15.0, 5.0),
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
                              width: width,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              child: Wrap(
                                children: [
                                  for (String element in movieGenres)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: RawChip(
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
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(
                                  15.0, 15.0, 15.0, 5.0),
                              width: width,
                              child: Text(
                                "Production Companies",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.firaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            hasLoaded
                                ? Container(
                                    width: width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5.0),
                                    child: Wrap(
                                      children: [
                                        for (Map element
                                            in movieDetails.productionCompanies)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: RawChip(
                                              avatar: element["logo_path"]
                                                          .runtimeType !=
                                                      Null
                                                  ? CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        'https://image.tmdb.org/t/p/w500${element["logo_path"]}',
                                                      ),
                                                    )
                                                  : CircleAvatar(
                                                      child: Text(
                                                          element["name"][0]),
                                                    ),
                                              label: Text(
                                                element["name"],
                                                style: GoogleFonts.firaSans(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5.0),
                                    child: const Wrap(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child:
                                              SkeletonLoader(type: Loader.chip),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child:
                                              SkeletonLoader(type: Loader.chip),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
