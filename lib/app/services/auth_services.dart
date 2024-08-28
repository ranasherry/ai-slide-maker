import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:slide_maker/app/routes/app_pages.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
      // Handle successful sign-in (e.g., navigate to a home page)
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that email.');
      } else {
        print(e.code); // Print other error codes
      }
      // Handle errors appropriately (e.g., show a snackbar)
      return false;
    }
  }

  
  //start of code added by rizwan
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async{
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if(googleSignInAccount != null){
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
      );
      
      // getting users credentials
      UserCredential result = await firebaseAuth.signInWithCredential(authCredential);
      User? user = result.user;

      print(user?.email);
      if(result != null){
        Get.toNamed(Routes.AiSlideAssistant);
      }

    }
    
  }

  Future<void> signOutWithGoogle()async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }
  // end of code added by rizwan

  // Other sign-in methods (e.g., sign in with Google) can be added here
}
