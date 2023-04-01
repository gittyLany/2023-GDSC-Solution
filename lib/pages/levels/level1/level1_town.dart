import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turtle/pages/levels/level1/level1_store.dart';
import 'package:turtle/pages/levels/level1/swim_minigame.dart';

import '../../../services/functions/movement.dart';
import '../../../utils/current_user.dart';
import '../../../utils/image_path.dart';
import '../../../utils/images.dart';
import '../../../utils/level.dart';
import '../../animation/turtle_loading_screen.dart';
import '../../tabs/acessories.dart';
import '../../tabs/ending_prize.dart';
import '../../tabs/tasks.dart';
import 'level1_dialog.dart';

class Level1TownScreen extends StatefulWidget {
  final bool startLeft;

  /// All town code
  /// <p>
  /// Start left -> either starts at town1 or town 4
  const Level1TownScreen({super.key, required this.startLeft});

  @override
  State<Level1TownScreen> createState() => _Level1TownScreenState();
}

class _Level1TownScreenState extends State<Level1TownScreen> {
  late int _townNum;

  // Holds direction turtle is facing
  late bool _right;

  // Holds where user is currently
  late int _stepCounter;

  // Holds screen size -> late because will update later
  late double height;
  late double width;

  /*
   How many steps to cross the screen horizontally
   The lower the number the faster turtle moves
   */
  final double numSteps = 100;

  // If can use keyboard
  bool _allowKeyboard = true;

  @override
  void initState() {
    super.initState();

    if (widget.startLeft) {
      _townNum = 1;
      _stepCounter = 30;
      _right = true;
    } else {
      _townNum = 4;
      _stepCounter = 100;
      _right = false;
    }
  }

  /// No clue was testing
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Get height of screen
    height = MediaQuery.of(context).size.height;

    // Get the width of the screen
    width = MediaQuery.of(context).size.width;

    // Exiting right side of screen
    if (_stepCounter > 107) {
      if (_townNum == 4) {
        setState(() {
          _stepCounter = 107;
        });
      } else {
        setState(() {
          _townNum++;
          _stepCounter = -37;
        });
      }
    }

