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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
            "${widget.movie.title} (${widget.movie.releaseDate.substring(0, 4)})"),
        actions: [
          widget.isTopRated && offset > 0.55
              ? Opacity(
                  opacity: offset == 1 ? 1 : offset - 0.55,
                  child: const GradientAnimatedIcon(
                    icon: Icons.military_tech_rounded,
                    colors: [
                      Color.fromARGB(255, 255, 120, 120),
                      Color.fromARGB(255, 222, 79, 50),
                      Color.fromARGB(255, 77, 33, 27)
                    ],
                    size: 50,
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: Stack(
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
                    opacity: 1.35 - offset,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: hasLoaded
                        ? RawChip(
                            avatar: const Icon(Icons.language_rounded),
                            label: Text(
                                movieDetails.originalLanguage.toUpperCase(),
                                style: GoogleFonts.firaSans()),
                            backgroundColor: Colors.transparent,
                          )
                        : const SkeletonLoader(type: Loader.chip),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CircleAvatar(child: Icon(Icons.favorite_border_rounded)),
                  ),
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 0.9 + 0.1 * offset,
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
                            widget.isTopRated
                                ? const Column(
                                    children: [
                                      Text("TOP RATED"),
                                      GradientAnimatedIcon(
                                        icon: Icons.military_tech_rounded,
                                        colors: [
                                          Color.fromARGB(255, 255, 120, 120),
                                          Color.fromARGB(255, 222, 79, 50),
                                          Color.fromARGB(255, 77, 33, 27)
                                        ],
                                        size: 60,
                                      ),
                                    ],
                                  )
                                : Container(),
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
