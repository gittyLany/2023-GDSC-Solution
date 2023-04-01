import 'package:flutter/material.dart';
import 'package:turtle/pages/animation/turtle_loading_screen.dart';
import 'package:turtle/pages/tabs/my_dialog.dart';
import 'package:turtle/utils/current_user.dart';

import '../../../utils/images.dart';
import '../../../utils/level.dart';
import '../../../utils/styles.dart';
import 'level1_eat_break.dart';

class Level1Dialog {
  /// Shows mom dialog based on current goal
  static void showMomDialog(BuildContext context) {
    if (CurrentUser.nextGoal == Level.talkToMom) {
      final List<String> startTalkMom = <String>[
        'Hi son! Perfect timing!',
        'I have the grocery list for this week ready!',
        'Some are ingredients we need to make dinner tonight!',
        'Will you help me get the groceries please?',
        'Of course! I love food!',
        'And don\'t forget to bring one of our reusable bags!'
      ];
      final List<Profile> startTalkProfiles = <Profile>[
        Profile.mom(),
        Profile.mom(),
        Profile.mom(),
        Profile.mom(),
        Profile.you(),
        Profile.mom()
      ];
      _talkDialog(context, startTalkMom, 0, startTalkProfiles, 1);
    }
    // Grocery store
    else {
      final List<String> startGroceryMom = <String>[
        'Don\'t you love swimming?'
      ];
      final List<Profile> groceryTalkProfiles = <Profile>[Profile.mom()];
      _talkDialog(context, startGroceryMom, 0, groceryTalkProfiles, 0);
    }
  }

  /// Shows penguin dialog based on if flower is unlocked
  static void showPenguinDialog(BuildContext context) {
    if (!CurrentUser.flowerUnlocked) {
      final List<String> penguinFlowerTalk = <String>[
        'Hello! Do you want to go look at my flower shop?',
        'Yes I love flowers!',
        'Then I\'ll just give you this treat for appreciating the flowers!'
      ];
      final List<Profile> penguinFlower = <Profile>[
        Profile.penguin(),
        Profile.you(),
        Profile.penguin()
      ];
      _talkDialog(context, penguinFlowerTalk, 0, penguinFlower, 2);
    } else {
      final List<String> penguinNoFlowerTalk = <String>[
        'The flower looks beautiful on you!'
      ];
      final List<Profile> penguinNoFlower = <Profile>[Profile.penguin()];
      _talkDialog(context, penguinNoFlowerTalk, 0, penguinNoFlower, 0);
    }
  }

  /// WIP -> should be randomized jokes -> but no time
  static void showClownFishDialog(BuildContext context) {
    _clownFishDialog1(context);
  }

  static void showOctopusDialog(BuildContext context) {
    _octopusDialog1(context);
  }

  // ---------- Absolutely terrible code -----------