    // Ocean in town 1
    if (_stepCounter < 30 && _townNum == 1) {
      setState(() {
        _allowKeyboard = false;
        _stepCounter = 30;
        // Swim mini game
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showSwimWarning(_scaffoldKey.currentContext!);
        });
      });
    }

    // Exiting left side of screen
    if (_stepCounter < -37 && _townNum != 1) {
      setState(() {
        _townNum--;
        _stepCounter = 107;
      });
    }

    // Keyboard input
    return RawKeyboardListener(
      autofocus: true, // Got it from tutorial don't change
      focusNode: FocusNode(), // Got it from tutorial don't change
      onKey: (event) {
        if (_allowKeyboard) {
          // If user pressed button down
          if (event is RawKeyDownEvent) {
            // Right arrow
            if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
              setState(() {
                _stepCounter++; // Moved right
                _right = true;
              });
            }

            // Left arrow
            else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
              setState(() {
                _stepCounter--;
                _right = false;
              });
            }
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      _getTownBackgroundPath(),
                    ),
                    fit: BoxFit.cover)),
            child: Column(
              children: [_buildTopRow(), _buildTurtleRoad()],
            )),
      ),
    );
  }

  /// Top Row
  Widget _buildTopRow() {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        // Accessory button
        Container(
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(8)),
            child: const AccessoriesButton()),

        // Task display
        Container(
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(8)),
            child: const TaskButton()),
      ],
    );
  }

  /// Path where turtle walks
  /// <p>
  /// WHERE YOU SET TURTLE ON SCREEN
  Widget _buildTurtleRoad() {
    return Expanded(child: _buildRoom());
  }

  /// Turtle Image
  Widget _buildTurtle() {
    return SizedBox(
      // Hard coded size
      height: height / 3,

      // Looking direction
      child: _right ? CurrentUser.turtleWalkRight : CurrentUser.turtleWalkLeft,
    );
  }

  /// Sets up room based on number
  Widget _buildRoom() {
    if (_townNum == 1) {
      return Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment(
                  Movement.getX(width, numSteps, _stepCounter as double), 0.8),
              child: _buildTurtle(),
            ),
          )
        ],
      );
    } else if (_townNum == 3) {
      return _buildTown3();
    } else if (_townNum == 2) {
      return _buildTown2();
    } else {
      return _buildTown4();
    }
  }

  /// Penguin npc who gives flower accessory
  Widget _buildTown2() {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            _buildPenguin(),
            // Turtle
            Container(
              alignment: Alignment(
                  Movement.getX(width, numSteps, _stepCounter as double), 0.8),
              child: _buildTurtle(),
            ),
          ],
        ))
      ],
    );
  }

  /// Penguin
  Widget _buildPenguin() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(0.2, 0.5),
            child: FractionallySizedBox(
              widthFactor: 0.35,
              heightFactor: 0.35,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: () {
                    Level1Dialog.showPenguinDialog(
                        _scaffoldKey.currentContext!);
                  },
                  child: AppImages.penguin,
                ),
              ),
            )));
  }

  /// Clownfish npc who tells jokes
  Widget _buildTown3() {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            _buildClownFish(),
            // Turtle
            Container(
              alignment: Alignment(
                  Movement.getX(width, numSteps, _stepCounter as double), 0.8),
              child: _buildTurtle(),
            ),
          ],
        ))
      ],
    );
  }

  /// Clownfish
  Widget _buildClownFish() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(-0.2, 0.4),
            child: FractionallySizedBox(
              widthFactor: 0.3,
              heightFactor: 0.3,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: () {
                    Level1Dialog.showClownFishDialog(
                        _scaffoldKey.currentContext!);
                  },
                  child: AppImages.clownFish,
                ),
              ),
            )));
  }

  /// Grocery store
  Widget _buildTown4() {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            // Turtle
            Container(
              alignment: Alignment(
                  Movement.getX(width, numSteps, _stepCounter as double), 0.8),
              child: _buildTurtle(),
            ),
            CurrentUser.nextGoal == Level.goToStore
                ? _buildGroceryStore()
                : Container()
          ],
        ))
      ],
    );
  }

  /// Build clickable grocery store
  Widget _buildGroceryStore() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(-1, -0.25),
            child: FractionallySizedBox(
              widthFactor: 0.75,
              heightFactor: 0.45,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: () {
                    CurrentUser.nextGoal = Level.buyFood;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TurtleLoadingScreen(
                                nextScreen: Level1StoreScreen())));
                  },
                ),
              ),
            )));
  }

  /// Returns background image depending on _townNum
  String _getTownBackgroundPath() {
    if (_townNum == 1) {
      return ImagePath.town1;
    } else if (_townNum == 2) {
      return ImagePath.town2;
    } else if (_townNum == 3) {
      return ImagePath.town3;
    }
    return ImagePath.town4;
  }

  /// Ask user if they want to go back home
  void _showSwimWarning(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Go Back Home?'),
              content: const Text('Are you sure?'),
              actions: [
                // Cancel Button
                TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(ctx).pop();
                        _allowKeyboard = true;
                      });
                    },
                    child: const Text('Never mind')),

                // Confirmation
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      CurrentUser.nextGoal == Level.goToStore
                          ? _toSwimGame(context)
                          : _endLevel(context);
                    },
                    child: const Text('Yes'))
              ],
            ));
  }

  /// To swim mini-game
  void _toSwimGame(BuildContext context) {
    TextFileReader.setRandomText();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const TurtleLoadingScreen(
                  nextScreen: SwimMinigameScreen(startLeft: false),
                )));
  }

  /// End level and update stats
  void _endLevel(BuildContext context) {
    PrizePicker.showMenu(context, 1);
  }
}
