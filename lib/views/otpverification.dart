import 'package:email_otp_auth/email_otp_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynewsapp/controllers/authcontrollers.dart';
import 'package:mynewsapp/views/Home.dart';
import 'package:mynewsapp/widgets/buildauth_textfeild.dart';

class Otpverification extends StatefulWidget {
  Otpverification({
    super.key,
  });

  @override
  State<Otpverification> createState() => _OtpverificationState();
}

class _OtpverificationState extends State<Otpverification> {
  Registercontrollers registercontrollers = Registercontrollers();
  Future<bool> verifyOTP() async {
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
      var res = await EmailOtpAuth.verifyOtp(
          otp: registercontrollers.otpcontrollers.text);

      // poping out CircularProgressIndicator.
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // if response[message == "OTP Verified"] then..
      if (res["message"] == "OTP Verified" && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP verified ✅"),
          ),
        );
        return true; // OTP verified successfully
      }
      // if response[message == "Invalid OTP"] then..
      else if (res["data"] == "Invalid OTP" && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid OTP ❌"),
          ),
        );
        return false; // Invalid OTP
      }
      // if response[message == "OTP Expired"] then..
      else if (res["data"] == "OTP Expired" && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP Expired ⚠️"),
          ),
        );
      }
      // else return nothing.
      else {
        return false;
      }
    } catch (error) {
      throw error.toString();
    }
    return false; // Default return value in case of an error
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 20,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200, left: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Image.asset(
                  "assets/Newszify.png",
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(
              "OTP Verification",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
            const Text(
              "Please Enter the OTP sent to your email",
              style: TextStyle(fontSize: 15),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AuthTextfeild().buildAuthTextField(
                registercontrollers.otpcontrollers,
                "Enter OTP",
                Keyboradtype: TextInputType.number,
                (text) {
                  if (text!.isEmpty) return "OTP can't be empty";
                  return null;
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (registercontrollers.otpcontrollers.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter OTP"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  final isValid = await verifyOTP();
                  if (isValid && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Successfully Registered."),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  }
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $error"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Verify OTP'),
            ),
            ],
        ),
      ),
    );
  }
}
