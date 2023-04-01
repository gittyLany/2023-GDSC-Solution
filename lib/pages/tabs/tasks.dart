import 'package:flutter/material.dart';

import '../../utils/current_user.dart';
import '../../utils/level.dart';
import '../../utils/styles.dart';

class TaskButton extends StatelessWidget {
  /// Shows a dialog telling user what to do next
  const TaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: Styles.taskButtonStyle,
        onPressed: () {
          _showTask(context);
        },
        child: const Icon(Icons.help_outline));
  }

  /// Show dialog
  void _showTask(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Current Task'),
              content: _getTaskText(),
              actions: [
                // Okay
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Understood!')),
              ],
            ));
  }

  /// Get text
  Widget _getTaskText() {
    if (CurrentUser.nextGoal == Level.talkToMom) {
      return const Text('Mom seems to be calling for me...');
    } else if (CurrentUser.nextGoal == Level.goHome) {
      return const Text('I am tired. Let\'s bring the groceries back home');
    } else if (CurrentUser.nextGoal == Level.goToStore) {
      return const Text(
          'Mom gave me a list of food to buy. To the grocery store!');
    } else if (CurrentUser.nextGoal == Level.eatFood) {
      return const Text(
          'I have the food I bought from the grocery store. Let\'s tell mom!');
    } else if (CurrentUser.nextGoal == Level.buyFood) {
      return const Text(
          'Need at least one fruit and one vegetable for mom. And at least one treat for me!');
    } else {
      return const Text('Should I throw the wrapper in the trash?');
    }
  }
}
