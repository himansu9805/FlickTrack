import 'package:flutter/material.dart';
import 'package:movie_series_application/model/tv_class.dart';

class TopRatedTV extends StatefulWidget {
  const TopRatedTV({super.key, required this.tv});
  final List<TV> tv;

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
          return SizedBox(
            width: 160.0,
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${widget.tv[index].posterPath}',
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
