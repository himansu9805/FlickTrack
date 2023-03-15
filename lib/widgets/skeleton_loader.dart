import 'package:flutter/material.dart';
import 'package:movie_series_application/enums/loader.enum.dart';

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({super.key, required this.type});

  final Loader type;

  @override
  State<StatefulWidget> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    animation = TweenSequence<Color?>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Colors.white10,
            end: const Color(0x22FFFFFF),
          ).chain(CurveTween(curve: Curves.ease)),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Color(0x22FFFFFF),
            end: Colors.white10,
          ).chain(CurveTween(curve: Curves.ease)),
        ),
      ],
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: widget.type == Loader.text
          ? Container(
              margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
              height: 13.125,
              width: 100,
              color: animation.value,
            )
          : widget.type == Loader.number
              ? Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                  height: 13.125,
                  width: 50,
                  color: animation.value,
                )
              : widget.type == Loader.paragraph
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          height: 13.125,
                          color: animation.value,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                          height: 13.125,
                          width: 350,
                          color: animation.value,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                          height: 13.125,
                          width: 150,
                          color: animation.value,
                        ),
                      ],
                    )
                  : widget.type == Loader.chip
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: animation.value,
                          ),
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                          height: 30,
                          width: 100,
                        )
                      : Container(
                          color: animation.value,
                        ),
    );
  }
}
