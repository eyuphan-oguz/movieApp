import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/model/populerMovieModel.dart';
import 'package:movie/viewModel/getPopulerMovieData.dart';
class api extends StatefulWidget {
  const api({Key? key}) : super(key: key);

  @override
  State<api> createState() => _apiState();
}
late  Future<PopulerMovieModel> movieApi;








class _apiState extends State<api> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:  FutureBuilder<PopulerMovieModel>(
          future: fetchPopulerMoviesData(),
          builder: (BuildContext context , AsyncSnapshot snapshot) {
            if (snapshot.hasData) {

              print("********"*10);
              print(snapshot.data!.results![1].title);
              print("********"*10);
              Text(snapshot.data!.results![1].title.toString());
              return Image.network("https://image.tmdb.org/t/p/original/c24sv2weTHPsmDa7jEMN0m2P3RT.jpg");
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}






