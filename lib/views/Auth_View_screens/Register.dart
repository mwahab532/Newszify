import 'package:email_otp_auth/email_otp_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynewsapp/Auth/Registerservices.dart';
import 'package:mynewsapp/controllers/authcontrollers.dart';
import 'package:mynewsapp/views/otpverification.dart';
import 'package:mynewsapp/widgets/buildauth_textfeild.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Authcontrollers authcontrollers = Authcontrollers();
  Registerservices _registerservices = Registerservices();
  Registercontrollers registercontrollers = Registercontrollers();
  final _formkey = GlobalKey<FormState>();
  final setFirestore = FirebaseFirestore.instance.collection("users");
  bool isVisible = false;
  Future<void> sendOtp() async {
    try {
      // showing CircularProgressIndicator.
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // getting response from sendOTP Method.
      var res = await EmailOtpAuth.sendOTP(
          email: registercontrollers.emailcontrollers.text);

      // poping out CircularProgressIndicator.
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // if response[message == "Email Send"] then..
      if (res["message"] == "Email Send" && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP Send Successfully ✅"),
          ),
        );
      }
      // else show Invalid Email Address.
      else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid E-Mail Address ❌"),
            ),
          );
        }
      }
    }
    // error handling
    catch (error) {
      throw error.toString();
    }
  }

  Future<void> saveData() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await setFirestore.doc(uid).set({
        "username": registercontrollers.usernamecontrollers.text,
      });
    }
  }

  @override
  void dispose() {
    registercontrollers.emailcontrollers.dispose();
    registercontrollers.passwordcontrollers.dispose();
    registercontrollers.otpcontrollers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 25,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70, left: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.asset(
                    "assets/Newszify.png",
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Please create an account to get started.",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              Center(
                child: Container(
                  height: 60,
                  width: 305,
                  child: Center(
                    child: AuthTextfeild().buildAuthTextField(
                      registercontrollers.usernamecontrollers,
                      "Enter username",
                      (text) {
                        if (text!.isEmpty) {
                          return "Username should not be Empty";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              buildEmailField(),
              AuthTextfeild().buildAuthTextField(
                registercontrollers.passwordcontrollers,
                "Password",
                (text) {
                  if (text!.isEmpty) return "Password can't be empty";
                  if (text.length < 6)
                    return "Password must be at least 6 characters";
                  return null;
                },
                isObscure: !isVisible,
                iconbuttion: IconButton(
                  icon:
                      Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedLoadingButton(
                  controller: registercontrollers.registerbtnController,
                  color: Colors.red,
                  successColor: Colors.green,
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      try {
                        await _registerservices.createUserWithEmailAndPassword(
                          email: registercontrollers.emailcontrollers.text,
                          password:
                              registercontrollers.passwordcontrollers.text,
                          context: context,
                        );
                        // Only proceed if registration is successful
                        await saveData();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Otpverification()),
                        );
                      } catch (e) {
                        registercontrollers.registerbtnController.reset();
                        return;
                        // Handle any errors that occur during registration
                      } finally {
                        registercontrollers.registerbtnController.reset();
                      }
                    } else {
                      registercontrollers.registerbtnController.reset();
                      return;
                    }
                  },
                  child:
                      Text("Next", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return Center(
      child: Container(
        height: 60,
        width: 305,
        child: TextFormField(
          controller: registercontrollers.emailcontrollers,
          validator: (text) => text!.isEmpty ? "Email can't be empty" : null,
          decoration: InputDecoration(
            suffixIcon: TextButton(onPressed: sendOtp, child: Text("Send OTP")),
            border: OutlineInputBorder(),
            hintText: "email@example.com",
          ),
        ),
      ),
    );
  }
}
