import 'package:flutter/material.dart';
import 'package:mynewsapp/Auth/Auth_services%20.dart';
import 'package:mynewsapp/Auth/googleSigin/googlesigin.dart';
import 'package:mynewsapp/controllers/authcontrollers.dart';
import 'package:mynewsapp/views/Auth_View_screens/Register.dart';
import 'package:mynewsapp/widgets/buildauth_textfeild.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Authcontrollers authcontrollers = Authcontrollers();
  Authservices authservices = Authservices();
  Googlesigin googlesigin = Googlesigin();
  final formkey = GlobalKey<FormState>();

  bool isvisible = false;

  @override
  dispose() {
    authcontrollers.emailcontrollers.dispose();
    authcontrollers.passwordcontrollers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              spacing: 20,
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
                  child: const Text(
                    " Please Login with registered email.",
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Center(
                  child: AuthTextfeild().buildAuthTextField(
                    authcontrollers.emailcontrollers,
                    "email@example.com",
                    (text) => text!.isEmpty ? "Email can't be Empty" : null,
                  ),
                ),
                Center(
                  child: AuthTextfeild().buildAuthTextField(
                    authcontrollers.passwordcontrollers,
                    "Password",
                    (text) {
                      if (text!.isEmpty) {
                        return "Password can't be Empty";
                      } else if (text.length < 6) {
                        return "Password is worng";
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
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedLoadingButton(
                      controller: authcontrollers.loginbtnController,
                      color: Colors.red,
                      successColor: Colors.green,
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          await authservices.SignInUserWithEmailAndPassword(
                              email: authcontrollers.emailcontrollers.text,
                              password:
                                  authcontrollers.passwordcontrollers.text,
                              context: context);
                          authcontrollers.emailcontrollers.clear();
                          authcontrollers.passwordcontrollers.clear();
                        } else {
                          authcontrollers.loginbtnController.reset();
                          authcontrollers.navigatebtnController.reset();
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedLoadingButton(
                    controller: authcontrollers.navigatebtnController,
                    color: Colors.red,
                    successColor: Colors.green,
                    onPressed: () {
                      final route =
                          MaterialPageRoute(builder: (context) => Register());
                      Navigator.push(context, route);
                      authcontrollers.navigatebtnController.reset();
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Center(
                  child: const Text(
                    "OR",
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      googlesigin.googleSignInaccount(context);
                    },
                    child: Container(
                      color: Colors.red,
                      height: 50,
                      width: 215,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: Image.asset(
                              "assets/google-logo.png",
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Sign In with Google",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
