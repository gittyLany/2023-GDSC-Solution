import 'package:flutter/cupertino.dart';

import '../../utils/current_user.dart';
import '../../utils/images.dart';

class Profile {
  Image image;
  String name;
  double x;
  double y;
  double widthFactor;
  double heightFactor;
  bool left;

  /// Info about who is speaking
  /// <p>
  /// Params
  /// <p>
  /// Image -> Image of character speaking
  /// <p>
  /// Name -> Name that is displayed
  /// <p>
  /// x -> x alignment (-1 to 1)
  /// <p>
  /// y -> y alignment (-1 to 1)
  /// <p>
  /// widthFactor -> how wide image is (0 to 1)
  /// <p>
  /// heightFactor -> how tall image is (0 to 1)
  /// <p>
  /// left -> true = image on left, name tag on right, false = image on right, name tag on left
  Profile(
      {required this.image,
      required this.name,
      required this.x,
      required this.y,
      required this.widthFactor,
      required this.heightFactor,
      required this.left});

  /// Turtle
  static Profile you() {
    return Profile(
        image: CurrentUser.turtleSwimLeft,
        name: 'You',
        x: 1.4,
        y: 0.6,
        widthFactor: 0.5,
        heightFactor: 0.3,
        left: false);
  }

  /// Mom turtle
  static Profile mom() {
    return Profile(
        image: AppImages.momTurtle,
        name: 'Mom',
        x: -1.5,
        y: 0.55,
        widthFactor: 0.5,
        heightFactor: 0.3,
        left: true);
  }

  /// Penguin
  static Profile penguin() {
    return Profile(
        image: AppImages.penguin,
        name: 'Penguin',
        x: -1.5,
        y: 0.55,
        widthFactor: 0.5,
        heightFactor: 0.3,
        left: true);
  }

  /// Clown fish
  static Profile clownFish() {
    return Profile(
        image: AppImages.clownFish,
        name: 'Clown Fish',
        x: -1.2,
        y: 0.55,
        widthFactor: 0.5,
        heightFactor: 0.3,
        left: true);
  }

  /// Octopus
  static Profile octopus() {
    return Profile(
        image: AppImages.octopus,
        name: 'Octopus',
        x: -1.3,
        y: 0.65,
        widthFactor: 0.5,
        heightFactor: 0.3,
        left: true);
  }
}

class MyDialog {
  Profile profile;
  Widget text;

  /// Holds profile and text
  MyDialog({required this.profile, required this.text});
}
