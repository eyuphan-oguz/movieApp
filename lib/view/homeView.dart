import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie/components/appBarComponents.dart';
import 'package:movie/model/populerMovieModel.dart';
import 'package:movie/utils/IconUtils/iconTextColor.dart';
import 'package:movie/utils/IconUtils/icons.dart';
import 'package:movie/utils/IconUtils/iconsText.dart';
import 'package:movie/utils/assetsUtils/svgUtils/svgModels.dart';
import 'package:movie/viewModel/getGenresData.dart';
import 'package:movie/viewModel/getPopulerMovieData.dart';
import 'package:movie/widgets/customRowIconsWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

SvgModels svgModels = SvgModels();
IconModels iconModels = IconModels();

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;
  var indexx;
  var b;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(
            begin: Colors.transparent, end: Colors.black.withOpacity(0.8))
        .animate(_animationController);
    fetchGenresData();
    super.initState();
  }

  bool scrollListiner(ScrollNotification scrollNotification) {
    bool scroll = false;
    if (scrollNotification.metrics.axis == Axis.vertical) {
      _animationController.animateTo(scrollNotification.metrics.pixels / 80);
      return scroll = true;
    }
    return scroll;
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  IconModels iconModels=IconModels();
  IconText iconText=IconText();
  IconTextColor iconTextColor=IconTextColor();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: NotificationListener(
          onNotification: scrollListiner,
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Stack(
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              "https://image.tmdb.org/t/p/original//1g0dhYtq4irTY1GPXvft6k4YLjm.jpg",
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.width * 1,
                              width: MediaQuery.of(context).size.width,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.width * 1,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xAC000000),
                                    const Color(0x00000000),
                                    const Color(0x00000000),
                                    const Color(0xAC000000),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        CustomRowIconsWidget(iconModels: iconModels, iconText: iconText, iconTextColor: iconTextColor),


                        FutureBuilder<PopulerMovieModel>(
                          future: fetchPopulerMoviesData(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                height: height*0.3,
                                child: ListView.builder(
                                      //physics: NeverScrollableScrollPhysics(),
                                      //shrinkWrap: true,
                                    padding: EdgeInsets.zero,

                                    scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data.results.length,
                                      itemBuilder: (BuildContext context, index) {
                                        PopulerMovieModel project =
                                            snapshot.data;

                                        return Container(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.network("https://image.tmdb.org/t/p/original/${project.results![index].posterPath}",fit: BoxFit.fill),

                                          ),
                                        );


                                      }),
                              );

                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }

                            return const CircularProgressIndicator();
                          },
                        ),
                        FutureBuilder<PopulerMovieModel>(
                          future: fetchPopulerMoviesData(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                height: height*0.3,
                                child: ListView.builder(
                                  //physics: NeverScrollableScrollPhysics(),
                                  //shrinkWrap: true,
                                    padding: EdgeInsets.zero,

                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.results.length,
                                    itemBuilder: (BuildContext context, index) {
                                      PopulerMovieModel project =
                                          snapshot.data;


                                      for(int i=0 ; i<project.results![index].genreIds!.length;i++){
                                        if(project.results![index].genreIds![i]==globalGenresData.genres![0].id){
                                          //print("aynı");
                                          //print(project.results![index].genreIds![i]);
                                          //print(globalGenresData.genres![0].id);
                                          //print("aynı");
                                           b=project.results![index].genreIds![i];
                                           indexx=index;

                                        }
                                      }


                                      return Container(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child:globalGenresData.genres![0].id==b ? Image.network("https://image.tmdb.org/t/p/original/${project.results![indexx].posterPath}",fit: BoxFit.fill):Text("a"),

                                        ),
                                      );


                                    }),
                              );

                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }

                            return const CircularProgressIndicator();
                          },
                        ),


                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.27,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.27,
                          color: Colors.red,
                        ),
                      ],
                    )
                  ],
                ),


                CustomAppBar(
                  animationController: _animationController,
                  colorsTween: _colorTween,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


