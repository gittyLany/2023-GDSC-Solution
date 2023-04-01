import 'package:flutter/material.dart';
import 'package:turtle/pages/levels/level2/level2_dialog.dart';
import 'package:turtle/pages/tabs/ending_prize.dart';

import '../../../utils/current_user.dart';
import '../../../utils/image_path.dart';
import '../../../utils/images.dart';
import '../../tabs/my_dialog.dart';

class Level2Part5Screen extends StatefulWidget {
  /// From wrapper mini game to end of level 2
  const Level2Part5Screen({super.key});

  @override
  State<Level2Part5Screen> createState() => _Level2Part5State();
}

class _Level2Part5State extends State<Level2Part5Screen> {
  int _textIndex = Level2Dialog.minigame2BreakIndex;
  bool _dialogShow = true;

  @override
  Widget build(BuildContext context) {
    // Cancel state
    if (_textIndex == Level2Dialog.end && _dialogShow) {
      setState(() {
        _dialogShow = false;
      });
    }

    // Next Dialog
    if (_textIndex == Level2Dialog.end && !_dialogShow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PrizePicker.showMenu(context, 2);
      });
    }

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
}
