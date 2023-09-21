import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxContoller {
  Future<UserCredential?> loginMethod({email, password, context}) async {
    UserCredential? setCredential;

    try {
      userCredential = awiat auth.signInithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? serCredential;

    try {
      userCredential = awiat auth.createInithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }


  storeUserData({name, password, email}) async {
    DocumentReference store = firestore.collection(userCollection).doc(currentUser!.uid);
    store.set({'name': name, 'password': password, 'email': email});
  }


  signoutMethod(context) async {
    try {
      await auth.signOut();
    }
    catch(e) {
      VxToast.show(context, msg: e.toString());
    }
  }

}