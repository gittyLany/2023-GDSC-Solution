import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turtle/pages/levels/level1/level1_town.dart';
import 'package:turtle/pages/tabs/tasks.dart';

import '../../../utils/current_user.dart';
import '../../../utils/image_path.dart';
import '../../../utils/styles.dart';
import '../../tabs/acessories.dart';
import 'level1_home.dart';

class SwimMinigameScreen extends StatefulWidget {
  final bool startLeft;

  /// IMPORTANT: Call TextFileReader.setRandomText before calling SwimMinigameScreen
  /// <p>
  /// Ex: TextFileReader.setRandomText(); THEN Navigator.push...
  /// <p>
  /// startLeft -> pass true if turtle starts at left side of screen, false if starts at the right side of screen
  const SwimMinigameScreen({super.key, required this.startLeft});

  @override
  State<SwimMinigameScreen> createState() => _SwimMiniGameState();
}

class _SwimMiniGameState extends State<SwimMinigameScreen> {
  /// Text field
  final controller = TextEditingController();

  /// Screen height
  late double height;

  /// Determines if button should be shown
  bool _isButtonPressed = false;

  /// Determines when to start game
  bool _timerEnded = false;

  // Coordinates of turtle
  double _x = 0;
  double _y = 0;

  /// Timer text
  int _countdown = 4;

  /// Timer
  late Timer _timer;

  /// Keeps track of line index in doc
  int _lineIndex = 0;

  /// Keeps track of letter index in line
  int _letterIndex = 0;

