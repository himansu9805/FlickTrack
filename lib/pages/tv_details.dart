import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_series_application/models/genre_class.dart';
import 'package:movie_series_application/models/tv_class.dart';
import 'package:movie_series_application/widgets/gradient_animated_icon.dart';

class TVDetails extends StatefulWidget {
  const TVDetails({super.key, required this.movie, required this.genres});

  final TV movie;
  final List<Genre> genres;

  @override
  State<TVDetails> createState() => _TVDetailsState();
}

class _TVDetailsState extends State<TVDetails> {
  List<String> movieGenres = [];
  double offset = 0.375;

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

  @override
  Widget build(BuildContext context) {
    _getGenres();
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
            "${widget.movie.name} (${widget.movie.releaseDate.substring(0, 4)})"),
      ),
      body: Stack(children: [
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
            )),
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
                        const Column(
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
                              widget.movie.voteAverage.toStringAsPrecision(2),
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
        SizedBox.expand(
          child: DraggableScrollableSheet(
            maxChildSize: 1,
            initialChildSize: .375,
            minChildSize: .375,
            builder: (BuildContext context, ScrollController scrollController) {
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: updateOffsetAccordingToScroll,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ThemeData.dark(useMaterial3: true)
                          .scaffoldBackgroundColor,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
                          width: width,
                          child: Text(
                            "Show Synopsis",
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
                          margin:
                              const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
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
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
