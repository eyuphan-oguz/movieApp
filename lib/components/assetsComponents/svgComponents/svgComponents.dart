import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgImageWidget extends StatelessWidget {
  const SvgImageWidget({Key? key, required this.svgText}) : super(key: key);
  final String svgText;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/svg/${svgText}.svg",
      width: MediaQuery.of(context).size.width*0.2,
      height: MediaQuery.of(context).size.height*0.019,
      allowDrawingOutsideViewBox: true,
      color: Colors.red,);
  }
}