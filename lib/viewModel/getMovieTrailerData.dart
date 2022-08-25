import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie/model/movieTrailerModel.dart';
import 'package:movie/model/populerMovieModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie/viewModel/getPopulerMovieData.dart';

Future<MovieTrailerModel> fetchMoviesTrailerData(int index) async {

  final response = await http
      .get(Uri.parse('https://api.themoviedb.org/3/movie/${globalPopulerMovieModel.results![index].id}/videos?api_key=${dotenv.env['API_KEY']}&language=en-US'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    globalMovieTrailer=MovieTrailerModel.fromJson(jsonDecode(response.body));
    return globalMovieTrailer;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load movie');
  }
}

MovieTrailerModel globalMovieTrailer=MovieTrailerModel();

