import 'package:flutter/material.dart';
import 'package:turtle/pages/animation/turtle_loading_screen.dart';
import 'package:turtle/pages/levels/level1/level1_home.dart';
import 'package:turtle/pages/levels/level2/level2_part1.dart';
import 'package:turtle/pages/tabs/acessories.dart';
import 'package:turtle/utils/current_user.dart';
import 'package:turtle/utils/images.dart';
import 'package:turtle/utils/styles.dart';

import '../../utils/image_path.dart';
import '../../utils/level.dart';
import '../levels/level2/level2_dialog.dart';
import 'main_world.dart';

class TurtleLevelScreen extends StatelessWidget {
  /// Turtle Level selection screen
  const TurtleLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DecoratedBox(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                ImagePath.turtleLevel,
              ),
              fit: BoxFit.cover)),
      child: Column(
        children: [_buildTopRow(context), _buildLevel(context)],
      ),
    ));
  }

  /// Row with all levels
  Widget _buildLevel(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Row(
          children: [
            _buildLevel1(context),
            _buildLevel2(context),
            _buildLevel3(context),
          ],
        ));
  }

  /// Level 3
  Widget _buildLevel3(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        // Final boss
        AppImages.questionMark,

        // Button
        Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(15)),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black),
                onPressed: () {
                  //------ Enter Level 3 ----
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coming Soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text(
                  CurrentUser.level2Complete ? 'Level 3' : 'Locked',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                )))
      ],
    ));
  }

  /// Level 2
  Widget _buildLevel2(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        // Turtle image
        CurrentUser.level1Complete
            ? CurrentUser.turtleSwimRight
            : AppImages.questionMark,

        // Button
        Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(15)),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black),
                onPressed: () {
                  //------ Enter Level 2 ----
                  _level2Function(context);
                },
                child: _getLevel2Text()))
      ],
    ));
  }

  /// When level 2 button is pressed
  void _level2Function(BuildContext context) {
    if (CurrentUser.level1Complete && CurrentUser.level2Complete) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Level Complete'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (CurrentUser.level1Complete) {
      _startLevel2(context);
    } else {
      _displayWarningMessage(context);
    }
  }

  /// Button text for level 2
  Widget _getLevel2Text() {
    String text = '';
    if (CurrentUser.level1Complete && CurrentUser.level2Complete) {
      text = 'Complete';
    } else if (CurrentUser.level1Complete) {
      text = 'Level 2';
    } else {
      text = 'Locked';
    }
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
      ),
    );
  }

  /// Display message
  void _displayWarningMessage(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please Complete Level 1 First'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Navigate to level 2
  Future<void> _startLevel2(BuildContext context) async {
    await Level2Dialog.refreshList();

    CurrentUser.nextGoal = Level.eatFood;

    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const TurtleLoadingScreen(nextScreen: Level2Part1Screen())));
    }
  }

  /// Level 1
  Widget _buildLevel1(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        AppImages.babyTurtle,

        // Button
        Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(15)),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black),
                onPressed: () {
                  //------ Enter Level 1 ----
                  if (!CurrentUser.level1Complete) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TurtleLoadingScreen(
                                    nextScreen: Level1HomeScreen(
                                  startLeft: true,
                                  showStartingMessage: true,
                                ))));
                  }
                },
                child: Text(
                  CurrentUser.level1Complete ? 'Complete' : 'Level 1',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                )))
      ],
    ));
  }

  /// Top row
  Widget _buildTopRow(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(
        children: [
          Expanded(flex: 1, child: _buildBackButton(context)),

          Expanded(flex: 3, child: _buildTitle()),
          // ---- Accessory tab -----
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(15),
                child: const AccessoriesButton(),
              ))
        ],
      ),
    );
  }

  /// Title
  Widget _buildTitle() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(15)),
      child: const Text('Level Select',
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
    );
  }

  /// Back button
  Widget _buildBackButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(15),
      child: ElevatedButton(
          style: Styles.yellowButtonStyle,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MainWorldScreen()));
          },
          child: const Text('Back', style: TextStyle(fontSize: 20))),
    );
  }
}
