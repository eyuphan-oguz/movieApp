import 'package:flutter/material.dart';
import 'package:movie/utils/IconUtils/iconTextColor.dart';
import 'package:movie/utils/IconUtils/icons.dart';
import 'package:movie/utils/IconUtils/iconsText.dart';

class CustomRowIconsWidget extends StatelessWidget {
  const CustomRowIconsWidget({
    Key? key,
    required this.iconModels,
    required this.iconText,
    required this.iconTextColor,
  }) : super(key: key);

  final IconModels iconModels;
  final IconText iconText;
  final IconTextColor iconTextColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: () {},
            child: Column(
              children: [
                iconModels.addListIcon,
                Text(iconText.addListIconText,
                    style: TextStyle(color:iconTextColor.addListIconTextColor))
              ],
            )),
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                primary: Colors.white),
            child: Row(
              children: [
                iconModels.playIcon,
                Text(
                  iconText.playIconText, style: TextStyle(color: iconTextColor.playIconTextColor),
                )
              ],
            )),
        TextButton(
            onPressed: () {},
            child: Column(
              children: [
                iconModels.informationIcon,
                Text(iconText.informationText, style: TextStyle(color: iconTextColor.informationIconTextColor))
              ],
            )),
      ],
    );
  }
}