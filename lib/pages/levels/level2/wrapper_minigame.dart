import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/image_path.dart';
import '../../../utils/images.dart';
import '../../../utils/styles.dart';
import '../../animation/turtle_loading_screen.dart';
import 'level2_part5.dart';

class WrapperMinigameScreen extends StatefulWidget {
  /// Memorization game
  const WrapperMinigameScreen({super.key});

  @override
  State<WrapperMinigameScreen> createState() => _WrapperMinigameState();
}

class _WrapperMinigameState extends State<WrapperMinigameScreen> {
  /// How many lives user has
  int _lives = 3;

  /// Steps to complete for round
  int _stepsToComplete = 1;

  /// Where we are
  int _stepsCounter = 0;

  /// If bird is on the screen
  GameState _gameState = GameState.watch;

  /// Which arrow is flashing
  Arrow _flashArrow = Arrow.none;

  /// Determines if button should be shown
  bool _isButtonPressed = false;

  /// Determines when to start game
  bool _timerEnded = false;

  /// Keeps track when game is over
  bool _gameOver = false;

  /// Determines if accepting keyboard input
  bool _allowInput = true;

  /// Timer text
  int _timerCountdown = 4;

  /// Keeps track of how long 'Correct' is displayed
  int _correctCountdown = 1;

  /// Keeps track how long 'Wrong' is displayed
  int _wrongCountdown = 1;

  /// Timer
  late Timer _countdownTimer;

  late Timer _roundTimer;

  /// Controls flashing of arrows
  late Timer _arrowFlasherTimer;

  /// Timer to show 'Correct'
  late Timer _correctTimer;

  /// Timer to show 'Wrong'
  late Timer _wrongTimer;

