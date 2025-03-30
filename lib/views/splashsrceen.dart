import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:mynewsapp/Auth/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showSpinner = false;
  Future<bool> checkInternetConnection() async {
    try {
      // First check network interface
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) return false;

      // Then verify real internet access
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeApp());
  }

  void _initializeApp() async {
    final isConnected = await checkInternetConnection();
    if (!mounted) return;
    if (isConnected) {
      setState(() {
        _showSpinner = true;
      });
         _navigateToHome();
    } else {
      _showErrorDialog();
    }
  }

  void _navigateToHome() {
    Timer(const Duration(seconds: 2), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Authpage(),
          ));
    });
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('No Internet'),
        content: const Text('Please check your connection'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeApp(); // Retry
              setState(() => _showSpinner = false);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Image.asset(
                "assets/Newszify.png",
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
             const SizedBox(height: 50),
            RichText(
              text: TextSpan(
                text: "Instantly get world Top news ",
                style: TextStyle( 
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 50),
            if (_showSpinner) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
