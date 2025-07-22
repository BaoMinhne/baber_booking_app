import 'package:baber_booking_app/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addUserBooking(Map<String, dynamic> userBooking) async {
    return await FirebaseFirestore.instance
        .collection("booking")
        .add(userBooking);
  }

  Future<Stream<QuerySnapshot>> getBookings() async {
    return await FirebaseFirestore.instance.collection("booking").snapshots();
  }

  DeleteBooking(String id) async {
    return await FirebaseFirestore.instance
        .collection("booking")
        .doc(id)
        .delete();
  }

  Future<void> signOutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await SharedPreferences.getInstance().then((prefs) => prefs.clear());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Logout Successfully!! See You Later",
              style: TextStyle(
                fontSize: 18,
              ),
            )),
      );
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Logout fail!!",
              style: TextStyle(
                fontSize: 18,
              ),
            )),
      );
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print("Error getting user details: $e");
      return null;
    }
  }
}
