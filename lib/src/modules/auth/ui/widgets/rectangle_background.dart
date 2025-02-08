import 'package:flutter/cupertino.dart';

import 'circle_background.dart';

class BackGroundRectangle extends StatelessWidget {
  const BackGroundRectangle({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(bottom: 2,child:Image.asset("assets/images/Rectangle 3.png",)),
      Positioned(bottom: 2,child:Image.asset("assets/images/Rectangle 4.png",)),
      CustomPaint(
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
        painter: BackgroundCircle(),
      ),
    ],) ;
  }
}
