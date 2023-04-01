import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turtle/utils/accessory.dart';
import 'package:turtle/utils/current_user.dart';

/// Class that holds a variety of database functions
class DBFunctions {
  /// Name of collection that stores info of users
  static const String users = "users";

  /// Name of collection that stores turtle level info
  static const String turtle = "turtle";

  /// Name of collection that stores stats
  static const String stats = "stats";

  static bool newAccount = false;

  /// Creates new user data based on current user info
  static void createNewUser() {
    var db = FirebaseFirestore.instance;

    final profile = <String, String>{"email": CurrentUser.email};

    db
        .collection(users)
        .doc(CurrentUser.uid)
        .set(profile)
        .onError((e, _) => log("Error writing to user document: $e"));

    // Turtle entry
    final turtleData = {
      "level1_complete": false,
      "level2_complete": false,
      "shades_unlocked": false,
      "flower_unlocked": false,
      "disguise_unlocked": false,
      "cap_unlocked": false,
      "hat_unlocked": false,
      "reusable_bag": false,
      "littered": false,
      "current_costume": Accessory.normal.toString()
    };

    CurrentUser.guest = false;

    db
        .collection(turtle)
        .doc(CurrentUser.uid)
        .set(turtleData)
        .onError((e, _) => log("Error writing to turtle document: $e"));
  }

