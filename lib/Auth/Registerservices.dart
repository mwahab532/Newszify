import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynewsapp/controllers/authcontrollers.dart';

class Registerservices {
  Registercontrollers registercontrollers = Registercontrollers();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Handle specific exceptions
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = "The password provided is too weak.";
          break;
        case "email-already-in-use":
          errorMessage = "The account already exists for that email.";
          break;
        default:
          errorMessage = "Failed to sign in: ${e.message}";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(errorMessage),
        ),
      );
      rethrow; // Rethrow the exception to propagate the error
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Something went wrong"),
        ),
      );
      rethrow; // Rethrow any other exceptions
    } finally {
      registercontrollers.registerbtnController.reset();
    }
  }
}
