import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/components/appBarComponents.dart';
import 'package:movie/model/genresModel.dart';
import 'package:movie/model/populerMovieModel.dart';
import 'package:movie/utils/IconUtils/iconTextColor.dart';
import 'package:movie/utils/IconUtils/icons.dart';
import 'package:movie/utils/IconUtils/iconsText.dart';
import 'package:movie/utils/assetsUtils/svgUtils/svgModels.dart';
import 'package:movie/viewModel/getGenresData.dart';
import 'package:movie/viewModel/getMovieTrailerData.dart';
import 'package:movie/viewModel/getPopulerMovieData.dart';
import 'package:movie/widgets/customRowIconsWidget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

SvgModels svgModels = SvgModels();
IconModels iconModels = IconModels();
int pageIndex = 1;

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(
            begin: Colors.transparent, end: Colors.black.withOpacity(0.8))
        .animate(_animationController);
    fetchGenresData();
    fetchPopulerMoviesData();
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

  comediMovieList(
      PopulerMovieModel populerMovieModel, GenresModel genresModel) {
    int i = 0;

    do {
      for (int j = 0; j < populerMovieModel.results![i].genreIds!.length; j++) {
        if (populerMovieModel.results![i].genreIds![j] ==
            genresModel.genres![0].id) {
          print(populerMovieModel.results![i].title);
        }
      }
      i++;
    } while (i <= populerMovieModel.results!.length);
  }

  YoutubePlayerController? youtubePlayerController;

  getTrailerVideo(int index) async {
    String key = await fetchMoviesTrailerData(index);
    print("${key}");

    youtubePlayerController = YoutubePlayerController(
        initialVideoId: key,
        flags: YoutubePlayerFlags(autoPlay: true, mute: false));
    return youtubePlayerController;
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  IconModels iconModels = IconModels();
  IconText iconText = IconText();
  IconTextColor iconTextColor = IconTextColor();
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
                        CustomRowIconsWidget(
                            iconModels: iconModels,
                            iconText: iconText,
                            iconTextColor: iconTextColor),
                        SingleChildScrollView(
                          child: FutureBuilder<PopulerMovieModel>(
                            future:
                                fetchPopulerMoviesData(pageCount: pageIndex),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: height * 0.3,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                snapshot.data.results.length,
                                            itemBuilder: (BuildContext context,
                                                    index) =>
                                                index + 1 <
                                                            snapshot
                                                                .data
                                                                .results
                                                                .length &&
                                                        snapshot.data != null
                                                    ? InkWell(
                                                        onTap: () async {
                                                          await getTrailerVideo(
                                                              index);

                                                          showModalBottomSheet(
                                                            isScrollControlled: true,
                                                            backgroundColor:(Colors.black),
                                                            context: context,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20)),
                                                            ),
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Container(
                                                                  height:
                                                                height *
                                                                    0.80,
                                                                  child: Column(

                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 15.0),
                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      RatingBarIndicator(
                                                                        rating: (globalPopulerMovieModel.results![index].voteAverage)!.toDouble()/2,
                                                                        itemBuilder: (context, index) => Icon(
                                                                          Icons.star,
                                                                          color: Colors.amber,

                                                                        ),
                                                                        unratedColor:(Colors.white),
                                                                        itemCount: 5,
                                                                        itemSize: 20,
                                                                        direction: Axis.horizontal,
                                                                      ),

                                                                      IconButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          icon: Icon(Icons.cancel_outlined,color: Colors.white,size: 30,)),

                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(height: height*0.06,),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Text("IMDB",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold) ,),
                                                                        Text("${globalPopulerMovieModel.results![index].voteAverage.toString()}",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold) ,),
                                                                      ],
                                                                    ),
                                                                    VerticalDivider(color: Colors.red,),
                                                                    //SizedBox(width: width*0.15,),
                                                                    Column(
                                                                      children: [
                                                                        Text("Release Date",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold) ,),
                                                                        Text("${globalPopulerMovieModel.results![index].releaseDate.toString()}",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold) ,),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),


                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(vertical: 25.0),
                                                                          child: YoutubePlayer(
                                                                  controller:
                                                                      youtubePlayerController!,
                                                                  showVideoProgressIndicator:
                                                                      true,
                                                                  progressIndicatorColor:
                                                                      Colors.blue,
                                                                ),
                                                                        ),

                                                                Text(globalPopulerMovieModel.results![index].overview.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                              ],
                                                                  ),
                                                                );
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 10.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: Image.network(
                                                                "https://image.tmdb.org/t/p/original/${snapshot.data.results![index].posterPath}",
                                                                fit: BoxFit
                                                                    .fill),
                                                          ),
                                                        ),
                                                      )
                                                    : TextButton.icon(
                                                        onPressed: () {
                                                          setState(() {
                                                            pageIndex++;
                                                            print(pageIndex);
                                                          });
                                                        },
                                                        icon: Icon(Icons
                                                            .zoom_in_map_outlined),
                                                        label: Text(
                                                          "View More",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }

                              return CircularProgressIndicator();
                            },
                          ),
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
