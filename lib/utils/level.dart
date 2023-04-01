/// Enum that holds next goal of user for levels
/// <p>
/// Example: talk to mom
enum Level {
  /// First part of level 1
  /// <p>
  /// Mom will give task of grocery shopping
  talkToMom,

  /// Second part of level 1
  /// <p>
  /// Need to head to grocery store
  goToStore,

  /// Third part of level 1
  /// <p>
  /// When in grocery store
  /// <p>
  /// Will change help dialog to tell user what items mom wants
  buyFood,

  /// When user is going to trash can
  throwTrash,

  /// After user decided to litter or throw trash
  goHome,

  /// Level 2 start
  eatFood
}
