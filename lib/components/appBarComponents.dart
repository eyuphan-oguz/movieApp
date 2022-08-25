import 'package:flutter/material.dart';
import 'package:movie/view/homeView.dart';

import 'assetsComponents/svgComponents/svgComponents.dart';

class CustomAppBar extends StatelessWidget {
  AnimationController animationController;
  Animation colorsTween;

  CustomAppBar({required this.animationController,
    required this.colorsTween,


  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.1,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) => Center(
          child: AppBar(

            backgroundColor: colorsTween.value,
            elevation: 0,
            title: SvgImageWidget(svgText: svgModels.appBarIcon,),
            actions: [
              IconButton(onPressed: (){}, icon: iconModels.searchBarIcon),
              IconButton(onPressed: (){}, icon:iconModels.profileIcon),
            ],
          ),
        ),
      ),
    );
  }
}