  /// Starts timer to start game
  void _startTimer() {
    // Button has been pressed
    setState(() {
      _isButtonPressed = true;
    });

    const oneSec = Duration(seconds: 1);

    // Start timer
    _timer = Timer.periodic(oneSec, (timer) {
      // Reached end of timer
      if (_countdown == 0) {
        setState(() {
          _timer.cancel();
          _timerEnded = true;
        });
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorial(context);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get height of screen
    height = MediaQuery.of(context).size.height;

    // Turtle is out of bounds
    if (_x < -1) {
      _x = -1;
    } else if (_x > 1) {
      _x = 1;
    }
    if (_y < -1) {
      _y = -1;
    } else if (_y > 1) {
      _y = 1;
    }

    // Reached end of doc -> end game
    if (_lineIndex > 0 && _lineIndex == TextFileReader.maxLines()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _endGame(context);
      });
    }

    return Scaffold(
      body: DecoratedBox(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    ImagePath.swimMinigame,
                  ),
                  fit: BoxFit.cover)),
          child: Column(
            children: [_buildWordDisplay(), _buildTextField(), _buildBottom()],
          )),
    );
  }

  /// Bottom of screen
  Widget _buildBottom() {
    return Expanded(
        child: _isButtonPressed ? _buildTurtleRoad() : _buildStartButton());
  }

  /// Container to hold starting button
  Widget _buildStartButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _startTimer();
        },
        style: Styles.taskButtonStyle,
        child: const Text('Start Game'),
      ),
    );
  }

  /// Container to hold turtle
  Widget _buildTurtleRoad() {
    return Container(
      // Position on screen
      alignment: Alignment(_x, _y),
      child: _buildTurtle(),
    );
  }

  /// Turtle Image
  Widget _buildTurtle() {
    return SizedBox(
      // Hard coded size
      height: height / 3,

      // Looking direction
      child: widget.startLeft
          ? CurrentUser.turtleSwimRight
          : CurrentUser.turtleSwimLeft,
    );
  }

  /// Clears text-field
  void clearTextField() {
    controller.clear();
  }

  /// Text field
  Widget _buildTextField() {
    return Row(
      children: [
        Expanded(
            child: Container(
          margin: const EdgeInsets.fromLTRB(100, 20, 100, 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.indigoAccent,
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(8)),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
            cursorColor: Colors.black,

            // When user enters text
            onChanged: (value) {
              setState(() {
                // User entered right letter
                if (value == TextFileReader.lines![_lineIndex][_letterIndex]) {
                  int newLetterIndex = _letterIndex + 1; // Increase index
                  int newLineIndex = _lineIndex;

                  // Reached end of sentence
                  if (newLetterIndex ==
                      TextFileReader.getSentenceLastIndex(_lineIndex)) {
                    newLineIndex += 1;
                    newLetterIndex = 0;
                  }

                  // Clear text field
                  clearTextField();

                  // Update
                  setState(() {
                    _lineIndex = newLineIndex;
                    _letterIndex = newLetterIndex;
                    _x = _getNewCoord(_x);
                    _y = _getNewCoord(_y);
                  });
                }
              });
            },
          ),
        ))
      ],
    );
  }

  /// Randomized method to get new number
  /// <p>
  /// Equal chance of staying the same, increasing, and decreasing
  double _getNewCoord(double old) {
    var rng = Random();
    int roll = rng.nextInt(3);
    double factor = 0.05;

    // Increase by 0.02
    if (roll == 0) {
      old += factor;
    }
    // Decrease
    else if (roll == 1) {
      old -= factor;
    }

    // Stay the same
    return old;
  }

  /// Top row of screen
  Widget _buildWordDisplay() {
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
                    child: Text(
                      widget.startLeft ? 'Go back home' : 'Go back to town',
                      style: const TextStyle(fontSize: 15),
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

        // Word Display
        Expanded(
            flex: 5,
            child: Container(
                height: 75,
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(8)),
                child: FittedBox(
                    child: _timerEnded
                        ? _getDisplaySentence()
                        : _getTimerText()))),
        Expanded(
          flex: 1,
          child: Container(
              margin: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(8)),
              child: const TaskButton()),
        ),
        Expanded(
          flex: 1,
          child: Container(
              margin: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(8)),
              child: const AccessoriesButton()),
        )
      ],
    );
  }

  /// Countdown text
  Widget _getTimerText() {
    return Text(_countdown == 4 ? ' ' : '$_countdown',
        style: const TextStyle(fontSize: 15));
  }

  /// Rich text from text file
  Widget _getDisplaySentence() {
    /// Game ended so blank
    if (_lineIndex == TextFileReader.maxLines()) {
      return const Text(' ');
    }

    // Separate the sentence into what the user typed and hasn't typed
    String typed = TextFileReader.lines![_lineIndex].substring(0, _letterIndex);
    String notTyped = TextFileReader.lines![_lineIndex].substring(_letterIndex);

    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: const TextStyle(fontSize: 15, height: 2),
            children: [
              // Highlight already typed words with red
              TextSpan(text: typed, style: const TextStyle(color: Colors.red)),

              // Untyped remain the same
              TextSpan(text: notTyped)
            ]));
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
            Just keep swimming! ヽ(ー_ー )ノ
            Just keep swimming!! ৻( •̀ ᗜ •́ ৻)
            Just keep swimming!!! ∑(O_O;)
            
            ''',
          ),
          TextSpan(
              text: 'How To Play\n',
              style: TextStyle(decoration: TextDecoration.underline)),
          TextSpan(text: '''
          Type the words shown on screen!
          No typos allowed! ヽ(￣ω￣(。。 )ゝ
          P.S Don't forget to type the periods!
          '''),
        ],
      ),
    );
  }

  /// Alert dialog asking user if they want to go back to where they started from
  void _showWarning(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Go Back ${widget.startLeft ? 'Home?' : 'to Town?'}'),
              content: const Text('Are you sure?'),
              actions: [
                // Cancel Button
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Never mind')),

                // Confirmation
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      widget.startLeft
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Level1HomeScreen(
                                        startLeft: false,
                                        showStartingMessage: false,
                                      )))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Level1TownScreen(startLeft: true)));
                    },
                    child: const Text('Yes'))
              ],
            ));
  }

  /// When user finishes typing everything
  void _endGame(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Just Keep Swimming...'),
              content: Text(
                  'Made it ${widget.startLeft ? 'to town!' : 'back home!'}'),
              actions: [
                // Okay
                TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      widget.startLeft
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Level1TownScreen(startLeft: true)))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Level1HomeScreen(
                                        startLeft: false,
                                        showStartingMessage: false,
                                      )));
                    },
                    child: const Text('Yay!')),
              ],
            ));
  }
}

/// Utility class that holds the text file used for the mini game
/// <p>
/// IMPORTANT: Call TextFileReader.setRandomText before calling SwimMinigameScreen
class TextFileReader {
  /// Temp variable
  static String? _text;

  /// Lines of random text file
  /// <p>
  /// Call TextFileReader.setRandomText to set the lines
  static List<String>? lines = List<String>.empty(growable: true);

  /// Get text file
  static Future<String> _loadAsset() async {
    return await rootBundle.loadString(_getRandomTextFilePath());
  }

  /// Call this function once to set TextFileReader.lines
  /// Call this function again if you want a different text file
  static Future<void> setRandomText() async {
    _text = await _loadAsset();

    List<String>? list = _text?.trim().split('\n');

    lines?.clear();

    for (String line in list!) {
      lines?.add(line);
    }
  }

  /// Where you change number of text files
  static String _getRandomTextFilePath() {
    var rng = Random();
    int num = rng.nextInt(10);
    return 'assets/files/swim_minigame/text$num.txt';
  }

  /// Returns length of lines
  static int maxLines() {
    return lines!.length;
  }

  /// Get index at the end of the sentence of a certain line
  static int getSentenceLastIndex(int line) {
    if (line < 0 || line >= maxLines()) {
      throw Exception('Array out of bounds');
    }
    return lines![line].length - 1;
  }
}
