import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie/model/populerMovieModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<PopulerMovieModel> fetchPopulerMoviesData({ int pageCount=1}) async {

  final response = await http
      .get(Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=${dotenv.env['API_KEY']}&language=en-US&page=${pageCount}'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    globalPopulerMovieModel=PopulerMovieModel.fromJson(jsonDecode(response.body));
    return globalPopulerMovieModel;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load movie');
  }
}


PopulerMovieModel globalPopulerMovieModel=PopulerMovieModel();

