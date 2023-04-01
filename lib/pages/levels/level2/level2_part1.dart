import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turtle/pages/animation/turtle_loading_screen.dart';
import 'package:turtle/pages/levels/level2/level2_dialog.dart';
import 'package:turtle/pages/levels/level2/level2_part2.dart';
import 'package:turtle/pages/tabs/tasks.dart';
import 'package:turtle/utils/images.dart';

import '../../../services/functions/movement.dart';
import '../../../utils/current_user.dart';
import '../../../utils/image_path.dart';
import '../../tabs/acessories.dart';

/// Turtle arrives from grocery store
class Level2Part1Screen extends StatefulWidget {
  /// Walking in house + talking to mom
  const Level2Part1Screen({super.key});

  @override
  State<Level2Part1Screen> createState() => _Level2Part1State();
}

/// All house code
class _Level2Part1State extends State<Level2Part1Screen> {
  // Holds screen size -> late because will update later
  late double height = 0;
  late double width = 0;

  // Holds direction turtle is facing
  bool _right = false;

  // Holds where user is currently
  int _stepCounter = 100;

  // Which house frame we are on
  int _houseNum = 4;

  /*
   How many steps to cross the screen horizontally
   The lower the number the faster turtle moves
   */
  final double numSteps = 100;

  @override
  Widget build(BuildContext context) {
    // Get height of screen
    height = MediaQuery.of(context).size.height;

    // Subtracted 20 because trash can is 20 units off
    width = MediaQuery.of(context).size.width;

    // Exiting right side of screen
    if (_stepCounter > 107) {
      // Cannot leave house
      if (_houseNum == 4) {
        setState(() {
          _stepCounter = 107;
        });
      } else {
        setState(() {
          _houseNum++;
          _stepCounter = -37;
        });
      }
    }

    if (_stepCounter < 62 && _houseNum == 1) {
      setState(() {
        _stepCounter = 62;
      });
    }

    // Exiting left side of screen
    if (_stepCounter < -37 && _houseNum != 1) {
      setState(() {
        _houseNum--;
        _stepCounter = 107;
      });
    }

    // Keyboard input
    return RawKeyboardListener(
      autofocus: true, // Got it from tutorial don't change
      focusNode: FocusNode(), // Got it from tutorial don't change
      onKey: (event) {
        // If user pressed button down
        if (event is RawKeyDownEvent) {
          // Right arrow
          if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            setState(() {
              _stepCounter += 1; // Moved right
              _right = true;
            });
          }

          // Left arrow
          else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            setState(() {
              _stepCounter -= 1;
              _right = false;
            });
          }
        }
      },
      child: Scaffold(
        body: DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      _getHouseBackgroundPath(),
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
    if (_houseNum == 2 || _houseNum == 4) {
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
    } else if (_houseNum == 3) {
      return _buildRoom3();
    } else {
      return _buildRoom1();
    }
  }

  /// Cap and bag found here
  Widget _buildRoom3() {
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

            CurrentUser.hasReusableBag ? Container() : _buildReusableBag(),

            CurrentUser.capUnlocked ? Container() : _buildCap()
          ],
        ))
      ],
    );
  }

  /// Reusable bag
  Widget _buildReusableBag() {
    return Positioned.fill(
        child: Align(
      alignment: const Alignment(-0.55, -0.52),
      child: FractionallySizedBox(
        widthFactor: 0.4,
        heightFactor: 0.4,
        child: AppImages.reusableBag,
      ),
    ));
  }

  /// Cap on home 3
  Widget _buildCap() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(0.35, -0.72),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FractionallySizedBox(
                widthFactor: 0.1,
                heightFactor: 0.1,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      CurrentUser.capUnlocked = true;
                      _showCapUnlock(context);
                    });
                  },
                  child: AppImages.cap,
                ),
              ),
            )));
  }

  /// Show message that the cap has been unlocked
  void _showCapUnlock(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          child: Column(
            children: [
              const Expanded(
                child: FittedBox(
                    child: Text(
                  'Cap Unlocked!',
                  style: TextStyle(
                      backgroundColor: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                )),
              ),
              Expanded(
                  flex: 3,
                  child: Center(
                    child: AppImages.cap,
                  )),
              Expanded(
                  flex: 1,
                  child: SizedBox.expand(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Yay',
                      ),
                    ),
                  ))
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  /// Mom turtle
  Widget _buildRoom1() {
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
            _buildMomTurtle()
          ],
        ))
      ],
    );
  }

  /// Mom
  Widget _buildMomTurtle() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(-0.65, 0.85),
            child: FractionallySizedBox(
              widthFactor: 0.4,
              heightFactor: 0.6,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showEndingMessage(context);
                    });
                  },
                  child: AppImages.momTurtle,
                ),
              ),
            )));
  }

  /// Returns background image depending on _houseNum
  String _getHouseBackgroundPath() {
    if (_houseNum == 1) {
      return ImagePath.home1;
    } else if (_houseNum == 2) {
      return ImagePath.home2;
    } else if (_houseNum == 3) {
      return ImagePath.home3;
    }
    return ImagePath.home4;
  }

  /// Ask user if they are ready for dinner
  void _showEndingMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Welcome Back!'),
              content: const Text('Are you ready for dinner?'),
              actions: [
                // Cancel Button
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Gimme a sec')),

                // Confirmation
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Level2Dialog.refreshList();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TurtleLoadingScreen(
                                  nextScreen: Level2Part2Screen())));
                    },
                    child: const Text('Yes'))
              ],
            ));
  }
}
