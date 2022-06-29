import 'dart:math';

import 'package:flutter/material.dart';

class MyMario extends StatelessWidget {
  final direction;
  final midrun;
  final size;

  MyMario({this.direction, this.midrun, this.size});

  @override
  Widget build(BuildContext context) {
    if (direction == "right") {
      return Container(
        width: size,
        child: midrun
            ? Image.asset('lib/marioImages/marioWalk.png')
            : Image.asset('lib/marioImages/marioStand.png'),
      );
    } else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Container(
          width: size,
          child: midrun
              ? Image.asset('lib/marioImages/marioWalk.png')
              : Image.asset('lib/marioImages/marioStand.png'),
        ),
      );
    }
  }
}
