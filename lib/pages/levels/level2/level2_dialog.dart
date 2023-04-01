import 'package:flutter/material.dart';
import 'package:turtle/utils/current_user.dart';

import '../../../utils/styles.dart';
import '../../../services/functions/db_functions.dart';
import '../../tabs/my_dialog.dart';

class Level2Dialog {
  /// Holds all dialog for level 2
  /// <p>
  /// MUST CALL Level2Dialog.refreshList to initialize
  static List<MyDialog> dialogs = List.empty(growable: true);

  /// Where dialog cuts of
  /// <p>
  /// User gets to choose from 4 choices
  static const int choiceBreakIndex = 10;

  /// Plastic bag mini game
  static const int minigame1BreakIndex = 19;

  /// Show image of landfill
  static const int imageIndex = 28;

  /// Conversation cuts from plastic bag to trash
  static const int sceneChangeIndex = 30;

  /// Wrapper mini game
  static const int minigame2BreakIndex = 38;

  /// End of dialog for level 2
  static const int end = 59;

  /// What user chose
  /// <p>
  /// Changing this will change what mom says
  /// <p>
  /// Call Level2Dialog.refreshChoiceDialog after setting this to see changes
  /// <p>
  /// Honestly should just add
  static int choiceSelected = 0;

  /// Refreshes turtle costumes
  static Future<void> refreshList() async {
    dialogs.clear();
    dialogs.add(_dialog0());
    dialogs.add(_dialog1());
    dialogs.add(_dialog2());
    dialogs.add(_dialog3());
    dialogs.add(_dialog4());
    dialogs.add(_dialog5());
    dialogs.add(_dialog6());
    dialogs.add(_dialog7());
    dialogs.add(_dialog8());
    dialogs.add(_dialog9());
    dialogs.add(_dummy());
    dialogs.add(_dialog11());
    dialogs.add(_dialog12());
    dialogs.add(_dialog13());
    dialogs.add(_dialog14());
    dialogs.add(_dialog15());
    dialogs.add(_dialog16());
    dialogs.add(_dialog17());
    dialogs.add(_dialog18());
    dialogs.add(_dialog19());
    dialogs.add(_dialog20());
    dialogs.add(_dialog21());
    dialogs.add(_dialog22());
    dialogs.add(_dialog23());
    dialogs.add(_dialog24());
    dialogs.add(await _dialog25());
    dialogs.add(_dialog26());
    dialogs.add(_dialog27());
    dialogs.add(_dialog28());
    dialogs.add(_dialog29());
    dialogs.add(_dialog30());
    dialogs.add(_dialog31());
    dialogs.add(_dialog32());
    dialogs.add(_dialog33());
    dialogs.add(_dialog34());
    dialogs.add(_dialog35());
    dialogs.add(_dialog36());
    dialogs.add(_dialog37());
    dialogs.add(_dialog38());
    dialogs.add(_dialog39());
    dialogs.add(_dialog40());
    dialogs.add(_dialog41());
    dialogs.add(_dialog42());
    dialogs.add(_dialog43());
    dialogs.add(_dialog44());
    dialogs.add(_dialog45());
    dialogs.add(_dialog46());
    dialogs.add(_dialog47());
    dialogs.add(_dialog48());
    dialogs.add(_dialog49());
    dialogs.add(_dialog50());
    dialogs.add(_dialog51());
    dialogs.add(_dialog52());
    dialogs.add(_dialog53());
    dialogs.add(_dialog54());
    dialogs.add(_dialog55());
    dialogs.add(await _dialog56());
    dialogs.add(_dialog57());
    dialogs.add(_dialog58());
  }

  /// Refreshes dialog based on choice chosen
  static void refreshChoiceDialog() {
    dialogs[11] = _dialog11();
  }

