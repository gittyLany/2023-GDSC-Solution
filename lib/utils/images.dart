// Images
// cries: https://www.flutterbeads.com/add-image-in-flutter/
import 'package:flutter/material.dart';

import 'image_path.dart';

///
/// Class that stores images
/// <p>
/// Turtle Image Naming Convention
/// <p>
/// turtle(Walk/Swim)(Left/Right)(Extra)
/// <p>
/// Ex: turtleWalkLeftShades
/// <p>
/// Extra -> "" -> normal, Shades, Cap, Disguise, Flower, TopHat
/// <p>
/// CONTAINS IMAGES ONLY
///
///
class AppImages {
  // ------ Turtle ------
  static Image logo = Image.asset(ImagePath.turtleSwimRightShades);

  static Image babyTurtle = Image.asset('assets/images/turtle/Baby Turtle.png');

  // ------ Walking Left -----
  static Image turtleWalkLeft = Image.asset(ImagePath.turtleWalkLeft);
  static Image turtleWalkLeftCap = Image.asset(ImagePath.turtleWalkLeftCap);
  static Image turtleWalkLeftDisguise =
      Image.asset(ImagePath.turtleWalkLeftDisguise);
  static Image turtleWalkLeftFlower =
      Image.asset(ImagePath.turtleWalkLeftFlower);
  static Image turtleWalkLeftShades =
      Image.asset(ImagePath.turtleWalkLeftShades);
  static Image turtleWalkLeftTopHat =
      Image.asset(ImagePath.turtleWalkLeftTopHat);

  // ------ Walking Right ----
  static Image turtleWalkRight = Image.asset(ImagePath.turtleWalkRight);
  static Image turtleWalkRightCap = Image.asset(ImagePath.turtleWalkRightCap);
  static Image turtleWalkRightDisguise =
      Image.asset(ImagePath.turtleWalkRightDisguise);
  static Image turtleWalkRightFlower =
      Image.asset(ImagePath.turtleWalkRightFlower);
  static Image turtleWalkRightShades =
      Image.asset(ImagePath.turtleWalkRightShades);
  static Image turtleWalkRightTopHat =
      Image.asset(ImagePath.turtleWalkRightTopHat);

  // ------ Swimming Left -----
  static Image turtleSwimLeft = Image.asset(ImagePath.turtleSwimLeft);
  static Image turtleSwimLeftCap = Image.asset(ImagePath.turtleSwimLeftCap);
  static Image turtleSwimLeftDisguise =
      Image.asset(ImagePath.turtleSwimLeftDisguise);
  static Image turtleSwimLeftFlower =
      Image.asset(ImagePath.turtleSwimLeftFlower);
  static Image turtleSwimLeftShades =
      Image.asset(ImagePath.turtleSwimLeftShades);
  static Image turtleSwimLeftTopHat =
      Image.asset(ImagePath.turtleSwimLeftTopHat);

  // ------ Swimming Right ----
  static Image turtleSwimRight = Image.asset(ImagePath.turtleSwimRight);
  static Image turtleSwimRightCap = Image.asset(ImagePath.turtleSwimRightCap);
  static Image turtleSwimRightDisguise =
      Image.asset(ImagePath.turtleSwimRightDisguise);
  static Image turtleSwimRightFlower =
      Image.asset(ImagePath.turtleSwimRightFlower);
  static Image turtleSwimRightShades =
      Image.asset(ImagePath.turtleSwimRightShades);
  static Image turtleSwimRightTopHat =
      Image.asset(ImagePath.turtleSwimRightTopHat);

  // ------ NPCs ---
  static Image clownFish = Image.asset(ImagePath.clownFish);
  static Image momTurtle = Image.asset(ImagePath.momTurtle);
  static Image octopus = Image.asset(ImagePath.octopus);
  static Image penguin = Image.asset(ImagePath.penguin);

  // ------ Locations ------

  // Home
  static Image home1 = Image.asset(ImagePath.home1);
  static Image home2 = Image.asset(ImagePath.home2);
  static Image home3 = Image.asset(ImagePath.home3);
  static Image home4 = Image.asset(ImagePath.home4);

  // Grocery
  static Image aisle1 = Image.asset(ImagePath.aisle1);
  static Image aisle2 = Image.asset(ImagePath.aisle2);
  static Image aisle3 = Image.asset(ImagePath.aisle3);
  static Image aisleMain = Image.asset(ImagePath.aisleMain);
  static Image cashier = Image.asset(ImagePath.cashier);

  // Level selection
  static Image turtleLevel = Image.asset(ImagePath.turtleLevel);

  // Loading Screen
  static Image bubbles = Image.asset(ImagePath.bubbles);
  static Image leftSeaweed = Image.asset(ImagePath.leftSeaweed);
  static Image rightSeaweed = Image.asset(ImagePath.rightSeaweed);
  static Image seaBackground = Image.asset(ImagePath.seaBackground);

  // Minigames
  static Image swimMinigame = Image.asset(ImagePath.swimMinigame);
  static Image trashMinigame = Image.asset(ImagePath.trashMinigame);
  static Image wrapperMinigame = Image.asset(ImagePath.wrapperMinigame);
  static Image pbMinigame = Image.asset(ImagePath.pbMinigame);

  // Town
  static Image town1 = Image.asset(ImagePath.town1);
  static Image town2 = Image.asset(ImagePath.town2);
  static Image town3 = Image.asset(ImagePath.town3);
  static Image town4 = Image.asset(ImagePath.town4);

  //-------Items-------

  // Accessories
  static Image cap = Image.asset(ImagePath.cap);
  static Image disguise = Image.asset(ImagePath.disguise);
  static Image flower = Image.asset(ImagePath.flower);
  static Image shades = Image.asset(ImagePath.shades);
  static Image topHat = Image.asset(ImagePath.topHat);

  // Food

  // Aisle 1
  static Image apple = Image.asset(ImagePath.apple);
  static Image banana = Image.asset(ImagePath.banana);
  static Image strawberry = Image.asset(ImagePath.strawberry);

  // Aisle 2
  static Image carrot = Image.asset(ImagePath.carrot);
  static Image lettuce = Image.asset(ImagePath.lettuce);
  static Image pea = Image.asset(ImagePath.pea);

  // Aisle 3
  static Image fruitRollUp = Image.asset(ImagePath.fruitRollUp);
  static Image gummyWorms = Image.asset(ImagePath.gummyWorms);
  static Image kinderEgg = Image.asset(ImagePath.kinderEgg);

  // Key Items
  static Image plasticBag = Image.asset(ImagePath.plasticBag);
  static Image reusableBag = Image.asset(ImagePath.reusableBag);
  static Image wrapper = Image.asset(ImagePath.wrapper);
  static Image wrapperBird = Image.asset(ImagePath.wrapperBird);

  // Other
  static Image questionMark = Image.asset(ImagePath.questionMark);
  static Image circleSlash = Image.asset(ImagePath.circleSlash);
  static Image upArrow = Image.asset(ImagePath.upArrow);
  static Image rightArrow = Image.asset(ImagePath.rightArrow);
  static Image downArrow = Image.asset(ImagePath.downArrow);
  static Image leftArrow = Image.asset(ImagePath.leftArrow);
  static Image pbMiniGame1 = Image.asset(ImagePath.pbMiniGame1);
  static Image pbMiniGame2 = Image.asset(ImagePath.pbMiniGame2);
  static Image pbMiniGame3 = Image.asset(ImagePath.pbMiniGame3);
  static Image landfill = Image.asset(ImagePath.landfill);
}
