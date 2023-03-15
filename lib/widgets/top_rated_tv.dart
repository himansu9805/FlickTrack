import 'package:flutter/material.dart';
import 'package:movie_series_application/enums/loader.enum.dart';
import 'package:movie_series_application/models/genre_class.dart';
import 'package:movie_series_application/models/tv_class.dart';
import 'package:movie_series_application/pages/tv_details.dart';
import 'package:movie_series_application/widgets/skeleton_loader.dart';

class TopRatedTV extends StatefulWidget {
  const TopRatedTV({super.key, required this.tv, required this.genre});
  final List<TV> tv;
  final List<Genre> genre;

  @override
  State<TopRatedTV> createState() => TopRatedTVState();
}

class TopRatedTVState extends State<TopRatedTV> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.tv.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TVDetails(
                    tv: widget.tv[index],
                    isTopRated: true,
                    genres: widget.genre,
                  ),
                ),
              );
            },
            child: SizedBox(
              width: 160.0,
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${widget.tv[index].posterPath}',
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
