import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_snake_game/food_pixel.dart';
import 'package:new_snake_game/high_score_tile.dart';
import 'package:new_snake_game/snake_pixel.dart';

import 'blank_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum SnakeDirection { left, right, up, down }

class _HomePageState extends State<HomePage> {
  // grid dimensions
  int rowSize = 10;
  int totalNumberOfSquares = 100;

  // snake figure
  var snakeList = [0, 1, 2];

  // food Figure
  int foodSqure = 56;

  // current Score
  int currentScore = 0;

  // has game started
  bool gameStarted = false;

  // snake current direction is to right
  var currentDirection = SnakeDirection.right;

  // name controller
  final _nameController = TextEditingController();

  // creating the list of all the doc Ids available i.e all the records available

  List<String> highScore_DocIds = [];
  late final Future? letsGetDocIds;

  @override
  void initState() {
    letsGetDocIds = getDocIds();
    super.initState();
  }

  Future getDocIds() async {
    await FirebaseFirestore.instance
        .collection('highscores')
        .orderBy('score', descending: true)
        .limit(10)
        .get()
        .then((value) => value.docs.forEach((element) {
              highScore_DocIds.add(element.reference.id);
            }));
  }

  // start the game
  void startGame() {
    gameStarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();

        if (gameOver()) {
          timer.cancel();
          // print('GameFinished !!!!');
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Game Over'),
                  content: Column(
                    children: [
                      Text('Your Score: ' + currentScore.toString()),
                      TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              hintText: 'Enter your name')),
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        submitScore();
                        Navigator.pop(context);
                        newGame();
                      },
                      color: Colors.orange[200],
                      child: const Text('Submit'),
                    )
                  ],
                );
              });
        }
      });
    });
  }

  void submitScore() {
    //creating the databse
    // hooking up the collection with game data
    var database = FirebaseFirestore.instance;
    database.collection('highscores').add({
      'name': _nameController.text,
      'score': currentScore,
    });
  }

  Future newGame() async {

    highScore_DocIds = [];
    await getDocIds();

    setState(() {
      snakeList = [0, 1, 2];
      foodSqure = 56;
      gameStarted = false;
      currentDirection = SnakeDirection.right;
      currentScore = 0;
    });
  }

  void moveSnake() {
    switch (currentDirection) {
      case SnakeDirection.right:
        // add new head (adding one int to last int)
        // Now once the head is at the last column then need to make it infinetly put snake in that row only
        if (snakeList.last % rowSize == 9) {
          // it means snake head is at last column
          snakeList.add(snakeList.last + 1 - rowSize);
        } else {
          snakeList.add(snakeList.last + 1);
        }

        break;

      case SnakeDirection.left:
        if (snakeList.last % rowSize == 0) {
          // it means snake head is at last column
          snakeList.add(snakeList.last - 1 + rowSize);
        } else {
          snakeList.add(snakeList.last - 1);
        }

        break;

      case SnakeDirection.up:

        // add new head (adding one int to last int)
        if (snakeList.last < rowSize) {
          snakeList.add(snakeList.last - rowSize + totalNumberOfSquares);
        } else {
          snakeList.add(snakeList.last - rowSize);
        }

        break;

      case SnakeDirection.down:

        // add new head (adding one int to last int)
        if (snakeList.last + rowSize > totalNumberOfSquares) {
          snakeList.add(snakeList.last + rowSize - totalNumberOfSquares);
        } else {
          snakeList.add(snakeList.last + rowSize);
        }

        break;

      default:
    }

    if (snakeList.last == foodSqure) {
      eatFood();
    } else {
      // remove the tail (tail means the inital num in list)
      snakeList.removeAt(0);
    }
  }

  void eatFood() {
    // incrementing the score
    currentScore++;

    // making sure the new food is not where the snake is
    while (snakeList.contains(foodSqure)) {
      foodSqure = Random().nextInt(totalNumberOfSquares);
    }
  }

  bool gameOver() {
    // game over will happen once the duplicate value is present inside the snakeList
    //This is the list of the snake which contain only body

    // this new list contains the same list except the head
    List<int> snakeBody = snakeList.sublist(0, snakeList.length - 1);

    if (snakeBody.contains(snakeList.last)) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    // identifying the width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event){
          if(event.isKeyPressed(LogicalKeyboardKey.arrowUp) && currentDirection != SnakeDirection.down)
          {
            currentDirection = SnakeDirection.up;
          }
          else if(event.isKeyPressed(LogicalKeyboardKey.arrowDown)  && currentDirection != SnakeDirection.up)
          {
             currentDirection = SnakeDirection.down;
          }
          else if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)  && currentDirection != SnakeDirection.right)
          {
            currentDirection = SnakeDirection.left;
          }
          else if(event.isKeyPressed(LogicalKeyboardKey.arrowRight) && currentDirection != SnakeDirection.left)
          {
            currentDirection = SnakeDirection.right;
          }
        },
        child: SizedBox(
          width: screenWidth > 428 ? 428 : screenWidth,
          child: Column(children: [
            Expanded(
              // this is for the score and high scores
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // user score
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Your Score is:',
                          style: TextStyle(fontSize: 20),
                        ),
                  
                        const SizedBox(height: 10),
                  
                        Text(currentScore.toString()),
                  
                        // +
                      ],
                    ),
                  ),
      
                  // top 5 scores
      
                  Expanded(
                    child:gameStarted ? Container() :  FutureBuilder(
                      future: letsGetDocIds,
                      builder: (context, snapshot) {
                      
                      return ListView.builder(
                        itemCount: highScore_DocIds.length,
                        itemBuilder: (context, index) {
                        return HighScoreTile(docId: highScore_DocIds[index]);
                      });
                    }),
                  ),
      
                  // +
                ],
              ),
            ),
            Expanded(
              //  this is for the actual grid
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (direction) {
                  if (direction.delta.dy > 0 &&
                      currentDirection != SnakeDirection.up) {
                    print('moving down ');
                    currentDirection = SnakeDirection.down;
                  } else if (direction.delta.dy < 0 &&
                      currentDirection != SnakeDirection.down) {
                    print('moving up ');
                    currentDirection = SnakeDirection.up;
                  }
                },
                onHorizontalDragUpdate: (direction) {
                  if (direction.delta.dx > 0 &&
                      currentDirection != SnakeDirection.left) {
                    print('moving right ');
                    currentDirection = SnakeDirection.right;
                  } else if (direction.delta.dx < 0 &&
                      currentDirection != SnakeDirection.right) {
                    print('moving left ');
                    currentDirection = SnakeDirection.left;
                  }
                },
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      // crossAxisSpacing: 4,
                      // mainAxisSpacing: 4,
                      crossAxisCount: rowSize,
                    ),
                    itemCount: totalNumberOfSquares,
                    itemBuilder: (context, index) {
                      // return
      
                      if (snakeList.contains(index)) {
                        return const SnakePixel();
                      } else if (index == foodSqure) {
                        return const FoodPixel();
                      } else {
                        return const BlankPixel();
                      }
                    }),
              ),
            ),
            Expanded(
              //  play button
              child: Column(
                children: [
                  Center(
                      child: MaterialButton(
                    onPressed: gameStarted ? () {} : startGame,
                    color: gameStarted ? Colors.grey : Colors.purple,
                    child: const Text('Play'),
                  )),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

// step 1 - created the layout
// created the start game method to start the game using Timer
// used logic of removing tail and adding new head (just plus one to the last element and deleting the last one )
// Hense the snake is moving

// step 2 -
// added the gesture detector to identify which direction user is moving
// added the logic to make a snake move in only three possible ways
// Then readjusted the movement of snake to the same row continuesly or same column continuesly

// step 3 -
//Imp - previously we have deleted the tail every point of the time But we can do one quick thing here
//Simply remove the tail only when we haven't found the food else remove it

// step 4
// create the score varible
// display the score and increment the score

// step 5
// Time to link the project to the firebase to make it globally accessible
