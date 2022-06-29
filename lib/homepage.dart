import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_mario/jumpingMario.dart';
import 'package:super_mario/mario.dart';
import 'package:super_mario/mushroom.dart';
import 'package:super_mario/mybutton.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double marioX = 0;
  static double marioY = 1;
  double marioSize = 30;
  int marioLevel = 1;
  double shroomX = 0.5;
  double shroomY = 1;

  double time = 0;
  double height = 0;
  double initialHeight = marioY;
  String direction = "right";
  bool midrun = false;
  bool midjump = false;
  var gameFont = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.white, fontSize: 20));

  void eatMushroom() {
    if ((marioX - shroomX).abs() < 0.05 && (marioY - shroomY).abs() < 0.05) {
      setState(() {
        // moving the mushroom away
        shroomX = 2;
        marioSize = 50;
        marioLevel = 2;
      });

      Timer(Duration(seconds: 3), () {
        setState(() {
          marioLevel = 1;
          marioSize = 30;
        });
      });
    }
  }

  void preJump() {
    time = 0;
    initialHeight = marioY;
  }

  void jump() {
    if (midjump == false) {
      midjump = true;
      preJump();
      Timer.periodic(const Duration(milliseconds: 50), (timer) {
        time += 0.05;
        height = -4.9 * time * time + 5 * time;

        // this condition makes sure mario doesn't fall off the screen
        if (initialHeight - height > 1) {
          midjump = false;

          setState(() {
            marioY = 1;
          });
          timer.cancel();
        } else {
          setState(() {
            marioY = initialHeight - height;
          });
        }
      });
    }
  }

  void moveForward() {
    direction = "right";
    eatMushroom();

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      eatMushroom();
      if (MyButton.holdingButton == true && (marioX + 0.02 < 1)) {
        setState(() {
          marioX += 0.02;
          midrun = !midrun;
        });
      } else {
        timer.cancel();
      }
    });

    // setState(() {
    //   marioX += 0.02;
    // });
  }

  void moveBackward() {
    eatMushroom();
    // midrun = !midrun;
    direction = "left";

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      eatMushroom();
      if (MyButton.holdingButton == true && (marioX - 0.02 > -1)) {
        setState(() {
          marioX -= 0.02;
          midrun = !midrun;
        });
      } else {
        timer.cancel();
      }
    });
    // setState(() {
    //   marioX -= 0.02;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Container(
                  color: Colors.blue,
                  child: AnimatedContainer(
                    alignment: Alignment(marioX, marioY),
                    duration: Duration(milliseconds: 0),
                    child: midjump
                        ? JumpingMario(
                            direction: direction,
                            size: marioSize,
                          )
                        : MyMario(
                            direction: direction,
                            midrun: midrun,
                            size: marioSize,
                          ),
                  ),
                ),
                Container(
                    alignment: Alignment(shroomX, shroomY), child: Mushroom()),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Mario",
                            style: gameFont,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "$marioLevel",
                            style: gameFont,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "World",
                            style: gameFont,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "0-0",
                            style: gameFont,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Time",
                            style: gameFont,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "∞",
                            style: gameFont,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    childIcon: Icon(
                      Icons.arrow_circle_left_outlined,
                      size: 30,
                    ),
                    function: moveBackward,
                  ),
                  MyButton(
                    childIcon: Icon(
                      Icons.arrow_circle_up_outlined,
                      size: 30,
                    ),
                    function: jump,
                  ),
                  MyButton(
                    childIcon: Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 30,
                    ),
                    function: moveForward,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
