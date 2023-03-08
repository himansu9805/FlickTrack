import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_series_application/model/tv_class.dart';

class TrendingTV extends StatefulWidget {
  const TrendingTV(
      {super.key,
      required this.tv,
      required this.trendingIndex,
      required this.genres});
  final List<TV> tv;
  final int trendingIndex;
  final List<String> genres;

  @override
  State<TrendingTV> createState() => TrendingTVState();
}

class TrendingTVState extends State<TrendingTV> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AspectRatio(
        aspectRatio: 0.9,
        child: Container(
          foregroundDecoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF383434),
                Color.fromARGB(0, 14, 14, 14),
                Color(0xFF383434),
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
              'https://image.tmdb.org/t/p/w500${widget.tv[widget.trendingIndex].posterPath}',
            ),
          )),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(10),
        child: const Icon(
          Icons.trending_up_rounded,
          color: Color.fromARGB(255, 99, 255, 104),
          size: 75,
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
                Text(
                  widget.tv[widget.trendingIndex].name,
                  style: GoogleFonts.firaSans(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.tv[widget.trendingIndex].voteAverage
                          .toStringAsPrecision(2),
                      style: GoogleFonts.firaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (String element in widget.genres)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 5.0),
                        child: Text(
                          element,
                          style: GoogleFonts.firaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
