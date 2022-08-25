import 'dart:convert';
import 'package:flutter/material.dart';
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
int pageIndex=1;

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

  comediMovieList(PopulerMovieModel populerMovieModel,GenresModel genresModel){
    int i=0;

    do{
      for(int j=0 ; j<populerMovieModel.results![i].genreIds!.length; j++){
        if(populerMovieModel.results![i].genreIds![j]==genresModel.genres![0].id){
          print(populerMovieModel.results![i].title);
        }
      }
      i++;
    }while(i<=populerMovieModel.results!.length);
  }

  getTrailerVideo(int index){
    fetchMoviesTrailerData(index);

    _youtubePlayerController=YoutubePlayerController(initialVideoId:globalMovieTrailer.results![0].key!.toString()
        ,flags: YoutubePlayerFlags(autoPlay: true,mute: false));
    return _youtubePlayerController;
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  IconModels iconModels=IconModels();
  IconText iconText=IconText();
  IconTextColor iconTextColor=IconTextColor();
  late YoutubePlayerController _youtubePlayerController;
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


                        SingleChildScrollView(
                          child: FutureBuilder<PopulerMovieModel>(
                            future: fetchPopulerMoviesData(pageCount: pageIndex),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {


                                  if (snapshot.hasData) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: height*0.3,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.horizontal,
                                              itemCount: snapshot.data.results.length,
                                              itemBuilder: (BuildContext context, index)=>
                                                index < snapshot.data.results.length-1?
                                                   GestureDetector(
                                                     onTap: () {
                                                            setState((){
                                                            getTrailerVideo(index);
                                                            });



                                                       showModalBottomSheet<void>(
                                                         isScrollControlled: true,
                                                         context: context,
                                                         builder: (BuildContext context) {

                                                           return Container(
                                                             height: height*0.85,
                                                             color: Colors.amber,
                                                             child: Center(child: YoutubePlayer(controller: _youtubePlayerController,showVideoProgressIndicator: true,progressIndicatorColor: Colors.blue,)


                                                             ),
                                                           );
                                                         },
                                                       );
                                                     },
                                                     child: Container(
                                                      padding: EdgeInsets.only(right: 10.0),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: Image.network("https://image.tmdb.org/t/p/original/${snapshot.data.results![index].posterPath}",fit: BoxFit.fill),
                                                      ),
                                                  ),
                                                   ):TextButton.icon(onPressed: (){
                                                    setState((){
                                                      pageIndex++;
                                                      print(pageIndex);
                                                    });

                                                },icon: Icon(Icons.zoom_in_map_outlined),label: Text("View More",style: TextStyle(color: Colors.white),),)
                                              ),
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