  static MyDialog _dialog0() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text(
          'Thanks for getting the groceries!',
          style: Styles.dialogStyle,
          textAlign: TextAlign.center,
        ));
  }

  static MyDialog _dialog1() {
    return MyDialog(
      profile: Profile.you(),
      text: Text('No problem Mom!', style: Styles.dialogStyle),
    );
  }

  static MyDialog _dialog2() {
    return MyDialog(
        profile: CurrentUser.hasReusableBag ? Profile.you() : Profile.mom(),
        text: CurrentUser.hasReusableBag
            ? Text(
                'Today at the grocery store, the octopus cashier asked me if I need a plastic bag',
                style: Styles.dialogStyle,
                textAlign: TextAlign.center)
            : Text('Hey, I noticed you forgot the reusable bag...(￣ ￣|||)',
                style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog3() {
    return MyDialog(
        profile: Profile.you(),
        text: CurrentUser.hasReusableBag
            ? Text('But I said, "No thanks!" because I had a reusable bag!',
                style: Styles.dialogStyle, textAlign: TextAlign.center)
            : Text(
                'Yeah, I forgot...I had to use plastic bags (⁄ ⁄>⁄ ▽ ⁄ <⁄ ⁄)',
                style: Styles.dialogStyle,
                textAlign: TextAlign.center));
  }

  static MyDialog _dialog4() {
    return MyDialog(
        profile: Profile.mom(),
        text: CurrentUser.hasReusableBag
            ? Text(
                'Good for you! Do you remember why we prefer reusable bags? ଽ (৺ੋ ௦ ৺ੋ )৴',
                style: Styles.dialogStyle,
                textAlign: TextAlign.center)
            : Text(
                'I guess I gotta tell you a story...about the plastic bag ╮( ˘_˘ )╭',
                style: Styles.dialogStyle,
                textAlign: TextAlign.center));
  }

  static MyDialog _dialog5() {
    return MyDialog(
        profile: Profile.you(),
        text: CurrentUser.hasReusableBag
            ? Text('Ooh! Yes...but I want to hear it again!',
                style: Styles.dialogStyle, textAlign: TextAlign.center)
            : Text('Not again...〜(＞＜)〜',
                style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog6() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('There once was a plastic bag, named Plastic Bag',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog7() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('How original...',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog8() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('Plastic Bag had a bright future ahead...',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog9() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text(
            'Hmmm...Wait a second...How long do plastic bags live for again? (・・ ) ?',
            style: Styles.dialogStyle,
            textAlign: TextAlign.center));
  }

  static MyDialog _dummy() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('Should not be seeing this',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog11() {
    return MyDialog(profile: Profile.mom(), text: _getChoiceText());
  }

  /// Different dialog based on what choice user chose
  static Widget _getChoiceText() {
    String text = '';
    if (choiceSelected == 0) {
      text =
          'Hmm... It\'s WAY longer than that. They can live up to 1000 years!';
    } else if (choiceSelected == 1) {
      text = 'Close... Not really. They actually can live up to 1000 years!';
    } else if (choiceSelected == 2) {
      text =
          'I think you got confused between the human and the plastic bag\'s life span. '
          'Plastic bags can actually live up to 1000 years!';
    } else {
      text = 'Yeah you are right! Plastic bags live a very long life!';
    }

    return Text(text, style: Styles.dialogStyle, textAlign: TextAlign.center);
  }

  static MyDialog _dialog12() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text(
            'As the plastic slowly ages, they pee out dangerous chemicals into the environment (⊙_⊙)',
            style: Styles.dialogStyle,
            textAlign: TextAlign.center));
  }

  static MyDialog _dialog13() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('Ewwww! (＃＞＜)',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog14() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text(
            'Yeah! That\'s why we throw plastic bags into the trash, '
            'so we do not have to deal with the harmful pee (￣ω￣)',
            style: Styles.dialogStyle,
            textAlign: TextAlign.center));
  }

  static MyDialog _dialog15() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('Oh. So where does the plastic bag go?',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog16() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('Ah, we send it to the landfill.',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog17() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('Is that a nice place? Do you have pictures?',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog18() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text(
            'I do have pictures. But you got to prove yourself first! (⁀ᗢ⁀)',
            style: Styles.dialogStyle,
            textAlign: TextAlign.center));
  }

  static MyDialog _dialog19() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('Question...If it\'s only one plastic bag...',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog20() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('Is it really that dangerous? Do they really pee that much?',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog21() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text(
            'Well, I guess that is true, in that, one plastic bag can\'t be THAT bad. I mean it\'s so small! (￣ ￣|||)',
            style: Styles.dialogStyle,
            textAlign: TextAlign.center));
  }

  static MyDialog _dialog22() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('But imagine if another person forgot their reusable bags',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog23() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('Then another!',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog24() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('And another!',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static Future<MyDialog> _dialog25() async {
    return MyDialog(profile: Profile.mom(), text: await _getPlasticBagText());
  }

  static Future<Widget> _getPlasticBagText() async {
    int plasticBag = await DBFunctions.getPlasticBagUsers();
    int total = await DBFunctions.getTotalUsers();

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Styles.dialogStyle,
        children: [
          const TextSpan(
            text: 'In fact, ',
          ),
          TextSpan(
              text: '$plasticBag',
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold)),
          const TextSpan(
            text: ' out of ',
          ),
          TextSpan(
              text: '$total',
              style: const TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold)),
          const TextSpan(text: ' users forgot their reusable bags yesterday'),
        ],
      ),
    );
  }

  static MyDialog _dialog26() {
    return MyDialog(
        profile: Profile.you(),
        text: CurrentUser.hasReusableBag
            ? Text('So glad I remembered my reusable bag. ヽ(ー_ー )ノ',
                style: Styles.dialogStyle, textAlign: TextAlign.center)
            : Text('Oops...I was one of them... (￣_￣)・・・',
                style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog27() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('Anyway, here is the photo I promised.',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog28() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('That looks icky...ugh ┬┴┬┴┤(･_├┬┴┬┴',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog29() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text(
            'So, in conclusion, Plastic Bag prepares '
            'for a long sleep in their new home: The Landfill.',
            style: Styles.dialogStyle,
            textAlign: TextAlign.center));
  }

  static MyDialog _dialog30() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text(
            'Oh my gosh, look at all the trash outside our neighbor\'s house',
            style: Styles.dialogStyle,
            textAlign: TextAlign.center));
  }

  static MyDialog _dialog31() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('Oh...It looks nice? （＾ω＾）',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog32() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('No.',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog33() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('Okay.',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog34() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('The wind will blow it away anyway.',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog35() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('Yeah...and it is also not really our problem',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog36() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('Where will the wind take the trash?',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog37() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('This sounds like...GAME TIME ┐(´ー｀)┌',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog38() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('Yeah so most trash ends up in the ocean.',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog39() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('Why? ┐(~ー~;)┌',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog40() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('There is more ocean than land in our world',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog41() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('Ah that stinks! We live in the ocean! ..・ヾ(。＞＜)シ',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog42() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('Do you know who else lives in the ocean?',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog43() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('You',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog44() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('＼(｀0´)／',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog45() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('It is fish ヽ(｀⌒´)ﾉ',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog46() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('I love fish!',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog47() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('I like eating fish...',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog48() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('And guess what fish are eating?',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog49() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('Plastic? Trash?',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog50() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('Yep righty-o spot on!',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog51() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('Can\'t fish tell the difference between plastic and food?',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog52() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text(
            'They use their nose to figure out if it is food or not. '
            'Unfortunately, plastic and food smell the same',
            style: Styles.dialogStyle,
            textAlign: TextAlign.center));
  }

  static MyDialog _dialog53() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('Oh, that\'s terrible',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog54() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('And guess who eats fish?',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog55() {
    return MyDialog(
        profile: Profile.you(),
        text: Text('OH NO! (ʃ⌣́,⌣́ƪ)',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static Future<MyDialog> _dialog56() async {
    return MyDialog(profile: Profile.mom(), text: await _getWrapperText());
  }

  static Future<Widget> _getWrapperText() async {
    int litter = await DBFunctions.getLitteringUsers();
    int total = await DBFunctions.getTotalUsers();

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Styles.dialogStyle,
        children: [
          const TextSpan(
            text: 'Yeah and guess what? Yesterday I spied ',
          ),
          TextSpan(
              text: '$litter',
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold)),
          const TextSpan(
            text: ' out of ',
          ),
          TextSpan(
              text: '$total',
              style: const TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold)),
          const TextSpan(text: ' turtles throwing trash through the air'),
        ],
      ),
    );
  }

  static MyDialog _dialog57() {
    return MyDialog(
        profile: Profile.you(),
        text: CurrentUser.littered
            ? Text('...',
                style: Styles.dialogStyle, textAlign: TextAlign.center)
            : Text('Oh that\'s a lot of turtles...',
                style: Styles.dialogStyle, textAlign: TextAlign.center));
  }

  static MyDialog _dialog58() {
    return MyDialog(
        profile: Profile.mom(),
        text: Text('Yeah let us hope none of the trash ends up in our dinner',
            style: Styles.dialogStyle, textAlign: TextAlign.center));
  }
}
