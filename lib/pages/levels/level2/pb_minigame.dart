import 'dart:async';

import 'package:flutter/material.dart';
import 'package:turtle/pages/animation/turtle_loading_screen.dart';
import 'package:turtle/pages/levels/level2/level2_part3.dart';

import 'dart:math' as math;

import '../../../utils/image_path.dart';
import '../../../utils/images.dart';
import '../../../utils/styles.dart';

class PBMinigameScreen extends StatefulWidget {
  /// Where's Waldo type of game
  const PBMinigameScreen({super.key});

  @override
  State<PBMinigameScreen> createState() => _PBMinigameState();
}

class _PBMinigameState extends State<PBMinigameScreen> {
  /// Which picture to show
  int _round = 1;

  /// Timer text
  int _timerCountdown = 4;

  /// Transition between rounds
  int _roundCountdown = 3;

  /// Timer
  late Timer _countdownTimer;

  /// Timer for transition between rounds
  late Timer _roundTimer;

  /// Determines if button should be shown
  bool _isButtonPressed = false;

  /// Determines when to start game
  bool _timerEnded = false;

  /// Keeps track if between rounds
  bool _roundStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorial(context);
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _roundTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Finished all 3 rounds
    if (_round == 4) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _endGame(context);
      });
    }

    return Scaffold(
        body: DecoratedBox(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                ImagePath.pbMinigame,
              ),
              fit: BoxFit.cover)),
      child: Column(
        children: [_buildTopRow(), _buildBottom()],
      ),
    ));
  }

  /// Starts timer to start game
  void _startTimer() {
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
          _roundStarted = true;
          _timerEnded = true;
        });
      } else {
        setState(() {
          _timerCountdown--;
        });
      }
    });
  }

  /// Starts timer to start game
  void _startRoundTimer() {
    const oneSec = Duration(seconds: 1);

    // Start timer
    _roundTimer = Timer.periodic(oneSec, (timer) {
      // Reached end of timer
      if (_roundCountdown == 0) {
        setState(() {
          _roundTimer.cancel();
          _roundStarted = true;
          _roundCountdown = 3;
          _round++;
        });
      } else {
        setState(() {
          _roundCountdown--;
        });
      }
    });
  }

  Widget _buildGamePanel() {
    return Container(
        margin: const EdgeInsets.all(20),
        decoration:
            BoxDecoration(border: Border.all(width: 2, color: Colors.blue)),
        child: _getRoundImage());
  }

  /// Bottom of screen
  Widget _buildBottom() {
    return Expanded(
        flex: 5, child: _timerEnded ? _buildGamePanel() : _buildStartButton());
  }

  /// Container to hold starting button
  Widget _buildStartButton() {
    if (_isButtonPressed) {
      return const Center(
        child: Text('Loading...'),
      );
    } else {
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
  }

  /// Get which picture to show
  Widget _getRoundImage() {
    if (_round == 1) {
      return _buildRound1();
    } else if (_round == 2) {
      return _buildRound2();
    }
    return _buildRound3();
  }

  /// Round 3
  Widget _buildRound3() {
    return Stack(
      children: [
        Image.asset(
          ImagePath.pbMiniGame3,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
            child: Align(
                alignment: const Alignment(0.85, 0.22),
                child: Transform.rotate(
                  angle: math.pi / 2.75,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color:
                                  _roundStarted ? Colors.white10 : Colors.red)),
                      child: FractionallySizedBox(
                        widthFactor: 0.07,
                        heightFactor: 0.1,
                        child: GestureDetector(
                          onTap: () {
                            if (_roundStarted) {
                              _nextRound();
                            }
                          },
                        ),
                      )),
                )))
      ],
    );
  }

  /// Round 2
  Widget _buildRound2() {
    return Stack(
      children: [
        Image.asset(
          ImagePath.pbMiniGame2,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
            child: Align(
                alignment: const Alignment(-0.65, -0.35),
                child: Transform.rotate(
                  angle: -math.pi / 4,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color:
                                  _roundStarted ? Colors.white10 : Colors.red)),
                      child: FractionallySizedBox(
                        widthFactor: 0.15,
                        heightFactor: 0.2,
                        child: GestureDetector(
                          onTap: () {
                            if (_roundStarted) {
                              _nextRound();
                            }
                          },
                        ),
                      )),
                )))
      ],
    );
  }

  /// Ronud 1
  Widget _buildRound1() {
    return Stack(
      children: [
        Image.asset(
          ImagePath.pbMiniGame1,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
            child: Align(
          alignment: const Alignment(0.65, 0.75),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: _roundStarted ? Colors.white10 : Colors.red)),
              child: FractionallySizedBox(
                widthFactor: 0.3,
                heightFactor: 0.4,
                child: GestureDetector(
                  onTap: () {
                    if (_roundStarted) {
                      _nextRound();
                    }
                  },
                ),
              )),
        ))
      ],
    );
  }

  /// Transitions to next round -> starts timer for 3 sec
  void _nextRound() {
    setState(() {
      _startRoundTimer();
      _roundStarted = false;
    });
  }

  /// Top UI
  Widget _buildTopRow() {
    return Expanded(
        flex: 1,
        child: Row(
          children: [
            // Button to show plastic bag
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
                          _showPBImage(context);
                        },
                        child: const Text(
                          'What am I trying to find?',
                          style: TextStyle(fontSize: 15),
                        )),
                  ),
                )),

            // Shows round number
            Expanded(
                flex: 3,
                child: Container(
                    margin: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 3),
                        borderRadius: BorderRadius.circular(8)),
                    child: FittedBox(
                      child:
                          _timerEnded ? _getDisplaySentence() : _getTimerText(),
                    ))),

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
                        style: Styles.helpButtonStyle,
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
        ));
  }

  /// Sentence displayed in box
  Widget _getDisplaySentence() {
    String text = '';

    if (_roundStarted) {
      text = 'Round: $_round';
    }
    // In between
    else {
      text = 'Correct...Loading next round...';
    }

    return Text(text);
  }

  /// Countdown text
  Widget _getTimerText() {
    return Text(
        _timerCountdown == 4 ? 'Press button to start' : '$_timerCountdown',
        style: const TextStyle(fontSize: 15));
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
            Wow look at all this mumbo jumbo! ଽ (৺ੋ ௦ ৺ੋ )৴
            Now where is that plastic bag? (・・ ) ?
            I swear it was here somewhere... (＞﹏＜)
            
            ''',
          ),
          TextSpan(
              text: 'How To Play\n',
              style: TextStyle(decoration: TextDecoration.underline)),
          TextSpan(text: '''
          Find the plastic bag! 
          Click on the plastic bag if you can find it!
          There are 3 rounds in total!
          P.S There is a button on the top left of the screen 
          for people who can't remember (； T.T))
           '''),
        ],
      ),
    );
  }

  /// Function to show image of plastic bag
  void _showPBImage(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.white54,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Column(
          children: [
            Expanded(
                flex: 4,
                child: Center(
                  child: AppImages.plasticBag,
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

  /// When user finishes all 3 rounds
  void _endGame(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Searching complete!'),
              content: const Text('No more please...'),
              actions: [
                // Okay
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TurtleLoadingScreen(
                                  nextScreen: Level2Part3Screen())));
                    },
                    child: const Text('Next!!')),
              ],
            ));
  }
}
