import 'package:baber_booking_app/admin/booking_admin.dart';
import 'package:baber_booking_app/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  String? username, password;

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, left: 30),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFFB91635),
                  Color(0xff621d3c),
                  Color(0xFF311937),
                ]),
              ),
              child: Text("Admin\n Panel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 40),
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Username",
                        style: TextStyle(
                          color: Color(0xFFB91635),
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        )),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: "Enter your username",
                        prefixIcon: Icon(Icons.email_outlined,
                            color: Color(0xFFB91635), size: 30),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 22),
                      ),
                      style: TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 50),
                    Text("Password",
                        style: TextStyle(
                          color: Color(0xFFB91635),
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        )),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        prefixIcon: Icon(Icons.password_outlined,
                            color: Color(0xFFB91635), size: 30),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 22),
                      ),
                      obscureText: true,
                      style: TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 60),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            username = usernameController.text;
                            password = passwordController.text;
                          });
                        }
                        loginAdmin();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xFFB91635),
                            Color(0xff621d3c),
                            Color(0xFF311937),
                          ]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text("LOG IN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_2_sharp,
                              color: Color.fromARGB(255, 72, 93, 229),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("Back to User Login",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 72, 93, 229),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()['id'] != usernameController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  "Your id is not correct",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )),
          );
        } else if (result.data()['password'] !=
            passwordController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  "Your password is not correct",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )),
          );
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BookingAdmin()));
        }
      });
    });
  }
}
