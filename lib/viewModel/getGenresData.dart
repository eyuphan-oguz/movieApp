import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie/model/genresModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<GenresModel> fetchGenresData() async {

  final response = await http
      .get(Uri.parse('https://api.themoviedb.org/3/genre/movie/list?api_key=${dotenv.env["API_KEY"]}&language=en-US'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    globalGenresData=GenresModel.fromJson(jsonDecode(response.body));
    return globalGenresData;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load movie');
  }
}


GenresModel globalGenresData=GenresModel();


