import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class SocialIcon extends StatelessWidget {
  const SocialIcon({this.scale,required this.image});
  final double ?scale;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 60,
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () {},
          icon: Image.asset(image,
            scale: scale,fit:BoxFit.fill,
          )),
    );
  }
}
