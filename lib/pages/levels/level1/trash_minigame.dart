import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turtle/pages/tabs/acessories.dart';
import 'package:turtle/pages/tabs/tasks.dart';
import 'package:turtle/services/functions/movement.dart';
import 'package:turtle/utils/current_user.dart';
import 'package:turtle/utils/styles.dart';

import '../../../utils/image_path.dart';
import '../../../utils/level.dart';
import '../../animation/turtle_loading_screen.dart';
import 'level1_town.dart';

class TrashMinigameScreen extends StatefulWidget {
  /// Throwing trash mini game
  /// User must click button certain times to win game
  const TrashMinigameScreen({super.key});

  @override
  State<TrashMinigameScreen> createState() => _TrashMinigameScreenState();
}

class _TrashMinigameScreenState extends State<TrashMinigameScreen> {
  // Holds direction turtle is facing
  bool _right = true;

  bool _allowKeyboard = true;

  // Holds where user is currently
  int _stepCounter = 0;

  // Holds screen size -> late because will update later
  late double height = 0;
  late double width = 0;

  /*
   How many steps to cross the screen horizontally
   The lower the number the faster turtle moves
   */
  final double numSteps = 300;

  // So that the user cannot hold buttons
  List<LogicalKeyboardKey> keys = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorial(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get height of screen
    height = MediaQuery.of(context).size.height;

    // Subtracted 20 because trash can is 20 units off
    width = MediaQuery.of(context).size.width - 20;

    /*
    This is where you check if turtle goes off screen -> then you can can transition
    Not sure how to manually set where turtle is, maybe gotta make fields public
     */

    // If user reaches trash can
    if (_stepCounter == numSteps) {
      setState(() {
        _allowKeyboard = false;
        // Need this widget binding thing because
        // I'm showing an alertDialog and if I don't have this, there is an error
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _threwTrash(context);
        });
      });
    }

    // User wants to go home
    if (_stepCounter < 0) {
      setState(() {
        _stepCounter = 0;
        _allowKeyboard = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showWarning(context);
        });
      });
    }

    // Keyboard input
    return RawKeyboardListener(
      autofocus: true, // Got it from tutorial don't change
      focusNode: FocusNode(), // Got it from tutorial don't change
      onKey: (event) {
        if (_allowKeyboard) {
          // Key user pressed
          final key = event.logicalKey;

          // If user pressed button down
          if (event is RawKeyDownEvent) {
            /*
           If they are holding key -> ignore
           Can remove all key code so that they can hold button
           */
            if (keys.contains(key)) return;

            // Right arrow
            if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
              setState(() {
                _stepCounter += 1; // Moved right
                keys.add(key);
                _right = true;
              });
            }

            // Left arrow
            else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
              setState(() {
                _stepCounter -= 1;
                keys.add(key);
                _right = false;
              });
            }
          }

          // If user released key
          if (event is RawKeyUpEvent) {
            if (keys.contains(key)) {
              keys.remove(key);
            }
          }
        }
      },
      child: Scaffold(
        body: DecoratedBox(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      ImagePath.trashMinigame,
                    ),
                    fit: BoxFit.cover)),
            child: Column(
              children: [_buildTopRow(), _buildTurtleRoad()],
            )),
      ),
    );
  }

  /// Path where turtle walks
  /// <p>
  /// WHERE YOU SET TURTLE ON SCREEN
  Widget _buildTurtleRoad() {
    return Expanded(
      child: Container(
        /*
           Hard coded 0.7 in
           I tried y but it is wonky, so, will only allow user to go left and right
           */
        alignment: Alignment(
            Movement.getX(width, numSteps, _stepCounter as double), 0.7),
        child: _buildTurtle(),
      ),
    );
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

  /// Top Row
  Widget _buildTopRow() {
    return Row(
      children: [
        // Exit button
        Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(8)),
              child: FittedBox(
                child: ElevatedButton(
                    style: Styles.exitButtonStyle,
                    onPressed: () {
                      _showWarning(context);
                    },
                    child: const Text(
                      'I will litter',
                      style: TextStyle(fontSize: 15),
                    )),
              ),
            )),
        // Tutorial
        Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(8)),
              child: FittedBox(
                child: ElevatedButton(
                    style: Styles.taskButtonStyle,
                    onPressed: () {
                      _showTutorial(context);
                    },
                    child: const Text(
                      'How to Play',
                      style: TextStyle(fontSize: 15),
                    )),
              ),
            )),
        // Step Counter
        Expanded(
            flex: 3,
            child: Container(
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(8)),
                child: FittedBox(
                  child: Text(
                    'Steps to Trash: ${_getStepsToGo()}',
                    style: const TextStyle(
                        fontSize: 15, backgroundColor: Colors.brown),
                  ),
                ))),

        Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(15.0),
              child: const TaskButton(),
            )),
        Expanded(
            flex: 1,
            child: Container(
                margin: const EdgeInsets.all(15.0),
                child: const AccessoriesButton()))
      ],
    );
  }

  /// Utility method for counter sign
  double _getStepsToGo() {
    return numSteps - _stepCounter;
  }

  /// Shows an alert dialog asking user if they want to litter
  void _showWarning(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Litter?'),
              content: const Text('Are you sure?'),
              actions: [
                // Cancel Button
                TextButton(
                    onPressed: () {
                      setState(() {
                        _allowKeyboard = true;
                        Navigator.of(ctx).pop();
                      });
                    },
                    child: const Text('Never mind')),

                // Confirmation
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _litter(true);
                    },
                    child: const Text('Yes'))
              ],
            ));
  }

  /// Shows alert dialog confirming they threw the trash
  void _threwTrash(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Threw out the trash!'),
              content: const Text('So tired...Time to go home ..･ヾ(。￣□￣)ﾂ'),
              actions: [
                // Okay
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _litter(false);
                    },
                    child: const Text('Home Time!')),
              ],
            ));
  }

  /// Updates database, next goal and shows town 4
  void _litter(bool littered) {
    setState(() {
      // Update status
      CurrentUser.littered = littered;
      CurrentUser.nextGoal = Level.goHome;

      // -------- Go to Town 4------
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const TurtleLoadingScreen(
                  nextScreen: Level1TownScreen(startLeft: false))));
    });
  }

  /// Show tutorial
  void _showTutorial(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.cyan,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Column(
          children: [
            Expanded(
                flex: 4,
                child: Center(
                  child: _getInstructions(),
                )),
            Expanded(
                flex: 1,
                child: SizedBox.expand(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Close',
                    ),
                  ),
                ))
          ],
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  /// RichText of mini game instructions
  Widget _getInstructions() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(fontSize: 25, height: 2),
        children: [
          TextSpan(
              text: 'Mini game!\n',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline)),
          TextSpan(
            text: '''
            Let's throw out the trash! 
            But the trash can is so far away (〃＞＿＜;〃)
            I guess we got to walk (」＞＜)」
            
            ''',
          ),
          TextSpan(
              text: 'How To Play\n',
              style: TextStyle(decoration: TextDecoration.underline)),
          TextSpan(text: 'Use '),
          WidgetSpan(
            child: Icon(Icons.arrow_circle_right, size: 25),
          ),
          TextSpan(
            text: " and ",
          ),
          WidgetSpan(
              child: Icon(
            Icons.arrow_circle_left,
            size: 25,
          )),
          TextSpan(text: ''' to move
            Start spamming!
            Ps: Holding the buttons is not allowed (≧◡≦)
            '''),
        ],
      ),
    );
  }
}
