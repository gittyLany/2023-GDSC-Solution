import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle/auth/boarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:turtle/pages/world_select/main_world.dart';
import 'package:turtle/services/functions/authentication_services.dart';
import 'package:turtle/services/functions/db_functions.dart';
import 'package:turtle/utils/current_user.dart';
import 'firebase_options.dart';

Future<void> main() async {

  // For firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // Part of the tutorial I followed
    return MultiProvider(providers: [
          Provider<AuthenticationService>(
              create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
              create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null,
          ),
        ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthenticationWrapper(),
      )
    );
  }
}

/// No clue -> I just followed a tutorial
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      CurrentUser.uid = firebaseUser.uid;
      CurrentUser.email = firebaseUser.email!;

      if (DBFunctions.newAccount) {
        DBFunctions.createNewUser();
      }
      // Reload data
      else {
        DBFunctions.loadUserData();
      }

      return const MainWorldScreen();
    }
    return const BoardingScreen();
  }

}




