import 'package:flutter/material.dart';

class Styles {
  /// Exit button color
  static ButtonStyle exitButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 230, 57, 70),
    padding: const EdgeInsets.all(15),
  );

  /// Help button style
  static ButtonStyle helpButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 168, 218, 220),
    padding: const EdgeInsets.all(15),
    foregroundColor: Colors.black,
  );

  /// Yellow button
  static ButtonStyle yellowButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 221, 160, 62),
    padding: const EdgeInsets.all(15),
    foregroundColor: Colors.black,
  );

  /// Accessory button -> the hanger
  static ButtonStyle accessoryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 242, 186, 201),
    padding: const EdgeInsets.all(15),
    foregroundColor: Colors.black,
  );

  /// Task button -> the ?
  static ButtonStyle taskButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 192, 223, 161),
    padding: const EdgeInsets.all(15),
    foregroundColor: Colors.black,
  );

  /// Text during dialogs
  static TextStyle dialogStyle =
      const TextStyle(fontSize: 25, color: Colors.white);

  /// Text when something has been unlocked
  static TextStyle unlockStyle = const TextStyle(
      backgroundColor: Colors.indigo,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline);
}
