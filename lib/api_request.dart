import 'package:http/http.dart' as http;

class API {
  String apiKey = "7f80b744dcb0ba4407902c334b482282";
  String rootUrl = "https://api.themoviedb.org/3";

  Future getTopRated(String type, int page) async {
    var url =
        '$rootUrl/$type/top_rated?api_key=$apiKey&language=en-US&page=$page';
    return http.get(Uri.parse(url));
  }

  Future getTrending(String type) async {
    var url = '$rootUrl/trending/$type/week?api_key=$apiKey';
    return http.get(Uri.parse(url));
  }

  Future getGenre(String type) async {
    var url = '$rootUrl/genre/$type/list?api_key=$apiKey&language=en-US';
    return http.get(Uri.parse(url));
  }
}
