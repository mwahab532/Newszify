import 'package:flutter/material.dart';

class AuthTextfeild {
  Widget buildAuthTextField(
    TextEditingController controller,
    String hintText,
    String? Function(String?) validator, {
    bool isObscure = false,
    IconButton? iconbuttion,
   final Keyboradtype,
  }) {
    return Container(
      height: 50,
      width: 300,
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: isObscure,
        keyboardType: Keyboradtype,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 20),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10), // Centering ke liye
          suffixIcon: iconbuttion,
          
        ),
      ),
    );
  }
}
