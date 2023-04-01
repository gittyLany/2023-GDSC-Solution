import 'package:flutter/material.dart';
import 'package:turtle/utils/accessory.dart';
import 'package:turtle/utils/current_user.dart';
import 'package:turtle/utils/styles.dart';

import '../../utils/image_path.dart';

class AccessoriesButton extends StatelessWidget {
  /// Button to change turtle looks
  /// <p>
  /// Unlocked looks is based on CurrentUser
  /// <p>
  /// Just add to screen and that's it
  const AccessoriesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: Styles.accessoryButtonStyle,
        onPressed: () {
          _showMenu(context);
        },
        child: const Icon(Icons.checkroom));
  }

  /// Show menu
  void _showMenu(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.white24,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              'Choose Accessory: Move turtle to see changes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              _buildOption(Accessory.normal, context),
              CurrentUser.capUnlocked
                  ? _buildOption(Accessory.cap, context)
                  : _buildLocked(Accessory.cap, context),
              CurrentUser.shadesUnlocked
                  ? _buildOption(Accessory.shades, context)
                  : _buildLocked(Accessory.shades, context),
              CurrentUser.flowerUnlocked
                  ? _buildOption(Accessory.flower, context)
                  : _buildLocked(Accessory.flower, context),
              CurrentUser.hatUnlocked
                  ? _buildOption(Accessory.topHat, context)
                  : _buildLocked(Accessory.topHat, context),
              CurrentUser.disguiseUnlocked
                  ? _buildOption(Accessory.disguise, context)
                  : _buildLocked(Accessory.disguise, context),
            ],
          );
        });
  }

  /// Locked option
  Widget _buildLocked(Accessory accessory, BuildContext context) {
    return SimpleDialogOption(
      child: Row(
        children: const [Text('LOCKED'), Icon(Icons.lock)],
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Locked'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }

  /// Unlocked option
  Widget _buildOption(Accessory accessory, BuildContext context) {
    return SimpleDialogOption(
      child: Row(
        children: [Text(accessory.name.toUpperCase()), _buildImage(accessory)],
      ),
      onPressed: () {
        CurrentUser.setAccessories(accessory);
        Navigator.pop(context);
      },
    );
  }

  /// Image
  Widget _buildImage(Accessory accessory) {
    if (accessory == Accessory.cap) {
      return Image.asset(
        ImagePath.cap,
        fit: BoxFit.contain,
        height: 50,
      );
    } else if (accessory == Accessory.disguise) {
      return Image.asset(ImagePath.disguise, fit: BoxFit.contain, height: 50);
    } else if (accessory == Accessory.flower) {
      return Image.asset(ImagePath.flower, fit: BoxFit.contain, height: 50);
    } else if (accessory == Accessory.topHat) {
      return Image.asset(ImagePath.topHat, fit: BoxFit.contain, height: 50);
    } else if (accessory == Accessory.shades) {
      return Image.asset(ImagePath.shades, fit: BoxFit.contain, height: 50);
    }

    return const Icon(Icons.sentiment_satisfied_rounded);
  }
}
