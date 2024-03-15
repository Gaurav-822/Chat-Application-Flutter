import 'package:chat_app/Functions/profile_function.dart';
import 'package:chat_app/Functions/toasts.dart';
import 'package:firebase_auth/firebase_auth.dart';

createUser(String emailAddress, password) async {
  showToastMessage("Sigining You In");
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    showToastMessage("Yay, welcome to Titly!");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      showToastMessage('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      showToastMessage('The account already exists for that email.');
    }
  } catch (e) {
    showToastMessage(e.toString());
  }
}

signUserIn(String emailAddress, password) async {
  if (emailAddress == "" || password == "") {
    showToastMessage("Enter Credentials");
  }
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      showToastMessage('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      showToastMessage('Wrong password provided for that user.');
    }
  }
}

resetPassword(String emailAddress) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);
    showToastMessage('Password reset email sent. Please check your inbox.');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'invalid-email') {
      showToastMessage('Invalid email address.');
    } else if (e.code == 'user-not-found') {
      showToastMessage('No user found for that email.');
    }
  } catch (e) {
    showToastMessage(e.toString());
  }
}

signOut() async {
  showToastMessage("Logged Out");
  await FirebaseAuth.instance.signOut();
}
