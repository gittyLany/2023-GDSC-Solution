import 'package:flutter/material.dart';
import 'package:turtle/pages/levels/level1/level1_dialog.dart';
import 'package:turtle/utils/image_path.dart';

import '../../../utils/current_user.dart';
import '../../../utils/images.dart';
import '../../../utils/styles.dart';
import '../../tabs/acessories.dart';
import '../../tabs/tasks.dart';

class Level1StoreScreen extends StatefulWidget {
  /// All Code in grocery store
  const Level1StoreScreen({super.key});

  @override
  State<Level1StoreScreen> createState() => _Level1StoreScreenState();
}

class _Level1StoreScreenState extends State<Level1StoreScreen> {
  // Where user is
  String _background = ImagePath.aisleMain;

  // ---- Variables about which food user has
  bool _hasApple = false;
  bool _hasBanana = false;
  bool _hasStrawberry = false;
  bool _hasFruit = false;

  bool _hasCarrot = false;
  bool _hasLettuce = false;
  bool _hasPea = false;
  bool _hasVeg = false;

  bool _hasSnail = false;
  bool _hasWorms = false;
  bool _hasEgg = false;
  bool _hasTreat = false;

  /// If should show ending dialog
  bool _showDialog = false;

  @override
  Widget build(BuildContext context) {
    // Ending dialog
    if (_showDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Level1Dialog.showOctopusDialog(context);
      });
    }

    return Scaffold(
      body: DecoratedBox(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    _background,
                  ),
                  fit: BoxFit.cover)),
          child: Column(
            children: [_buildTopRow(), _buildBottom()],
          )),
    );
  }

  /// Top Row
  Widget _buildTopRow() {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        // Accessory button
        Container(
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(8)),
            child: const AccessoriesButton()),

        // Task display
        Container(
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(8)),
            child: const TaskButton()),
        _inAisle() ? _buildBackButton() : Container(),
        _canCheckOut() ? _buildCheckOutButton() : Container()
      ],
    );
  }

  /// If user has one of each type of food
  bool _canCheckOut() {
    return _hasFruit &&
        _hasVeg &&
        _hasTreat &&
        _background != ImagePath.cashier;
  }

  /// Check out button
  Widget _buildCheckOutButton() {
    return Container(
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(8)),
        child: ElevatedButton(
          style: Styles.yellowButtonStyle,
          onPressed: () {
            _showWarning(context);
          },
          child: const Text('Check Out'),
        ));
  }

  /// Alert dialog asking user if they want to check out
  void _showWarning(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Check Out'),
              content: const Text('Are you ready to check out?'),
              actions: [
                // Cancel Button
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Never mind')),

                // Confirmation
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _showDialog = true;
                        _background = ImagePath.cashier;
                      });
                    },
                    child: const Text('Yes'))
              ],
            ));
  }

  /// If user is in aisle
  bool _inAisle() {
    if (_background == ImagePath.aisle1 ||
        _background == ImagePath.aisle2 ||
        _background == ImagePath.aisle3) {
      return true;
    }
    return false;
  }

  /// Button to go back to main aisle
  Widget _buildBackButton() {
    return Container(
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(8)),
        child: ElevatedButton(
          style: Styles.exitButtonStyle,
          onPressed: () {
            setState(() {
              _background = ImagePath.aisleMain;
            });
          },
          child: const Text('Go Back'),
        ));
  }

  /// Button of screen
  Widget _buildBottom() {
    return Expanded(child: _buildRoom());
  }

  /// Sets up room based on number
  Widget _buildRoom() {
    if (_background == ImagePath.aisleMain) {
      return _buildMainAisle();
    } else if (_background == ImagePath.aisle1) {
      return _buildAisle1();
    } else if (_background == ImagePath.aisle2) {
      return _buildAisle2();
    } else if (_background == ImagePath.aisle3) {
      return _buildAisle3();
    }
    return _buildCashier();
  }

  /// Cashier screen
  Widget _buildCashier() {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [_buildOctopus(), _buildTurtle()],
        ))
      ],
    );
  }

  /// Octopus
  Widget _buildOctopus() {
    return Positioned.fill(
        child: Align(
      alignment: const Alignment(1.2, -0.75),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.5,
        child: AppImages.octopus,
      ),
    ));
  }

  /// Turtle
  Widget _buildTurtle() {
    return Positioned.fill(
        child: Align(
      alignment: const Alignment(-0.5, 0.8),
      child: FractionallySizedBox(
        widthFactor: 0.35,
        heightFactor: 0.35,
        child: CurrentUser.turtleWalkRight,
      ),
    ));
  }

  /// Aisle 1
  Widget _buildAisle1() {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            _hasApple ? Container() : _buildApple(),
            _hasBanana ? Container() : _buildBanana(),
            _hasStrawberry ? Container() : _buildStrawberry(),
          ],
        ))
      ],
    );
  }

  // ---- ALL FOOD WIDGETS -----

  Widget _buildApple() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(0, 0.5),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FractionallySizedBox(
                widthFactor: 0.2,
                heightFactor: 0.2,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _hasApple = true;
                      _hasFruit = true;
                    });
                  },
                  child: AppImages.apple,
                ),
              ),
            )));
  }

  Widget _buildBanana() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(0.35, -0.5),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FractionallySizedBox(
                widthFactor: 0.2,
                heightFactor: 0.2,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _hasFruit = true;
                      _hasBanana = true;
                    });
                  },
                  child: AppImages.banana,
                ),
              ),
            )));
  }

  Widget _buildStrawberry() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(-0.9, 0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FractionallySizedBox(
                widthFactor: 0.2,
                heightFactor: 0.2,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _hasStrawberry = true;
                      _hasFruit = true;
                    });
                  },
                  child: AppImages.strawberry,
                ),
              ),
            )));
  }

  Widget _buildAisle2() {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            _hasCarrot ? Container() : _buildCarrot(),
            _hasLettuce ? Container() : _buildLettuce(),
            _hasPea ? Container() : _buildPea(),
          ],
        ))
      ],
    );
  }

  Widget _buildCarrot() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(0.5, -0.5),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FractionallySizedBox(
                widthFactor: 0.2,
                heightFactor: 0.2,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _hasCarrot = true;
                      _hasVeg = true;
                    });
                  },
                  child: AppImages.carrot,
                ),
              ),
            )));
  }

  Widget _buildLettuce() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(0.8, 0.5),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FractionallySizedBox(
                widthFactor: 0.2,
                heightFactor: 0.2,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _hasVeg = true;
                      _hasLettuce = true;
                    });
                  },
                  child: AppImages.lettuce,
                ),
              ),
            )));
  }

  Widget _buildPea() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(-0.9, 0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FractionallySizedBox(
                widthFactor: 0.2,
                heightFactor: 0.2,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _hasPea = true;
                      _hasVeg = true;
                    });
                  },
                  child: AppImages.pea,
                ),
              ),
            )));
  }

  Widget _buildAisle3() {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            _hasSnail ? Container() : _buildSnail(),
            _hasWorms ? Container() : _buildWorms(),
            _hasEgg ? Container() : _buildEgg(),
          ],
        ))
      ],
    );
  }

  Widget _buildSnail() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(0.25, -0.5),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FractionallySizedBox(
                widthFactor: 0.2,
                heightFactor: 0.2,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _hasSnail = true;
                      _hasTreat = true;
                    });
                  },
                  child: AppImages.fruitRollUp,
                ),
              ),
            )));
  }

  Widget _buildWorms() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(-0.75, 0.5),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FractionallySizedBox(
                widthFactor: 0.2,
                heightFactor: 0.2,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _hasWorms = true;
                      _hasTreat = true;
                    });
                  },
                  child: AppImages.gummyWorms,
                ),
              ),
            )));
  }

  Widget _buildEgg() {
    return Positioned.fill(
        child: Align(
            alignment: const Alignment(0.9, 0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FractionallySizedBox(
                widthFactor: 0.2,
                heightFactor: 0.2,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _hasEgg = true;
                      _hasTreat = true;
                    });
                  },
                  child: AppImages.kinderEgg,
                ),
              ),
            )));
  }

  /// Main aisle
  Widget _buildMainAisle() {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            Positioned.fill(
                child: Align(
                    alignment: const Alignment(-0.8, -1),
                    child: FractionallySizedBox(
                      widthFactor: 0.25,
                      heightFactor: 0.8,
                      child: MouseRegion(
                        onHover: (event) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Aisle 1'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        cursor: SystemMouseCursors.click,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _background = ImagePath.aisle1;
                            });
                          },
                        ),
                      ),
                    ))),
            Positioned.fill(
                child: Align(
                    alignment: const Alignment(0.05, -1),
                    child: FractionallySizedBox(
                      widthFactor: 0.20,
                      heightFactor: 0.8,
                      child: MouseRegion(
                        onHover: (event) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Aisle 2'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        cursor: SystemMouseCursors.click,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _background = ImagePath.aisle2;
                            });
                          },
                        ),
                      ),
                    ))),
            Positioned.fill(
                child: Align(
                    alignment: const Alignment(0.75, -1),
                    child: FractionallySizedBox(
                      widthFactor: 0.20,
                      heightFactor: 0.8,
                      child: MouseRegion(
                        onHover: (event) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Aisle 3'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        cursor: SystemMouseCursors.click,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _background = ImagePath.aisle3;
                            });
                          },
                        ),
                      ),
                    ))),
          ],
        ))
      ],
    );
  }
}
