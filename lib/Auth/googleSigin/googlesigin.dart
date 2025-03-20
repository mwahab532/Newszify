import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:mynewsapp/views/Home.dart';
class Googlesigin {
   googleSignInaccount(BuildContext context) async {
    try {
      final GoogleSignInAccount? guser = await GoogleSignIn().signIn();
      if (guser == null) {
        return;
      }
      final GoogleSignInAuthentication gauth = await guser.authentication;
      final Credential = GoogleAuthProvider.credential(
        accessToken: gauth.accessToken,
        idToken: gauth.idToken,
      );
      await FirebaseAuth.instance
          .signInWithCredential(Credential)
          .then((value) {
        final route = MaterialPageRoute(
          builder: (context) => Home(),
        );
        Navigator.push(context, route);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green, content: Text("SignIn Successful")));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("SignIn Error occurs: ${e.toString()}")));
    }
  }
}