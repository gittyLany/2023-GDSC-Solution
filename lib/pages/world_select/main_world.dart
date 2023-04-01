import 'package:flutter/material.dart';
import 'package:turtle/pages/world_select/turtle_select.dart';
import 'package:turtle/utils/images.dart';

///
/// Main screen after signing in
/// Displays all worlds
///
class MainWorldScreen extends StatelessWidget {
  const MainWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Title "World Select"
          _buildTitle(),

          // Levels
          Row(
            children: [
              // Turtle Level
              _buildTurtleLevel(context),

              // In development
              _buildConstruction(context),
            ],
          ),
        ],
      ),
    );
  }

  /// Under construction!
  Widget _buildConstruction(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        AppImages.circleSlash,
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
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coming Soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text(
                  'Coming Soon!',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )))
      ],
    ));
  }

  /// Turtle Button and Text
  Widget _buildTurtleLevel(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        AppImages.babyTurtle,
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
                  //------ Enter Turtle World ----
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TurtleLevelScreen()));
                },
                child: const Text(
                  'Turtle',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )))
      ],
    ));
  }

  /// Title at top of screen
  Widget _buildTitle() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(15)),
      child: const Text('World Select',
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
    );
  }
}
