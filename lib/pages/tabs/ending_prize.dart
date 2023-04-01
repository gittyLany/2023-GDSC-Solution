import 'package:flutter/material.dart';
import 'package:turtle/pages/animation/turtle_loading_screen.dart';
import 'package:turtle/pages/world_select/turtle_select.dart';
import 'package:turtle/services/functions/db_functions.dart';

import '../../utils/accessory.dart';
import '../../utils/current_user.dart';
import '../../utils/image_path.dart';

/// Simple dialog displayed at the end of the level
/// <p>
/// Allows user to unlock 1/3 accessory
class PrizePicker {
  /// Show prize menu
  static void showMenu(BuildContext context, int level) {
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.white24,
        builder: (ctx) {
          return SimpleDialog(
              title: const Text(
                'Level Complete! Select a prize!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: _buildOptions(context, level));
        });
  }

  /// Build list of accessories to choose from
  static List<Widget> _buildOptions(BuildContext context, int level) {
    List<Widget> list = List.empty(growable: true);
    if (!CurrentUser.hatUnlocked) {
      list.add(_buildOption(Accessory.topHat, context, level));
    }
    if (!CurrentUser.shadesUnlocked) {
      list.add(_buildOption(Accessory.shades, context, level));
    }
    if (!CurrentUser.disguiseUnlocked) {
      list.add(_buildOption(Accessory.disguise, context, level));
    }
    return list;
  }

  static Widget _buildOption(
      Accessory accessory, BuildContext context, int level) {
    return SimpleDialogOption(
      child: Row(
        children: [Text(accessory.name.toUpperCase()), _buildImage(accessory)],
      ),
      onPressed: () async {
        await _updateStatus(accessory, level);
        if (context.mounted) {
          _goToNextScreen(context);
        }
      },
    );
  }

  /// After clicking on accessory
  static void _goToNextScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const TurtleLoadingScreen(nextScreen: TurtleLevelScreen())));
  }

  /// Updates stats in database
  static Future<void> _updateStatus(Accessory accessory, int level) async {
    if (accessory == Accessory.disguise) {
      CurrentUser.disguiseUnlocked = true;

      if (!CurrentUser.guest) {
        await DBFunctions.updateDisguiseStatus(CurrentUser.disguiseUnlocked);
      }
    } else if (accessory == Accessory.topHat) {
      CurrentUser.hatUnlocked = true;
      if (!CurrentUser.guest) {
        await DBFunctions.updateHatStatus(CurrentUser.hatUnlocked);
      }
    } else {
      CurrentUser.shadesUnlocked = true;
      if (!CurrentUser.guest) {
        await DBFunctions.updateShadesStatus(CurrentUser.shadesUnlocked);
      }
    }

    // Level 1
    if (level == 1) {
      CurrentUser.level1Complete = true;
      if (!CurrentUser.guest) {
        await DBFunctions.updateLevel1Status(true);
        await DBFunctions.updateBagStatus(CurrentUser.hasReusableBag);
        await DBFunctions.updateCapStatus(CurrentUser.capUnlocked);
        await DBFunctions.updateCurrentCostume(CurrentUser.currentAccessory);
        await DBFunctions.updateFlowerStatus(CurrentUser.flowerUnlocked);
        await DBFunctions.updateLitterStatus(CurrentUser.littered);
      }

      await DBFunctions.incTotalTurtle1Users();

      // ----- INCREASE STATS----
      if (CurrentUser.littered) {
        await DBFunctions.incLitter();
      }
      if (CurrentUser.hasReusableBag) {
        await DBFunctions.incReusableBags();
      }
    }

    // Level 2
    else if (level == 2) {
      CurrentUser.level2Complete = true;

      if (!CurrentUser.guest) {
        await DBFunctions.updateLevel2Status(true);
        await DBFunctions.updateCapStatus(CurrentUser.capUnlocked);
        await DBFunctions.updateCurrentCostume(CurrentUser.currentAccessory);
      }
    }
  }

  /// Image
  static Widget _buildImage(Accessory accessory) {
    if (accessory == Accessory.disguise) {
      return Image.asset(ImagePath.disguise, fit: BoxFit.contain, height: 50);
    } else if (accessory == Accessory.topHat) {
      return Image.asset(ImagePath.topHat, fit: BoxFit.contain, height: 50);
    }
    return Image.asset(ImagePath.shades, fit: BoxFit.contain, height: 50);
  }
}
