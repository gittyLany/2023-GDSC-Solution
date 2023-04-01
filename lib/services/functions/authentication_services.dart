import 'package:firebase_auth/firebase_auth.dart';

import 'db_functions.dart';

///
/// From Youtube Video https://youtu.be/oJ5Vrya3wCQ
/// <p>
/// Handles signing in, signing up, signing out the user
///
class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      DBFunctions.newAccount = false;
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      DBFunctions.newAccount = true;
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
  }
}