  /// User already has an account
  /// <p>
  /// Loading data into CurrentUser
  static void loadUserData() {
    var db = FirebaseFirestore.instance;

    final docRef = db.collection(turtle).doc(CurrentUser.uid);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        CurrentUser.guest = false;
        CurrentUser.level1Complete = data['level1_complete'];
        CurrentUser.level2Complete = data['level2_complete'];
        CurrentUser.shadesUnlocked = data['shades_unlocked'];
        CurrentUser.flowerUnlocked = data['flower_unlocked'];
        CurrentUser.disguiseUnlocked = data['disguise_unlocked'];
        CurrentUser.capUnlocked = data['hat_unlocked'];
        CurrentUser.hasReusableBag = data['reusable_bag'];
        CurrentUser.littered = data['littered'];

        String costume = data['current_costume'];

        if (costume == Accessory.normal.toString()) {
          CurrentUser.setAccessories(Accessory.normal);
        } else if (costume == Accessory.shades.toString()) {
          CurrentUser.setAccessories(Accessory.shades);
        } else if (costume == Accessory.topHat.toString()) {
          CurrentUser.setAccessories(Accessory.topHat);
        } else if (costume == Accessory.flower.toString()) {
          CurrentUser.setAccessories(Accessory.flower);
        } else if (costume == Accessory.disguise.toString()) {
          CurrentUser.setAccessories(Accessory.disguise);
        }
      },
      onError: (e) => log("Error getting document: $e"),
    );
  }

  /// Updates 'level1_completed' in database
  /// <p>
  /// Call method to update
  static Future<void> updateLevel1Status(bool completed) async {
    var db = FirebaseFirestore.instance;
    final ref = db.collection(turtle).doc(CurrentUser.uid);

    ref.update({'level1_complete': completed});
  }

  /// Updates 'level2_completed' in database
  /// <p>
  /// Call method to update
  static Future<void> updateLevel2Status(bool completed) async {
    var db = FirebaseFirestore.instance;
    final ref = db.collection(turtle).doc(CurrentUser.uid);

    ref.update({'level2_complete': completed});
  }

  /// Updates if the cap has been unlocked in database
  /// <p>
  /// Call method to update
  static Future<void> updateCapStatus(bool unlocked) async {
    var db = FirebaseFirestore.instance;
    final ref = db.collection(turtle).doc(CurrentUser.uid);

    ref.update({'cap_unlocked': unlocked});
  }

  /// Updates if the disguise has been unlocked in database
  /// <p>
  /// Call method to update
  static Future<void> updateDisguiseStatus(bool unlocked) async {
    var db = FirebaseFirestore.instance;
    final ref = db.collection(turtle).doc(CurrentUser.uid);

    ref.update({'disguise_unlocked': unlocked});
  }

  /// Updates if the flower has been unlocked in database
  /// <p>
  /// Call method to update
  static Future<void> updateFlowerStatus(bool unlocked) async {
    var db = FirebaseFirestore.instance;
    final ref = db.collection(turtle).doc(CurrentUser.uid);

    ref.update({'flower_unlocked': unlocked});
  }

  /// Updates if the hat has been unlocked in database
  /// <p>
  /// Call method to update
  static Future<void> updateHatStatus(bool unlocked) async {
    var db = FirebaseFirestore.instance;
    final ref = db.collection(turtle).doc(CurrentUser.uid);

    ref.update({'hat_unlocked': unlocked});
  }

  /// Updates if the shades has been unlocked in database
  /// <p>
  /// Call method to update
  static Future<void> updateShadesStatus(bool unlocked) async {
    var db = FirebaseFirestore.instance;
    final ref = db.collection(turtle).doc(CurrentUser.uid);

    ref.update({'shades_unlocked': unlocked});
  }

  /// Updates the user's current costume in database
  /// <p>
  /// Call method to update
  static Future<void> updateCurrentCostume(Accessory accessory) async {
    var db = FirebaseFirestore.instance;
    final ref = db.collection(turtle).doc(CurrentUser.uid);

    ref.update({'current_costume': accessory.toString()});
  }

  /// Updates if the user littered in database
  /// <p>
  /// IMPORTANT: DOES NOT UPDATE STATS, CALL DBFunctions.incLitter()
  /// Call method to update
  static Future<void> updateLitterStatus(bool littered) async {
    var db = FirebaseFirestore.instance;
    final ref = db.collection(turtle).doc(CurrentUser.uid);

    ref.update({'littered': littered});
  }

  /// Updates if the user brought a reusable bag in database
  /// <p>
  /// IMPORTANT: DOES NOT UPDATE STATS, CALL DBFunctions.incReusableBags()
  /// <p>
  /// Call method to update
  static Future<void> updateBagStatus(bool hasReusableBag) async {
    var db = FirebaseFirestore.instance;
    final ref = db.collection(turtle).doc(CurrentUser.uid);

    ref.update({'reusable_bag': hasReusableBag});
  }

  /// Increases the numbered of users who littered by 1
  static Future<void> incLitter() async {
    var db = FirebaseFirestore.instance;
    final ref = db.collection(stats).doc('turtle');

    ref.update({'littered_users': FieldValue.increment(1)});
  }

  /// Increases the numbered of users who brought reusable bags by 1
  static Future<void> incReusableBags() async {
    var db = FirebaseFirestore.instance;
    final ref = db.collection(stats).doc('turtle');

    ref.update({'has_bag_users': FieldValue.increment(1)});
  }

  /// Increases the numbered of users who finished turtle level 1 by 1
  static Future<void> incTotalTurtle1Users() async {
    var db = FirebaseFirestore.instance;
    final ref = db.collection(stats).doc('turtle');

    ref.update({'total_users': FieldValue.increment(1)});
  }

  /// Get number of users who used plastic bags
  static Future<int> getPlasticBagUsers() async {
    int plasticBag = 0;
    var db = FirebaseFirestore.instance;
    final ref = db.collection(stats).doc('turtle');
    await ref.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;

      int? bagUsers = data['has_bag_users'];
      int? total = data['total_users'];

      plasticBag = total! - bagUsers!;
    });
    return plasticBag;
  }

  /// Get number of users who littered
  static Future<int> getLitteringUsers() async {
    int litter = 0;
    var db = FirebaseFirestore.instance;
    final ref = db.collection(stats).doc('turtle');
    await ref.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;

      litter = data['littered_users'];
    });
    return litter;
  }

  /// Get total number of users
  static Future<int> getTotalUsers() async {
    int total = 0;
    var db = FirebaseFirestore.instance;
    final ref = db.collection(stats).doc('turtle');
    await ref.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;

      total = data['total_users'];
    });
    return total;
  }
}
