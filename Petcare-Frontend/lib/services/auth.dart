import 'package:PetCare/models/customUser.dart';
import "package:firebase_auth/firebase_auth.dart";

//This class is for communicating with firebase
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userToken;

  CustomUser _userFromFirebaseUser(User user) {
    return user != null
        ? CustomUser(
            uid: user.uid,
            email: user.email,
          )
        : null;
  }

  Future<CustomUser> getCurrentUserFromFirebaseUser() async {
    User currentUser = _auth.currentUser;
    return _userFromFirebaseUser(currentUser);
  }

  getToken() async {
    User firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    final tokenResult = await firebaseUser.getIdToken(true).catchError((e) {
      return null;
    });
    return tokenResult;
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential authResult = await _auth.signInAnonymously();
      User firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password

  Future signIn(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = authResult.user;
      final tokenResult = await firebaseUser.getIdToken(true);
      userToken = tokenResult;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signInWithCredential(AuthCredential cred) async {
    try {
      UserCredential authResult = await _auth.signInWithCredential(cred);
      User firebaseUser = authResult.user;
      final tokenResult = await firebaseUser.getIdToken(true);
      userToken = tokenResult;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString() + "SIGNINWITHCREDENTIALERROR");
      return null;
    }
  }

  Future changePassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 200;
    } catch (e) {
      return 400;
    }
  }

  //register with email&password

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = authResult.user;

      dynamic result = await signIn(email, password);

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteCurrentAccount() async {
    try {
      User firebaseUser = _auth.currentUser;
      firebaseUser.delete();
    } catch (e) {}
  }
}
