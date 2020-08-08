
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_meter/Models/users.dart';

class AuthService{

  final FirebaseAuth _auth =FirebaseAuth.instance;
  //user object for firebase user
  User _userFromFirebaseUser(FirebaseUser user){
    return user !=null ? User(uid: user.uid) : null;
  }
  //auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }
  //sign in with email and password
  Future signInwithEmailAndPassword(String email,String password)async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString()) ;
      return null;
    }
  }
  //sign out
  Future signout() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}