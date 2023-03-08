import 'dart:convert';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_series_application/model/genre_class.dart';
import 'package:movie_series_application/model/movie_class.dart';
import 'package:movie_series_application/model/tv_class.dart';
import 'package:movie_series_application/top_rated_movies.dart';
import 'package:movie_series_application/top_rated_tv.dart';
import 'package:movie_series_application/trending_tv.dart';

import 'api_request.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var movies = <Movie>[];
  var tv = <TV>[];

  var trendingTV = <TV>[];

  var genreTV = <Genre>[];
  var trendingTVGenre = <String>[];

  API api = API();

  int trendingIndex = 0;

  _getTopMovies() {
    api.getTopRated("movie", 1).then((response) {
      setState(() {
        final data = json.decode(response.body);
        final results = data["results"];
        // print('${results.runtimeType} : $results');
        // developer.debugger();
        results.forEach((model) => movies.add(Movie.fromJson(model)));
      });
    });
  }

  _getTopTV() {
    api.getTopRated("tv", 1).then((response) {
      setState(() {
        final data = json.decode(response.body);
        final results = data["results"];
        // print('${results.runtimeType} : $results');
        // developer.debugger();
        results.forEach((model) => tv.add(TV.fromJson(model)));
      });
    });
  }

  _fetchData() async {
    await api.getGenre("tv").then((genreResponse) {
      final data = jsonDecode(genreResponse.body);
      final genres = data["genres"];
      setState(() {
        genres.forEach((model) => genreTV.add(Genre.fromJson(model)));
      });
      _getTopMovies();
      _getTopTV();
      Random random = Random();
      api.getTrending("tv").then((response) {
        final data = json.decode(response.body);
        final results = data["results"];
        setState(() {
          results.forEach((model) => trendingTV.add(TV.fromJson(model)));
          trendingIndex = random.nextInt(results.length);
        });
        if (trendingIndex != 0) {
          for (var tvGenre in trendingTV[trendingIndex].genreIds) {
            for (var element in genreTV) {
              if (tvGenre == element.id) {
                trendingTVGenre.add(element.name);
              }
            }
          }
        }
      });
    });
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlickTrack',
      theme: ThemeData(useMaterial3: true),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: MoviesSeries(
          topMovies: movies,
          topTV: tv,
          trendingTV: trendingTV,
          trendingIndex: trendingIndex,
          trendingTVGenre: trendingTVGenre,
          scaffoldKey: GlobalKey<ScaffoldState>()),
    );
  }
}

class MoviesSeries extends StatelessWidget {
  const MoviesSeries(
      {super.key,
      required this.topMovies,
      required this.topTV,
      required this.trendingTV,
      required this.trendingIndex,
      required this.trendingTVGenre,
      required this.scaffoldKey});
  final List<Movie> topMovies;
  final List<TV> topTV;
  final List<TV> trendingTV;
  final List<String> trendingTVGenre;
  final int trendingIndex;

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: ThemeData.dark().splashColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search movie and shows',
              suffixIcon: const Icon(Icons.search),
              prefixIcon: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Drawer Header'),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('Page 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.train,
              ),
              title: const Text('Page 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            trendingTV.isEmpty
                ? const AspectRatio(
                    aspectRatio: 0.9,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : TrendingTV(
                    tv: trendingTV,
                    trendingIndex: trendingIndex,
                    genres: trendingTVGenre),
            Container(
              margin: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0),
              width: width,
              child: Text(
                "Top Rated Movies",
                textAlign: TextAlign.left,
                style: GoogleFonts.firaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            TopRatedMovies(movies: topMovies),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              width: width,
              child: Text(
                "Top Rated TV Shows",
                textAlign: TextAlign.left,
                style: GoogleFonts.firaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            TopRatedTV(tv: topTV),
          ],
        ),
      ),
    );
  }
}
