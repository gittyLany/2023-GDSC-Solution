import 'package:flutter/material.dart';
import 'package:turtle/pages/animation/turtle_loading_screen.dart';
import 'package:turtle/pages/levels/level2/pb_minigame.dart';

import '../../../utils/current_user.dart';
import '../../../utils/image_path.dart';
import '../../../utils/images.dart';
import '../../tabs/my_dialog.dart';
import 'level2_dialog.dart';

/// Dinner time discussion
class Level2Part2Screen extends StatefulWidget {
  /// Dinner time discussion up to plastic bag mini game break
  const Level2Part2Screen({super.key});

  @override
  State<Level2Part2Screen> createState() => _Level2Part2ScreenState();
}

class _Level2Part2ScreenState extends State<Level2Part2Screen> {
  int _textIndex = 0;
  bool _dialogShow = true;
  bool _showChoices = false;
  @override
  Widget build(BuildContext context) {
    // Set up for Choice break
    if (_dialogShow &&
        _textIndex == Level2Dialog.choiceBreakIndex &&
        _showChoices == false) {
      setState(() {
        _dialogShow = false;
        _showChoices = true;
      });
    }

    // Show choice option
    if (_textIndex == Level2Dialog.choiceBreakIndex &&
        _showChoices &&
        _dialogShow == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showChoiceOption();
      });
    }

    // Cancel state
    if (_textIndex == Level2Dialog.minigame1BreakIndex && _dialogShow) {
      setState(() {
        _dialogShow = false;
      });
    }

    // Mini game break
    if (_textIndex == Level2Dialog.minigame1BreakIndex && !_dialogShow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const TurtleLoadingScreen(nextScreen: PBMinigameScreen())));
      });
    }

    // Show dialog
    if (_dialogShow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showDialog(context);
      });
    }

    return Scaffold(
        body: DecoratedBox(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      ImagePath.home2,
                    ),
                    fit: BoxFit.cover)),
            child: Stack(
              children: [_buildMomTurtle(), _buildTurtle()],
            )));
  }

  Widget _buildMomTurtle() {
    return Positioned.fill(
        child: Align(
      alignment: const Alignment(-0.9, 0),
      child: FractionallySizedBox(
        widthFactor: 0.35,
        heightFactor: 0.35,
        child: AppImages.momTurtle,
      ),
    ));
  }

  Widget _buildTurtle() {
    return Positioned.fill(
        child: Align(
      alignment: const Alignment(1.1, 0.1),
      child: FractionallySizedBox(
        widthFactor: 0.35,
        heightFactor: 0.25,
        child: CurrentUser.turtleWalkLeft,
      ),
    ));
  }

  void _showDialog(BuildContext context) {
    MyDialog dialog = Level2Dialog.dialogs[_textIndex];

    Profile profile = dialog.profile;

    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _dialogShow = true;
              _textIndex++;
              Navigator.pop(context);
            });
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Scaffold(
                backgroundColor: Colors.white24,
                body: Stack(
                  children: [
                    // Person speaking
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment(profile.x, profile.y),
                        child: FractionallySizedBox(
                          widthFactor: profile.widthFactor,
                          heightFactor: profile.heightFactor,
                          child: profile.image,
                        ),
                      ),
                    ),

                    // Name Tag
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment(profile.left ? 1 : -1, 0.55),
                        child: FractionallySizedBox(
                          heightFactor: 0.1,
                          widthFactor: 0.2,
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 3, color: Colors.black),
                                color: Colors.teal),
                            margin: const EdgeInsets.all(15),
                            child: Center(
                              child: Text(profile.name),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Text
                    Positioned.fill(
                        child: Align(
                      alignment: const Alignment(-0.9, 1),
                      child: FractionallySizedBox(
                        heightFactor: 0.25,
                        widthFactor: 1,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(width: 3, color: Colors.black),
                              color: Colors.indigo),
                          margin: const EdgeInsets.all(15),
                          child: Center(
                            child: dialog.text,
                          ),
                        ),
                      ),
                    ))
                  ],
                )),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 0),
    );
  }

  void _showChoiceOption() {
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.white24,
        builder: (context) {
          return SimpleDialog(
              title: const Text(
                'How long can plastic bags live for?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                SimpleDialogOption(
                  child: const Text('1 Year'),
                  onPressed: () {
                    _choiceSelected(0, context);
                  },
                ),
                SimpleDialogOption(
                  child: const Text('10 Years'),
                  onPressed: () {
                    _choiceSelected(1, context);
                  },
                ),
                SimpleDialogOption(
                  child: const Text('100 Years'),
                  onPressed: () {
                    _choiceSelected(2, context);
                  },
                ),
                SimpleDialogOption(
                  child: const Text('1000 Years'),
                  onPressed: () {
                    _choiceSelected(3, context);
                  },
                ),
              ]);
        });
  }

  void _choiceSelected(int option, BuildContext context) {
    Level2Dialog.choiceSelected = option;
    Level2Dialog.refreshChoiceDialog();
    setState(() {
      _textIndex++;
      _showChoices = false;
      _dialogShow = true;
      Navigator.pop(context);
    });
  }
}
