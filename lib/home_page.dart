// ignore_for_file: unnecessary_import

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/food_pixel.dart';
import 'package:snake_game/snake_pixel.dart';

import 'blank_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  int numberOfSquares = 100;

  int rowSize = 10;
  // User score
  int currentScore = 0;

  List<int> snakePos = [
    0,
    1,
    2,
  ];
  // snake direction is intially to the right
  var currentDirection = snake_Direction.RIGHT;

  int foodPos = 55;
  // Start the game
  void startGame() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        // keep the snake moving
        moveSnake();
        // check if the game is over
        if (gameOver()) {
          timer.cancel();
          // Display a message to ther user
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Game Over '),
                  content: Text('Your score is:' + currentScore.toString()),
                );
              });
        }
      });
    });
  }

  void eatFood() {
    currentScore++;
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(numberOfSquares);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          // Add a new head
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }

        break;
      case snake_Direction.LEFT:
        {
          // Add a new head
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;
      case snake_Direction.UP:
        {
          // Add a new head
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + numberOfSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snake_Direction.DOWN:
        {
          // Add a new head
          if (snakePos.last + rowSize > numberOfSquares) {
            snakePos.add(snakePos.last + rowSize - numberOfSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
      default:
    }
    // snake is eating food
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  // Game over
  bool gameOver() {
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);
    if (bodySnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('current score'),
                    Text(
                      currentScore.toString(),
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                const Text('Highscores....'),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 &&
                    currentDirection != snake_Direction.UP) {
                  currentDirection = snake_Direction.DOWN;
                } else if (details.delta.dy < 0 &&
                    currentDirection != snake_Direction.DOWN) {
                  currentDirection = snake_Direction.UP;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 &&
                    currentDirection != snake_Direction.LEFT) {
                  currentDirection = snake_Direction.RIGHT;
                } else if (details.delta.dx < 0 &&
                    currentDirection != snake_Direction.RIGHT) {
                  currentDirection = snake_Direction.LEFT;
                }
              },
              child: GridView.builder(
                itemCount: numberOfSquares,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowSize,
                ),
                itemBuilder: (context, index) {
                  if (snakePos.contains(index)) {
                    return const SnakePixel();
                  } else if (foodPos == index) {
                    return const FoodPixel();
                  } else {
                    return const BlankPixel();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: MaterialButton(
                color: Colors.pink,
                onPressed: startGame,
                child: const Text('PLAY'),
              ),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
