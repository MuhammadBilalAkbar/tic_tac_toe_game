import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/frosted_glass.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const greenColor = Color(0xff01a510);
  List listXO = List.generate(9, (index) => 'assets/images/box.png');

  final playerOImage = 'assets/images/circle.png';
  final playerXImage = 'assets/images/close.png';
  final emptyImage = 'assets/images/box.png';
  final equalSound = 'audios/equal.wav';
  final winnerSound = 'audios/winner.mp3';
  final oPlayerSound = 'audios/o.mp3';
  final xPlayerSound = 'audios/x.mp3';
  final resetGameSound = 'audios/reset.mp3';

  bool winnerO = false;
  bool winnerX = false;
  bool isMuted = false;
  bool isOTurn = true;
  bool isPaused = false;

  int playerOScore = 0;
  int playerXScore = 0;
  int equal = 0;
  int filledBoxes = 0;

  bool playAgain = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/bg.jpeg',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              Container(
                color: Colors.black54,
                height: double.infinity,
                width: double.infinity,
              ),
              buildRow(width, height),
              getScoreBoard(width, height),
              buildGridView(width, height),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(double width, double height) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: height * 0.87,
      child: Container(
        margin: EdgeInsets.all(width * 0.05),
        child: Row(
          children: [
            buildIconButton(
              onTap: () => pauseGame(width, height),
              image: isPaused ? 'resume' : 'pause',
              width: width,
              height: height,
            ),
            const Spacer(),
            buildIconButton(
              onTap: toggleSound,
              image: 'music',
              width: width,
              height: height,
            ),
            SizedBox(width: width * 0.04),
            buildIconButton(
              onTap: () => resetGame(width, height),
              image: 'refresh',
              width: width,
              height: height,
            ),
          ],
        ),
      ),
    );
  }

  Widget getScoreBoard(double width, double height) {
    return Positioned(
      top: height * 0.1,
      child: Container(
        margin: EdgeInsets.all(width * 0.05),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  height: height * 0.065,
                  width: width * 0.33,
                  padding: EdgeInsets.symmetric(
                      vertical: width * 0.015, horizontal: width * 0.02),
                  decoration: BoxDecoration(
                    color: isOTurn ? greenColor : Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                    border: isOTurn
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Player O',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'Win: $playerOScore',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Image.asset(
                        playerOImage,
                        height: width * 0.08,
                        width: width * 0.08,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.01),
                Visibility(
                  visible: isOTurn,
                  // replacement: SizedBox(height: height * 0.1,),
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: const Text(
                    'Your Turn',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(width: width * 0.05),
            Container(
              height: width * 0.13,
              width: width * 0.13,
              margin: EdgeInsets.only(bottom: height * 0.038),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Equals',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$equal',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: width * 0.05),
            Column(
              children: [
                Container(
                  height: height * 0.065,
                  width: width * 0.33,
                  padding: EdgeInsets.symmetric(
                      vertical: width * 0.015, horizontal: width * 0.02),
                  decoration: BoxDecoration(
                    color: !isOTurn ? greenColor : Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                    border: !isOTurn
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Player X',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'Win: $playerXScore',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Image.asset(
                        playerXImage,
                        height: width * 0.08,
                        width: width * 0.08,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.01),
                Visibility(
                  visible: !isOTurn,
                  // replacement: SizedBox(height: height * 0.1,),
                  maintainAnimation: true,
                  maintainSize: true,
                  maintainState: true,
                  child: const Text(
                    'Your Turn',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridView(double width, double height) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 400,
        width: double.infinity,
        margin: EdgeInsets.all(width * 0.05),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          border: Border.all(color: Colors.white60, width: 3),
          borderRadius: BorderRadius.circular(50),
        ),
        child: FrostedGlassBox(
          child: GridView.builder(
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 132,
            ),
            itemBuilder: (context, index) {
              BorderRadius borderRadius;
              if (index == 0) {
                borderRadius = const BorderRadius.only(
                  topLeft: Radius.circular(47),
                );
              } else if (index == 2) {
                borderRadius = const BorderRadius.only(
                  topRight: Radius.circular(50),
                );
              } else if (index == 6) {
                borderRadius = const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                );
              } else if (index == 8) {
                borderRadius = const BorderRadius.only(
                  bottomRight: Radius.circular(50),
                );
              } else {
                borderRadius = BorderRadius.circular(0);
              }
              return GestureDetector(
                onTap: isPaused ? () {} : () => onTap(index, width, height),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(color: Colors.white),
                  ),
                  child: Center(
                    child: Image(
                      image: AssetImage(listXO[index]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildIconButton({
    required VoidCallback onTap,
    required String image,
    required double height,
    required double width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * 0.1,
        height: width * 0.1,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            greenColor,
            Colors.green,
          ]),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Image.asset('assets/images/$image.png', scale: 2),
      ),
    );
  }

  Widget buildTextButton({
    required Function()? onTap,
    required double width,
    required double height,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: greenColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void onTap(int index, double width, double height) {
    setState(() {
      if (listXO[index] != emptyImage) {
        return;
      } else if (isOTurn && listXO[index] == emptyImage) {
        listXO[index] = playerOImage;
        playSound(oPlayerSound);
        filledBoxes = filledBoxes + 1;
      } else if (!isOTurn && listXO[index] == emptyImage) {
        listXO[index] = playerXImage;
        playSound(xPlayerSound);
        filledBoxes = filledBoxes + 1;
      }
      isOTurn = !isOTurn;
      checkWinner();

      if (winnerO == true) {
        playSound(winnerSound);
        showWinDialog(winner: 'O!', width: width, height: height);
      }

      if (winnerX == true) {
        playSound(winnerSound);
        showWinDialog(winner: 'X!', width: width, height: height);
      }

      if (filledBoxes == 9 && winnerO == false && winnerX == false) {
        playSound(equalSound);
        showWinDialog(winner: 'Equal!', width: width, height: height);
      }
    });
  }

  void checkWinner() {
    // check 1st row
    if (listXO[0] == listXO[1] &&
        listXO[0] == listXO[2] &&
        listXO[0] != emptyImage) {
      if (listXO[0] == playerOImage) {
        playerOScore++;
        winnerO = true;
        clearBoard();
      } else {
        playerXScore++;
        winnerX = true;
        clearBoard();
        return;
      }
    }

    // check 2nd row
    else if (listXO[3] == listXO[4] &&
        listXO[3] == listXO[5] &&
        listXO[3] != emptyImage) {
      if (listXO[3] == playerOImage) {
        playerOScore++;
        winnerO = true;
        clearBoard();
      } else {
        playerXScore++;
        winnerX = true;
        clearBoard();
        return;
      }
    }

    // check 3rd row
    else if (listXO[6] == listXO[7] &&
        listXO[6] == listXO[8] &&
        listXO[6] != emptyImage) {
      if (listXO[6] == playerOImage) {
        playerOScore++;
        winnerO = true;
        clearBoard();
      } else {
        playerXScore++;
        winnerX = true;
        clearBoard();
        return;
      }
    }

    // check 1st column
    else if (listXO[0] == listXO[3] &&
        listXO[0] == listXO[6] &&
        listXO[0] != emptyImage) {
      if (listXO[0] == playerOImage) {
        playerOScore++;
        winnerO = true;
        clearBoard();
      } else {
        playerXScore++;
        winnerX = true;
        clearBoard();
        return;
      }
    }

    // check 2nd column
    else if (listXO[1] == listXO[4] &&
        listXO[1] == listXO[7] &&
        listXO[1] != emptyImage) {
      if (listXO[1] == playerOImage) {
        playerOScore++;
        winnerO = true;
        clearBoard();
      } else {
        playerXScore++;
        winnerX = true;
        clearBoard();
        return;
      }
    }

    // check 3rd column
    else if (listXO[2] == listXO[5] &&
        listXO[2] == listXO[8] &&
        listXO[2] != emptyImage) {
      if (listXO[2] == playerOImage) {
        playerOScore++;
        winnerO = true;
        clearBoard();
      } else {
        playerXScore++;
        winnerX = true;
        clearBoard();
        return;
      }
    }

    // check diagonal
    else if (listXO[0] == listXO[4] &&
        listXO[0] == listXO[8] &&
        listXO[0] != emptyImage) {
      if (listXO[0] == playerOImage) {
        playerOScore++;
        winnerO = true;
        clearBoard();
      } else {
        playerXScore++;
        winnerX = true;
        clearBoard();
        return;
      }
    }

    // check inverse diagonal
    else if (listXO[2] == listXO[4] &&
        listXO[2] == listXO[6] &&
        listXO[2] != emptyImage) {
      if (listXO[2] == playerOImage) {
        playerOScore++;
        winnerO = true;
        clearBoard();
      } else {
        playerXScore++;
        winnerX = true;
        clearBoard();
        return;
      }
    } else if (filledBoxes == 9) {
      equal = equal + 1;
      clearBoard();
      return;
    }
  }

  void clearBoard() {
    Future.delayed(
      const Duration(seconds: 2),
      () => setState(() {
        for (int i = 0; i < listXO.length; i++) {
          listXO[i] = emptyImage;
          filledBoxes = 0;
          winnerO = false;
          winnerX = false;
        }
      }),
    );
  }

  void resetGame(double width, double height) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(width * 0.06),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Do you want to reset the game?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.01),
            Row(
              children: [
                const Spacer(),
                buildTextButton(
                  onTap: Navigator.of(context).pop,
                  width: width * 0.11,
                  height: width * 0.075,
                  text: 'No',
                ),
                SizedBox(width: width * 0.02),
                buildTextButton(
                  onTap: () {
                    setState(() {
                      for (int i = 0; i < listXO.length; i++) {
                        listXO[i] = emptyImage;
                      }
                      filledBoxes = 0;
                      winnerO = false;
                      winnerX = false;
                      playerOScore = 0;
                      playerXScore = 0;
                      equal = 0;
                    });
                    playSound(resetGameSound);
                    Navigator.of(context).pop();
                  },
                  width: width * 0.11,
                  height: width * 0.075,
                  text: 'Yes',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void toggleSound() => setState(() => isMuted = !isMuted);

  void playSound(String path) {
    final player = AudioPlayer();
    if (isMuted) {
      null;
    } else {
      player.play(AssetSource(path));
    }
  }

  void pauseGame(double width, double height) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(width * 0.06),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isPaused
                  ? 'Do you want to resume the game?'
                  : 'Do you want to pause the game?',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.01),
            Row(
              children: [
                const Spacer(),
                buildTextButton(
                  onTap: Navigator.of(context).pop,
                  width: width * 0.11,
                  height: width * 0.075,
                  text: 'No',
                ),
                SizedBox(width: width * 0.02),
                buildTextButton(
                  onTap: () {
                    setState(() => isPaused = !isPaused);
                    Navigator.of(context).pop();
                  },
                  width: width * 0.11,
                  height: width * 0.075,
                  text: 'Yes',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showWinDialog({
    required String winner,
    required double width,
    required double height,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() => playAgain = true);
              }
            });

            return AlertDialog(
              contentPadding: EdgeInsets.only(top: height * 0.05),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        margin: EdgeInsets.all(width * 0.06),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Winner: $winner',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Container(
                              width: width * 0.33,
                              height: width * 0.11,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: playAgain
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          setState(() => playAgain = false);
                                        },
                                        child: const Text(
                                          'Play Again',
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: height * 0.08,
                        left: width * 0.028,
                        child: Image.asset(
                          'assets/images/win.png',
                          scale: 0.8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
