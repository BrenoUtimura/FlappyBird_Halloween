import 'dart:async';
import 'package:flappybird/barriers.dart';
import 'package:flappybird/esqueleto.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double pumpYaxis = 0;
  double height = 0;
  double time = 0;
  double initialHeight = pumpYaxis;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;
  double barrierXthree = 1.8 + 3;
  double pumpHeight = 0.1;
  double pumpWidht = 0.1;
  double initialPos = pumpYaxis;
  int score = 0;
  int highscore = 0;

  // game settings
  bool gameHasStarted = false;

  // barrie variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidht = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6]
  ];

  bool pumpkingIsDead() {
    if (pumpYaxis < -1 || pumpYaxis > 1) {
      return true;
    }

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= pumpWidht &&
          barrierX[i] + barrierWidht >= -pumpWidht &&
          (pumpYaxis <= -1 + barrierHeight[i][0] ||
              pumpYaxis + pumpHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Text(
              "G A M E  O V E R",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Score ${score.toString()}',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              GestureDetector(
                /*
                onTap: () {
                  resetGame();
                  if (score > highscore) {
                    highscore = score;
                  }
                  setState(() {
                    gameHasStarted = false;
                  });
                  Navigator.of(context).pop();
                },
                */
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      pumpYaxis = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = pumpYaxis;
      score = 0;
      height = 0;
      barrierXone = 1.8;
      barrierXtwo = 1.8 + 1.5;
      barrierXthree = 1.8 + 3;
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = pumpYaxis;
    });
  }

  bool checkLose() {
    if (barrierXone < 0.2 && barrierXone > -0.2) {
      if (pumpYaxis < -0.3 || pumpYaxis > 0.7) {
        return true;
      }
    }

    if (barrierXtwo < 0.2 && barrierXtwo > -0.2) {
      if (pumpYaxis < -0.8 || pumpYaxis > 0.4) {
        return true;
      }
    }

    if (barrierXthree < 0.2 && barrierXthree > -0.2) {
      if (pumpYaxis < -0.4 || pumpYaxis > 0.7) {
        return true;
      }
    }
    return false;
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        pumpYaxis = initialHeight - height;
      });

      setState(() {
        if (barrierXone < -2) {
          score++;
          barrierXone += 3.5;
        } else {
          barrierXone -= 0.05;
        }
      });

      setState(() {
        if (barrierXtwo < -2) {
          score++;
          barrierXtwo += 3.5;
        } else {
          barrierXtwo -= 0.05;
        }
      });

      setState(() {
        if (barrierXthree < -2) {
          score++;
          barrierXthree += 4.5;
        } else {
          barrierXthree -= 0.04;
        }
      });

      if (pumpkingIsDead()) {
        timer.cancel();
        _showDialog();
      }

      if (pumpYaxis > 1.3 || checkLose()) {
        timer.cancel();
        gameHasStarted = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(0, pumpYaxis),
                      duration: Duration(milliseconds: 0),
                      color: Colors.grey,
                      child: MyPumpking(),
                    ),
                    Container(
                      alignment: Alignment(0, -0.4),
                      child: gameHasStarted
                          ? Text("")
                          : Text(
                              "T A P  T O  P L A Y",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone, -1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 150.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo, -1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 250.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXthree, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 100.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXthree, -1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 200.0,
                      ),
                    ),
                  ],
                )),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SCORE",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          score.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "BEST",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          highscore.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