  @override
  void dispose() {
    _countdownTimer.cancel();
    _correctTimer.cancel();
    _roundTimer.cancel();
    _wrongTimer.cancel();
    _arrowFlasherTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorial(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // No more lives
    if (_lives == 0 && !_gameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _allowInput = false;
          _roundTimer.cancel();
          _wrongTimer.cancel();
          _gameOver = true;
          _endGame(context, true);
        });
      });
    }

    // Completed 10 steps
    if (_stepsToComplete > 10 && _gameState == GameState.watch && !_gameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _allowInput = false;
          _roundTimer.cancel();
          _correctTimer.cancel();
          _gameOver = true;
          _endGame(context, false);
        });
      });
    }

    // User successfully entered correct sequence -> show Correct message
    if (_stepsCounter == _stepsToComplete &&
        _gameState == GameState.respond &&
        !_gameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _gameState = GameState.correct;
          _showCorrectTitle();
        });
      });
    }

    // Keyboard input
    return RawKeyboardListener(
      autofocus: true, // Got it from tutorial don't change
      focusNode: FocusNode(), // Got it from tutorial don't change
      onKey: (event) {
        // User pressed key during respond stage
        if (_allowInput && _gameState == GameState.respond) {
          _handleKeyEvent(event);
        }
      },
      child: Scaffold(
        body: DecoratedBox(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      ImagePath.wrapperMinigame,
                    ),
                    fit: BoxFit.cover)),
            child: Column(
              children: [_buildTopRow(), _buildBottom()],
            )),
      ),
    );
  }

  /// Arrow flashing method
  void flashArrow(Arrow arrow) {
    _arrowFlasherTimer =
        Timer.periodic(const Duration(milliseconds: 250), (timer) {
      // No arrow is flashing, so flash arrow
      if (_flashArrow == Arrow.none) {
        setState(() {
          _flashArrow = arrow;
        });
      }

      // Arrow is currently lit -> so return arrow back to normal + end timer
      else {
        setState(() {
          _allowInput = true;
          _flashArrow = Arrow.none;
          _arrowFlasherTimer.cancel();
        });
      }
    });
  }

  /// Checks if key pressed matches arrow
  bool match(LogicalKeyboardKey key, Arrow arrow) {
    return _logicalKeyToArrow(key) == arrow;
  }

  /// Converts key pressed to arrow direction
  /// <p>
  /// If an arrow key is not pressed, will return Arrow.none
  Arrow _logicalKeyToArrow(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.arrowLeft) {
      return Arrow.left;
    } else if (key == LogicalKeyboardKey.arrowRight) {
      return Arrow.right;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      return Arrow.up;
    } else if (key == LogicalKeyboardKey.arrowDown) {
      return Arrow.down;
    }
    return Arrow.none;
  }

  /// Show 'Correct' on screen for 1 sec
  void _showCorrectTitle() {
    _correctTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Stop timer
      if (_correctCountdown == 0) {
        setState(() {
          _correctTimer.cancel();
          _correctCountdown = 1;
          _gameState = GameState.watch;
          _stepsToComplete++; // Increase number of flashes in sequence
          _stepsCounter = 0; // Reset back to 0
          _showSequence();
        });
      } else {
        setState(() {
          _correctCountdown--;
        });
      }
    });
  }

  /// Show 'Wrong' on screen for 1 sec
  void _showWrongTitle() {
    _wrongTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Stop timer
      if (_wrongCountdown == 0) {
        setState(() {
          _wrongTimer.cancel();
          _wrongCountdown = 1;
          _gameState = GameState.watch;
          _showSequence();
        });
      } else {
        setState(() {
          _wrongCountdown--;
        });
      }
    });
  }

  /// Handles when user clicks arrow keys
  void _handleKeyEvent(RawKeyEvent event) {
    LogicalKeyboardKey key = event.logicalKey;

    // User pressed correct key
    if (match(key, GameGenerator.game[_stepsCounter])) {
      setState(() {
        _allowInput = false;
        flashArrow(_logicalKeyToArrow(key));
        _stepsCounter++;
      });
    }

    // Wrong key
    else {
      setState(() {
        _allowInput = false;
        flashArrow(_logicalKeyToArrow(key));
        _stepsCounter = 0;
        _gameState = GameState.incorrect;
        _lives--;
        _showWrongTitle();
      });
    }
  }

  /// Starts timer to start game
  void _startCountdown() {
    // Button has been pressed
    setState(() {
      _isButtonPressed = true;
    });

    const oneSec = Duration(seconds: 1);

    // Start timer
    _countdownTimer = Timer.periodic(oneSec, (timer) {
      // Reached end of timer
      if (_timerCountdown == 0) {
        setState(() {
          _countdownTimer.cancel();
          _timerEnded = true;
          _showSequence();
        });
      } else {
        setState(() {
          _timerCountdown--;
        });
      }
    });
  }

  /// Game shows sequence of buttons to press
  void _showSequence() {
    if (!_gameOver) {
      _roundTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        // No arrow is flashing -> so flash arrow
        if (_flashArrow == Arrow.none) {
          // Reached end of steps to flash
          if (_stepsToComplete == _stepsCounter) {
            setState(() {
              _stepsCounter = 0; // Reset step
              _gameState = GameState.respond;
              _flashArrow = Arrow.none;
              _roundTimer.cancel();
            });
          }

          // Flash next arrow
          else {
            setState(() {
              _flashArrow = GameGenerator.game[_stepsCounter];
            });
          }
        }

        // An arrow is flashing -> reset arrow (pause in game)
        // Also go to next step
        else {
          setState(() {
            _flashArrow = Arrow.none;
            _stepsCounter++;
          });
        }
      });
    }
  }

  /// Bottom of screen
  Widget _buildBottom() {
    return Expanded(
        child: _isButtonPressed ? _buildGamePanel() : _buildStartButton());
  }

  /// Container to hold starting button
  Widget _buildStartButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _startCountdown();
        },
        style: Styles.taskButtonStyle,
        child: const Text('Start Game'),
      ),
    );
  }

  /// Center of screen
  Widget _buildGamePanel() {
    return Column(
      children: [
        // Up arrow
        Expanded(
            child: Center(
          child: _buildArrow(Arrow.up),
        )),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildArrow(Arrow.left),
            AppImages.wrapper,
            _buildArrow(Arrow.right)
          ],
        )),
        Expanded(
            child: Center(
          child: _buildArrow(Arrow.down),
        ))
      ],
    );
  }

  /// Arrows on screen
  Widget _buildArrow(Arrow dir) {
    Image image;

    if (dir == Arrow.up) {
      image = AppImages.upArrow;
    } else if (dir == Arrow.right) {
      image = AppImages.rightArrow;
    } else if (dir == Arrow.down) {
      image = AppImages.downArrow;
    } else {
      image = AppImages.leftArrow;
    }

    return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 3),
            color: dir == _flashArrow
                ? (_gameState == GameState.incorrect
                    ? Colors.pink
                    : Colors.cyan)
                : null),
        child: image);
  }

  /// Life bar found top left
  List<Widget> _buildLifeBar() {
    List<Widget> list = List<Widget>.filled(
        _lives,
        const Icon(
          Icons.favorite_outlined,
          color: Colors.pink,
        ));
    return list;
  }

  /// Top row of screen
  Widget _buildTopRow() {
    return Row(
      children: [
        // Life bar
        Expanded(
            flex: 1,
            child: Container(
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _buildLifeBar(),
                ))),

        // Main Screen/text
        Expanded(
            flex: 3,
            child: Container(
                height: 75,
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(8)),
                child: FittedBox(
                    child: _timerEnded
                        ? _getDisplaySentence()
                        : _getTimerText()))),

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
      ],
    );
  }

  /// Sentence displayed in box
  Widget _getDisplaySentence() {
    String text = '';

    if (_gameState == GameState.correct) {
      text = 'Correct!';
    } else if (_gameState == GameState.incorrect) {
      text = 'Incorrect: Try Again!';
    } else if (_gameState == GameState.respond) {
      text = 'Your turn!';
    } else {
      text = 'Watch Carefully!';
    }

    return Text(text);
  }

  /// Show dialog to end game
  void _endGame(BuildContext context, bool badEnd) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(badEnd
                  ? 'Wind Unexpectedly Dies'
                  : 'Wind is Surprisingly Strong'),
              content: Text(badEnd
                  ? 'Wrapper is falling... I wonder where? Somewhere close I bet'
                  : 'Completed all 10 levels, secret prize...coming soon, wrapper blown to other side of the world'),
              actions: [
                // Okay
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TurtleLoadingScreen(
                                  nextScreen: Level2Part5Screen())));
                    },
                    child: Text(badEnd
                        ? '*huff* *puff*'
                        : 'Easy Peasy, Lemon Squeezy')),
              ],
            ));
  }

  /// Countdown text
  Widget _getTimerText() {
    return Text(_timerCountdown == 4 ? ' ' : '$_timerCountdown',
        style: const TextStyle(fontSize: 15));
  }

  /// Shows general dialog of instructions
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
            Look at this wrapper! (¬‿¬ )
            It's flying in the wind!
            Where is it going? (≖ლ≖๑ )ﾌ
            
            ''',
          ),
          TextSpan(
              text: 'How To Play\n',
              style: TextStyle(decoration: TextDecoration.underline)),
          TextSpan(text: '''
          Watch the flashing arrows
          Press '''),
          WidgetSpan(
            child: Icon(Icons.arrow_circle_right, size: 25),
          ),
          WidgetSpan(
            child: Icon(Icons.arrow_circle_left, size: 25),
          ),
          WidgetSpan(
            child: Icon(Icons.arrow_circle_down, size: 25),
          ),
          WidgetSpan(
            child: Icon(Icons.arrow_circle_up, size: 25),
          ),
          TextSpan(text: ''' in the correct order!
            P.S There are 10 rounds...secret prize 
            if you can complete the 10th round! ( : ౦ ‸ ౦ : )
            ''')
        ],
      ),
    );
  }
}

/// Generates the arrow order
class GameGenerator {
  static List<Arrow> game = List<Arrow>.filled(10, Arrow.down);

  /// Generates a new arrow order
  static void generateNewGame() {
    var rng = Random();

    for (int i = 0; i < 10; i++) {
      int num = rng.nextInt(4);

      if (num == 0) {
        game[i] = Arrow.down;
      } else if (num == 1) {
        game[i] = Arrow.right;
      } else if (num == 2) {
        game[i] = Arrow.up;
      } else {
        game[i] = Arrow.left;
      }
    }
  }
}

enum GameState { correct, incorrect, watch, respond }

enum Arrow { left, right, up, down, none }
