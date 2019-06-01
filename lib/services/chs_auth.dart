import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class ChsAuth {
  ChsAuth._();


  static Future<FirebaseUser> get getUser => _auth.currentUser();

  static Future<GoogleSignInAccount> silently() async => await _googleSignIn.signInSilently();

  static Stream<FirebaseUser> get onAuthStateChanged => _auth.onAuthStateChanged;

  static Future<FirebaseUser> signInWithGoogle() async {
    try {
      GoogleSignInAccount currentUser = _googleSignIn.currentUser;
      currentUser ??= await _googleSignIn.signInSilently();
      currentUser ??= await _googleSignIn.signIn();

      if (currentUser == null) {
        throw PlatformException(code: "Canceled", message: "Sign in cancelled");
      }

      final GoogleSignInAuthentication auth = await currentUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: auth.idToken, accessToken: auth.accessToken);
      final FirebaseUser user = await _auth.signInWithCredential(credential);
      assert(user != null);
      assert(!user.isAnonymous);

      return user;

    }  catch (e) {
      rethrow;
    }
  }

  static Future<FirebaseUser> signInWithEmail(String email, String password ) async {
    try {
      FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      assert(user != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      return user;

    } catch (e) {
      rethrow;
    }
  }

  static Future<FirebaseUser> createUserWithEmail(String email, String password) async {
    try {
      FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      assert(user != null);
      assert(await user.getIdToken() != null);
      return user;

    } catch (e) {
      rethrow;
    }
  }

  static Future<void> logOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  static String getExceptionString(Exception e) {
    if(e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this e-mail not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'Sign in cancelled':
          return 'User cancelled sign in process.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }
}

