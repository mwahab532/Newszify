import 'package:email_otp_auth/email_otp_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynewsapp/Auth/Registerservices.dart';
import 'package:mynewsapp/controllers/authcontrollers.dart';
import 'package:mynewsapp/views/Home.dart';
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
  Registerservices registerservices = Registerservices();
  Registercontrollers registercontrollers = Registercontrollers();
  final _formkey = GlobalKey<FormState>();
  final setFirestore = FirebaseFirestore.instance.collection("users");
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

  Future<void> verifyOTP() async {
    try {
      var res = await EmailOtpAuth.verifyOtp(
        otp: registercontrollers.otpcontrollers.text,
      );

      // poping out CircularProgressIndicator.
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      if (res["message"] == "OTP Verified" && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email verified ✅"),
          ),
        );
      } else if (res["data"] == "Invalid OTP" && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid OTP ❌"),
          ),
        );
      } else if (res["data"] == "OTP Expired" && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP Expired ⚠️"),
          ),
        );
      } else {
        return;
      }
    } catch (error) {
      throw error.toString();
    }
  }

  void saveData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (uid != Null) {
      await setFirestore.doc(uid).set({
        "username": registercontrollers.usernamecontrollers.text,
      });
    }
  }
  bool isvisible = false;
  @override
  dispose() {
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
                padding: const EdgeInsets.only(top: 50, left: 20),
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
                  "Please create an account to get Started.",
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
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
              buildEmailFeild(),
              Center(
                child: AuthTextfeild().buildAuthTextField(
                  registercontrollers.passwordcontrollers,
                  "Password",
                  (text) {
                    if (text!.isEmpty) {
                      return "Password can't be Empty";
                    } else if (text.length < 6) {
                      return "Password must be 6 characters long";
                    }
                    return null;
                  },
                  isObscure: !isvisible,
                  iconbuttion: IconButton(
                    icon: isvisible
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isvisible = !isvisible;
                      });
                    },
                  ),
                ),
              ),
              Center(
                child: AuthTextfeild().buildAuthTextField(
                  registercontrollers.otpcontrollers,
                  "Enter otp",
                  (text) {
                    if (text!.isEmpty) {
                      return "Password can't be Empty";
                    } else if (text.length < 4) {
                      return "Otp must be 4 characters long";
                    }
                    return null;
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
                      await registerservices
                          .createUserWithEmailAndPassword(
                              email: registercontrollers.emailcontrollers.text,
                              password:
                                  registercontrollers.passwordcontrollers.text,
                              context: context)
                          .then((value) async {
                        await verifyOTP().then((value) {
                          saveData();
                          final route = MaterialPageRoute(
                            builder: (context) => Home(),
                          );
                          Navigator.push(context, route);
                        }).whenComplete(() {
                          registercontrollers.emailcontrollers.clear();
                          registercontrollers.passwordcontrollers.clear();
                          registercontrollers.otpcontrollers.clear();
                        });
                      });
                    } else {
                      registercontrollers.registerbtnController.reset();
                    }
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailFeild() {
    return Center(
      child: Container(
        height: 60,
        width: 305,
        child: TextFormField(
          validator: (text) => text!.isEmpty ? "Email can't be Empty" : null,
          controller: registercontrollers.emailcontrollers,
          decoration: InputDecoration(
            suffixIcon:
                TextButton(onPressed: () => sendOtp(), child: Text("Send Otp")),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            border: OutlineInputBorder(),
            hintText: "email@example.com",
            hintStyle: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
