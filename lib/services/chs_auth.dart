import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class ChsAuth {
  ChsAuth._();

  static FirebaseUser _user;

  static FirebaseUser setUser(FirebaseUser user) => _user = user;
  static FirebaseUser get getUser => _user;

  static Future<GoogleSignInAccount> silently() async => await _googleSignIn.signInSilently();

  static Stream<FirebaseUser> get onAuthStateChanged => _auth.onAuthStateChanged;

  static Future<FirebaseUser> signInWithGoogle() async {
    try {
      GoogleSignInAccount currentUser = _googleSignIn.currentUser;
      currentUser ??= await _googleSignIn.signInSilently();
      currentUser ??= await _googleSignIn.signIn();

      if (currentUser == null) {
        throw PlatformException(code: "canceled");
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

  static Future<void> logOut() async {
    await _auth.signOut();
    _user = null;
  }

  static Future<void> logOutWithGoogle() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _user = null;
  }
}

