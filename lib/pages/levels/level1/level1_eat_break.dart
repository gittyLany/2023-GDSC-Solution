import 'package:flutter/material.dart';
import 'package:turtle/pages/levels/level1/level1_town.dart';
import 'package:turtle/pages/levels/level1/trash_minigame.dart';

import '../../../utils/current_user.dart';
import '../../../utils/image_path.dart';
import '../../../utils/level.dart';
import '../../animation/turtle_loading_screen.dart';
import '../../tabs/acessories.dart';
import '../../tabs/tasks.dart';

class EatScreen extends StatelessWidget {
  /// In between grocery store and trash mini game
  const EatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _askUser(context);
    });

    return Scaffold(
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
    );
  }

  /// Path where turtle walks
  /// <p>
  /// WHERE YOU SET TURTLE ON SCREEN
  Widget _buildTurtleRoad() {
    return Expanded(
      child: Container(
        alignment: const Alignment(-1, 0.7),
        child: _buildTurtle(),
      ),
    );
  }

  /// Turtle Image
  Widget _buildTurtle() {
    return FractionallySizedBox(
      // Hard coded size
      heightFactor: 0.25,
      // Looking direction
      child: CurrentUser.turtleWalkRight,
    );
  }

  /// Top Row
  Widget _buildTopRow() {
    return Row(
      textDirection: TextDirection.rtl,
      children: const [
        Expanded(flex: 1, child: TaskButton()),
        Expanded(flex: 1, child: AccessoriesButton())
      ],
    );
  }

  /// Shows an alert dialog asking user if they want to litter
  void _askUser(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Done eating. I now have a plastic wrapper!'),
              content: const Text('Should I walk to the trash can?'),
              actions: [
                // Cancel Button
                TextButton(
                    onPressed: () {
                      CurrentUser.littered = true;
                      CurrentUser.nextGoal = Level.goHome;
                      Navigator.of(ctx).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TurtleLoadingScreen(
                                  nextScreen:
                                      Level1TownScreen(startLeft: false))));
                    },
                    child: const Text('No...too far...I will litter...')),

                // Confirmation
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TurtleLoadingScreen(
                                  nextScreen: TrashMinigameScreen())));
                    },
                    child: const Text('Yes...so far...'))
              ],
            ));
  }
}