  /// Mom dialog 1 -> have no clue how to reuse this code
  /// -> if you can figure out how to reuse that'll be great!
  /// 0 = nothing, 1 = mom, 2 = penguin (gives flower)
  static void _talkDialog(BuildContext context, List<String> message,
      int counter, List<Profile> profiles, int function) {
    MyDialog dialog = MyDialog(
        profile: profiles[counter],
        text: Text(message[counter],
            style: Styles.dialogStyle, textAlign: TextAlign.center));

    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            if (counter < message.length - 1) {
              _talkDialog(context, message, ++counter, profiles, function);
            }
            // End of dialog
            else {
              if (function == 1) {
                _finishedMom();
              } else if (function == 2) {
                _finishedPenguin(context);
              }
            }
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
                        alignment:
                            Alignment(dialog.profile.x, dialog.profile.y),
                        child: FractionallySizedBox(
                          widthFactor: dialog.profile.widthFactor,
                          heightFactor: dialog.profile.heightFactor,
                          child: dialog.profile.image,
                        ),
                      ),
                    ),

                    // Name Tag
                    Positioned.fill(
                      child: Align(
                        alignment:
                            Alignment(dialog.profile.left ? 1 : -1, 0.55),
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
                              child: Text(dialog.profile.name),
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

  /// After finishing talk to penguin (user has no flower)
  static void _finishedPenguin(BuildContext context) {
    _showFlowerUnlock(context);
  }

  /// After you talk to mom for first time
  static void _finishedMom() {
    CurrentUser.nextGoal = Level.goToStore;
  }

  /// Show message that the flower has been unlocked
  static void _showFlowerUnlock(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          child: Column(
            children: [
              Expanded(
                child: FittedBox(
                    child: Text(
                  'Flower Unlocked!',
                  style: Styles.unlockStyle,
                )),
              ),
              Expanded(
                  flex: 3,
                  child: Center(
                    child: AppImages.flower,
                  )),
              Expanded(
                  flex: 1,
                  child: SizedBox.expand(
                    child: ElevatedButton(
                      onPressed: () {
                        CurrentUser.flowerUnlocked = true;
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Yay',
                      ),
                    ),
                  ))
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  /// Penguin user has no flower dialog 1
  static void _clownFishDialog1(BuildContext context) {
    MyDialog dialog = MyDialog(
        profile: Profile.clownFish(),
        text: Text('What was the fish who was a huge Rick Astley fan singing?',
            style: Styles.dialogStyle, textAlign: TextAlign.center));

    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            _clownFishDialog2(context);
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
                        alignment:
                            Alignment(dialog.profile.x, dialog.profile.y),
                        child: FractionallySizedBox(
                          widthFactor: dialog.profile.widthFactor,
                          heightFactor: dialog.profile.heightFactor,
                          child: dialog.profile.image,
                        ),
                      ),
                    ),

                    // Name Tag
                    Positioned.fill(
                      child: Align(
                        alignment:
                            Alignment(dialog.profile.left ? 1 : -1, 0.55),
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
                              child: Text(dialog.profile.name),
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

  static void _clownFishDialog2(BuildContext context) {
    MyDialog dialog = MyDialog(
        profile: Profile.clownFish(),
        text: Text(
            'Never gonna give you up! Never gonna let you drown! '
            'Never gonna swim around and splash you!',
            style: Styles.dialogStyle,
            textAlign: TextAlign.center));

    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
                        alignment:
                            Alignment(dialog.profile.x, dialog.profile.y),
                        child: FractionallySizedBox(
                          widthFactor: dialog.profile.widthFactor,
                          heightFactor: dialog.profile.heightFactor,
                          child: dialog.profile.image,
                        ),
                      ),
                    ),

                    // Name Tag
                    Positioned.fill(
                      child: Align(
                        alignment:
                            Alignment(dialog.profile.left ? 1 : -1, 0.55),
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
                              child: Text(dialog.profile.name),
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

  static void _octopusDialog1(BuildContext context) {
    MyDialog dialog = MyDialog(
        profile: Profile.octopus(),
        text: Text(
          'Is this all for today?',
          style: Styles.dialogStyle,
        ));

    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            _octopusDialog2(context);
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
                        alignment:
                            Alignment(dialog.profile.x, dialog.profile.y),
                        child: FractionallySizedBox(
                          widthFactor: dialog.profile.widthFactor,
                          heightFactor: dialog.profile.heightFactor,
                          child: dialog.profile.image,
                        ),
                      ),
                    ),

                    // Name Tag
                    Positioned.fill(
                      child: Align(
                        alignment:
                            Alignment(dialog.profile.left ? 1 : -1, 0.55),
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
                              child: Text(dialog.profile.name),
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

  static void _octopusDialog2(BuildContext context) {
    MyDialog dialog = MyDialog(
        profile: Profile.you(),
        text: Text(
          'Yep!',
          style: Styles.dialogStyle,
        ));

    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            _octopusDialog3(context);
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
                        alignment:
                            Alignment(dialog.profile.x, dialog.profile.y),
                        child: FractionallySizedBox(
                          widthFactor: dialog.profile.widthFactor,
                          heightFactor: dialog.profile.heightFactor,
                          child: dialog.profile.image,
                        ),
                      ),
                    ),

                    // Name Tag
                    Positioned.fill(
                      child: Align(
                        alignment:
                            Alignment(dialog.profile.left ? 1 : -1, 0.55),
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
                              child: Text(dialog.profile.name),
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

  static void _octopusDialog3(BuildContext context) {
    MyDialog dialog = MyDialog(
        profile: Profile.octopus(),
        text: Text(
          'Would you like a bag?',
          style: Styles.dialogStyle,
        ));

    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            _octopusDialog4(context);
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
                        alignment:
                            Alignment(dialog.profile.x, dialog.profile.y),
                        child: FractionallySizedBox(
                          widthFactor: dialog.profile.widthFactor,
                          heightFactor: dialog.profile.heightFactor,
                          child: dialog.profile.image,
                        ),
                      ),
                    ),

                    // Name Tag
                    Positioned.fill(
                      child: Align(
                        alignment:
                            Alignment(dialog.profile.left ? 1 : -1, 0.55),
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
                              child: Text(dialog.profile.name),
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

  static void _octopusDialog4(BuildContext context) {
    String text = CurrentUser.hasReusableBag
        ? 'Oh that is okay. I have my own bags!'
        : 'Oh yes please that will be great!';

    MyDialog dialog = MyDialog(
        profile: Profile.you(),
        text: Text(
          text,
          style: Styles.dialogStyle,
        ));

    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            _octopusDialog5(context);
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
                        alignment:
                            Alignment(dialog.profile.x, dialog.profile.y),
                        child: FractionallySizedBox(
                          widthFactor: dialog.profile.widthFactor,
                          heightFactor: dialog.profile.heightFactor,
                          child: dialog.profile.image,
                        ),
                      ),
                    ),

                    // Name Tag
                    Positioned.fill(
                      child: Align(
                        alignment:
                            Alignment(dialog.profile.left ? 1 : -1, 0.55),
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
                              child: Text(dialog.profile.name),
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

  static void _octopusDialog5(BuildContext context) {
    String text = CurrentUser.hasReusableBag
        ? 'That\'s Great! Your total is 30 coins!'
        : 'That will be an extra coin for those plastic bags!';

    MyDialog dialog = MyDialog(
        profile: Profile.octopus(),
        text: Text(
          text,
          style: Styles.dialogStyle,
        ));

    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            _octopusDialog6(context);
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
                        alignment:
                            Alignment(dialog.profile.x, dialog.profile.y),
                        child: FractionallySizedBox(
                          widthFactor: dialog.profile.widthFactor,
                          heightFactor: dialog.profile.heightFactor,
                          child: dialog.profile.image,
                        ),
                      ),
                    ),

                    // Name Tag
                    Positioned.fill(
                      child: Align(
                        alignment:
                            Alignment(dialog.profile.left ? 1 : -1, 0.55),
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
                              child: Text(dialog.profile.name),
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

  static void _octopusDialog6(BuildContext context) {
    MyDialog dialog = MyDialog(
        profile: Profile.you(),
        text: Text(
          'Thank you! Have a great day!',
          style: Styles.dialogStyle,
        ));

    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            _octopusDialog7(context);
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
                        alignment:
                            Alignment(dialog.profile.x, dialog.profile.y),
                        child: FractionallySizedBox(
                          widthFactor: dialog.profile.widthFactor,
                          heightFactor: dialog.profile.heightFactor,
                          child: dialog.profile.image,
                        ),
                      ),
                    ),

                    // Name Tag
                    Positioned.fill(
                      child: Align(
                        alignment:
                            Alignment(dialog.profile.left ? 1 : -1, 0.55),
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
                              child: Text(dialog.profile.name),
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

  static void _octopusDialog7(BuildContext context) {
    MyDialog dialog = MyDialog(
        profile: Profile.you(),
        text: Text(
          'Phew...I am hungry...I am going to eat my snack!',
          style: Styles.dialogStyle,
        ));

    showGeneralDialog(
      context: context,
      barrierColor: Colors.white24,
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            CurrentUser.nextGoal = Level.throwTrash;
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const TurtleLoadingScreen(nextScreen: EatScreen())));
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
                        alignment:
                            Alignment(dialog.profile.x, dialog.profile.y),
                        child: FractionallySizedBox(
                          widthFactor: dialog.profile.widthFactor,
                          heightFactor: dialog.profile.heightFactor,
                          child: dialog.profile.image,
                        ),
                      ),
                    ),

                    // Name Tag
                    Positioned.fill(
                      child: Align(
                        alignment:
                            Alignment(dialog.profile.left ? 1 : -1, 0.55),
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
                              child: Text(dialog.profile.name),
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
