import 'package:flutter/material.dart';
import 'package:turtle/utils/accessory.dart';

import 'package:turtle/utils/images.dart';

import 'level.dart';

///
/// Class that holds user info
///
class CurrentUser {
  /// ONLY A GETTER -> DO NOT CHANGE
  static Accessory currentAccessory = Accessory.normal;

  ///
  /// Holds if player is a guest
  /// <p>
  /// A guest's progress will not be stored. Only their choices will be stored.
  ///
  static bool guest = false;

  /// Holds image of turtle walking left
  /// <p>
  /// Default is turtle with no accessories
  /// <p>
  /// Use CurrentUser.setAccessories to change looks
  static Image turtleWalkLeft = AppImages.turtleWalkLeft;

  /// Holds image of turtle walking right
  /// <p>
  /// Default is turtle with no accessories
  /// <p>
  /// Use CurrentUser.setAccessories to change looks
  static Image turtleWalkRight = AppImages.turtleWalkRight;

  /// Holds image of turtle swimming left
  /// <p>
  /// Default is turtle with no accessories
  /// <p>
  /// Use CurrentUser.setAccessories to change looks
  static Image turtleSwimLeft = AppImages.turtleSwimLeft;

  /// Holds image of turtle swimming right
  /// <p>
  /// Default is turtle with no accessories
  /// <p>
  /// Use CurrentUser.setAccessories to change looks
  static Image turtleSwimRight = AppImages.turtleSwimRight;

  /// Holds user ID of user
  /// <p>
  /// Guest will not have an ID
  /// <p>
  /// Each user will has a unique ID
  static String uid = "";

  /// Holds email of user
  /// <p>
  /// Guest will not have email
  static String email = "";

  /// If user completed level 1
  static bool level1Complete = false;

  /// If user completed level 2
  static bool level2Complete = false;

  /// If user unlocked the shades accessory
  static bool shadesUnlocked = false;

  /// If user unlocked the flower accessory
  static bool flowerUnlocked = false;

  /// If user unlocked the disguise
  static bool disguiseUnlocked = false;

  /// If user unlocked the baseball cap
  static bool capUnlocked = false;

  /// If user unlocked the top hat
  static bool hatUnlocked = false;

  /// If user has reusable bag in inventory
  static bool hasReusableBag = false;

  /// If user littered
  static bool littered = false;

  /// Holds story progress
  /// <p>
  /// Possible levels -> talkToMom
  static Level nextGoal = Level.talkToMom;

  /// Utility method that sets walking and swimming images of turtle
  /// <p>
  /// Usage: CurrentUser.setAccessories(Accessory.cap)
  static setAccessories(Accessory accessory) {
    currentAccessory = accessory;
    if (accessory == Accessory.cap) {
      turtleWalkLeft = AppImages.turtleWalkLeftCap;
      turtleWalkRight = AppImages.turtleWalkRightCap;
      turtleSwimLeft = AppImages.turtleSwimLeftCap;
      turtleSwimRight = AppImages.turtleSwimRightCap;
    } else if (accessory == Accessory.disguise) {
      turtleWalkLeft = AppImages.turtleWalkLeftDisguise;
      turtleWalkRight = AppImages.turtleWalkRightDisguise;
      turtleSwimLeft = AppImages.turtleSwimLeftDisguise;
      turtleSwimRight = AppImages.turtleSwimRightDisguise;
    } else if (accessory == Accessory.flower) {
      turtleWalkLeft = AppImages.turtleWalkLeftFlower;
      turtleWalkRight = AppImages.turtleWalkRightFlower;
      turtleSwimLeft = AppImages.turtleSwimLeftFlower;
      turtleSwimRight = AppImages.turtleSwimRightFlower;
    } else if (accessory == Accessory.normal) {
      turtleWalkLeft = AppImages.turtleWalkLeft;
      turtleWalkRight = AppImages.turtleWalkRight;
      turtleSwimLeft = AppImages.turtleSwimLeft;
      turtleSwimRight = AppImages.turtleSwimRight;
    } else if (accessory == Accessory.shades) {
      turtleWalkLeft = AppImages.turtleWalkLeftShades;
      turtleWalkRight = AppImages.turtleWalkRightShades;
      turtleSwimLeft = AppImages.turtleSwimLeftShades;
      turtleSwimRight = AppImages.turtleSwimRightShades;
    } else if (accessory == Accessory.topHat) {
      turtleWalkLeft = AppImages.turtleWalkLeftTopHat;
      turtleWalkRight = AppImages.turtleWalkRightTopHat;
      turtleSwimLeft = AppImages.turtleSwimLeftTopHat;
      turtleSwimRight = AppImages.turtleSwimRightTopHat;
    }
  }
}
