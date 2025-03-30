import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:mynewsapp/Provider/catagorynewsdata.dart';
import 'package:mynewsapp/Provider/faviroteprovider.dart';
import 'package:mynewsapp/Provider/newsapipeovider.dart';
import 'package:mynewsapp/firebase_options.dart';
import 'package:mynewsapp/views/Auth_View_screens/Login.dart';
import 'package:mynewsapp/views/splashsrceen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Newszify());
}

class Newszify extends StatelessWidget {
  Newszify({super.key});
  // This widget is the root of your application.b
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Newsapiprovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Catagorynewsdata(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "News App",
        theme: FlexThemeData.light(scheme: FlexScheme.blackWhite),
        darkTheme: FlexThemeData.dark(scheme: FlexScheme.blackWhite),
        themeMode: ThemeMode.system,
        home: SplashScreen(),
        routes: {
          '/login': (context) => Login(),
        },
      ),
    );
  }
}
