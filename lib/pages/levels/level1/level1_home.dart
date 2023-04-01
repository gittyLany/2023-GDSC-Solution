import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turtle/pages/levels/level1/level1_dialog.dart';
import 'package:turtle/pages/levels/level1/swim_minigame.dart';
import 'package:turtle/utils/current_user.dart';
import 'package:turtle/services/functions/movement.dart';
import 'package:turtle/utils/images.dart';
import 'package:turtle/utils/styles.dart';
import 'package:turtle/pages/tabs/tasks.dart';

import '../../../utils/image_path.dart';
import '../../../utils/level.dart';
import '../../animation/turtle_loading_screen.dart';
import '../../tabs/acessories.dart';

class Level1HomeScreen extends StatefulWidget {
  final bool startLeft;
  final bool showStartingMessage;

  /// All house code in level 1
  const Level1HomeScreen(
      {super.key, required this.startLeft, required this.showStartingMessage});

  @override
  State<Level1HomeScreen> createState() => _Level1HomeScreenState();
}

class _Level1HomeScreenState extends State<Level1HomeScreen> {
  late int _houseNum;

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

  // If user can use keyboard
  bool _allowKeyboard = true;

  @override
  void initState() {
    super.initState();

    // Places turtle
    if (widget.startLeft) {
      _houseNum = 1;
      _stepCounter = 37;
      _right = true;
    } else {
      _houseNum = 4;
      _stepCounter = 100;
      _right = false;
    }

    if (widget.showStartingMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startNarration(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get height of screen
    height = MediaQuery.of(context).size.height;

    // Get the width of the screen
    width = MediaQuery.of(context).size.width;

    // Exiting right side of screen
    if (_stepCounter > 107) {
      if (_houseNum == 4) {
        // Cannot leave house without talking to mom
        if (CurrentUser.nextGoal == Level.talkToMom) {
          setState(() {
            _stepCounter = 107;
          });
        }
        // To swim mini game
        else {
          setState(() {
            _allowKeyboard = false;
            _stepCounter = 107;
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await TextFileReader.setRandomText();
              if (context.mounted) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TurtleLoadingScreen(
                            nextScreen: SwimMinigameScreen(startLeft: true))));
              }
            });
          });
        }
        // Not home4
      } else {
        setState(() {
          _houseNum++;
          _stepCounter = -37;
        });
      }
    }

    // Counter in house 1
    if (_stepCounter < 16 && _houseNum == 1) {
      setState(() {
        _stepCounter = 16;
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
    if (_houseNum == 1 || _houseNum == 4) {
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
      return _buildRoom2();
    }
  }

  /// Mom turtle found in home 2
  Widget _buildRoom2() {
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

  /// Mom Turtle
  Widget _buildMomTurtle() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(-0.9, 0),
            child: FractionallySizedBox(
              widthFactor: 0.35,
              heightFactor: 0.35,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: () {
                    Level1Dialog.showMomDialog(context);
                  },
                  child: AppImages.momTurtle,
                ),
              ),
            )));
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

  /// Reusable bag on home 3
  Widget _buildReusableBag() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(-0.55, -0.52),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FractionallySizedBox(
                widthFactor: 0.4,
                heightFactor: 0.4,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _claimBag(context);
                    });
                  },
                  child: AppImages.reusableBag,
                ),
              ),
            )));
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
                child: InkWell(
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

  /// Show message that user has reusable bag
  void _showBagUnlock(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          child: Column(
            children: [
              Expanded(
                child: FittedBox(
                    child: Text(
                  'Obtained Reusable Bag!',
                  style: Styles.unlockStyle,
                )),
              ),
              Expanded(
                  flex: 3,
                  child: Center(
                    child: AppImages.reusableBag,
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

  /// Show message that the cap has been unlocked
  void _showCapUnlock(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          child: Column(
            children: [
              Expanded(
                child: FittedBox(
                    child: Text(
                  'Cap Unlocked!',
                  style: Styles.unlockStyle,
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

  /// User clicked on the reusable bag: they get the option to take it with them or not
  void _claimBag(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('A Reusable Bag'),
              content: const Text('Do you wish to take the bag with you?'),
              actions: [
                // Take the bag
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      CurrentUser.hasReusableBag = true;
                      setState(() {
                        _showBagUnlock(context);
                      });
                    },
                    child: const Text('Yes')),

                // Don't take the bag
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('No')),
              ],
            ));
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

  /// The narration to introduce the game
  void _startNarration(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text(
                  'Welcome! This is your home. Let us journey through a day in your life.'),
              content: const Text(
                  'First, let\'s go find your mom! She wants to speak with you.'),
              actions: [
                // Close message
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text(
                        ' Let us get started! (Use arrow keys to move)')),
              ],
            ));
  }
}
