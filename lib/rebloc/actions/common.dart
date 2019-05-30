import 'package:firebase_auth/firebase_auth.dart';
import 'package:rebloc/rebloc.dart';

class ChsOnInitAction extends Action {
  const ChsOnInitAction();
}

class ChsOnDisposeAction extends Action {
  const ChsOnDisposeAction();
}

class ChsOnLoginAction extends Action {
  final FirebaseUser user;
  const ChsOnLoginAction(this.user);
}

class ChsOnLogOutAction extends Action {
  const ChsOnLogOutAction();
}

class VoidAction extends Action {
  const VoidAction();
}