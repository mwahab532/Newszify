import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mynewsapp/style/style.dart';
import 'package:mynewsapp/views/Rateapp.dart';
import 'package:mynewsapp/views/favorite.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "";
  User? user = FirebaseAuth.instance.currentUser;
  final getFirestore = FirebaseFirestore.instance.collection("users");

  Future<void> getuserdata() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userdoc = await getFirestore.doc(uid).get();
    setState(() {
      if (user!.displayName != null && user!.displayName!.isNotEmpty) {
      
        username = user!.displayName!;
      } else if (userdoc.exists && userdoc["username"] != null) {
      
        username = userdoc["username"];
      } else {
        username = "Unknown User";
      }
    });
  }

  @override
  void initState() {
    getuserdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String creationDate = user?.metadata.creationTime?.toString() ?? 'Unknown';
    DateTime? dateTime =
        creationDate != 'Unknown' ? DateTime.parse(creationDate) : null;
    final format = DateFormat("dd MMMM yyyy");
    String formattedDate =
        dateTime != null ? format.format(dateTime) : 'Unknown';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          'Profile',
          style: ProfileTitletextstyle,
        ),
      ),
      body: Column(
        spacing: 10,
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? Icon(Icons.person, size: 30, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Name'),
                    subtitle:
                        Text(username.isNotEmpty ? username : "Fetching..."),
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text('Email'),
                    subtitle: Text(
                      FirebaseAuth.instance.currentUser!.email.toString(),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.verified_user_outlined),
                    title: Text('User ID'),
                    subtitle: Text(
                      FirebaseAuth.instance.currentUser!.uid.toString(),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_month),
                    title: Text('Created At'),
                    subtitle: Text(formattedDate),
                  ),
                  InkWell(
                    onTap: () {
                      final route = MaterialPageRoute(
                        builder: (context) => favorite(),
                      );
                      Navigator.push(context, route);
                    },
                    child: ListTile(
                      leading: Icon(Icons.bookmark),
                      title: Text('Save News'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final route = MaterialPageRoute(
                        builder: (context) => Rateatheapp(),
                      );
                      Navigator.push(context, route);
                    },
                    child: ListTile(
                      leading: Icon(Icons.star),
                      title: Text('Rate the app'),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await user!.delete();
                      await FirebaseAuth.instance.signOut();
                      await  getFirestore.doc().delete();
                     await Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      title:
                          Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      title:
                          Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
