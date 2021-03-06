import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

export 'package:firebase_auth/firebase_auth.dart';
export 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class ChsAuth {
  ChsAuth._();


  static FirebaseUser _user;

  static FirebaseUser setUser(FirebaseUser user) => _user = user;

  static FirebaseUser get getUser => _user;

  static GoogleSignInAccount get getGoogleUser => _googleSignIn.currentUser;

  static Future<GoogleSignInAccount> silently() async => await _googleSignIn.signInSilently();

  static Stream<FirebaseUser> get onAuthStateChanged => _auth.onAuthStateChanged;

  static Future<FirebaseUser> signInWithGoogle() async {
    try {
      GoogleSignInAccount currentUser = _googleSignIn.currentUser;
      currentUser ??= await _googleSignIn.signIn();

      if (currentUser == null) {
        throw PlatformException(code: "Canceled", message: "Sign in cancelled");
      }

      final GoogleSignInAuthentication auth = await currentUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: auth.idToken, accessToken: auth.accessToken);
      final FirebaseUser user = await _auth.signInWithCredential(credential);
      assert(user != null);
      assert(!user.isAnonymous);

      setUser(user);
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
      setUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  static bool newUser() {
    FirebaseUserMetadata data = _user.metadata;
    int createdAt = data.creationTimestamp;
    int lastSignedIn = data.lastSignInTimestamp;
    return lastSignedIn - createdAt < 10;
  }

  static Future<FirebaseUser> createUserWithEmail(String email, String password) async {
    try {
      FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      assert(user != null);
      assert(await user.getIdToken() != null);
      setUser(user);
      return user;

    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> verifyEmail() async {
    FirebaseUser user = await _auth.currentUser();
    bool done = false;
    if (user != null) {
      await user.sendEmailVerification().whenComplete(() => done = true);
    } else {
      print(user);
    }
    return done;
  }

  static Future<bool> userVerified(FirebaseUser user) async {
    return user.isEmailVerified;
  }

  static Future<bool> resetPassword(String email) async {
    bool done;
    await _auth.sendPasswordResetEmail(email: email).whenComplete((){
      done = true;
    });
    return done;
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

