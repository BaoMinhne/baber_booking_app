// ignore_for_file: use_build_context_synchronously, unnecessary_new

import 'package:baber_booking_app/pages/home.dart';
import 'package:baber_booking_app/pages/login.dart';
import 'package:baber_booking_app/services/database.dart';
import 'package:baber_booking_app/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name, mail, password;

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  registration() async {
    if (password != null && name != null && mail != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: mail!, password: password!);
        print("✅ FirebaseAuth: Tạo user thành công");
        String id = randomAlphaNumeric(10);
        print("📦 ID tạo ra: $id");
        print("📦 Lưu SharedPreferences...");
        await SharedPreferenceHelper().saveUserId(id);
        print("✔️ userId saved: $id");
        await SharedPreferenceHelper().saveUserName(nameController.text);
        print("✔️ userName saved: ${nameController.text}");
        await SharedPreferenceHelper().saveUserEmail(emailController.text);
        print("✔️ userEmail saved: ${emailController.text}");
        await SharedPreferenceHelper().saveUserImage(
            'https://cdn-icons-png.flaticon.com/512/149/149071.png');
        print("✔️ userImage saved");

        Map<String, dynamic> userInfoMap = {
          "Name": nameController.text,
          "Email": emailController.text,
          "Id": id,
          "Image": "https://cdn-icons-png.flaticon.com/512/149/149071.png"
        };
        await DatabaseMethods().addUserDetails(userInfoMap, id);
        print("📝 Đã lưu user lên Firestore với ID: $id");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Registration Successful!",
                style: TextStyle(
                  fontSize: 20,
                ),
              )),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
              "The password provided is too weak.",
              style: TextStyle(
                fontSize: 20,
              ),
            )),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
              "The account already exists for that email.",
              style: TextStyle(
                fontSize: 20,
              ),
            )),
          );
        }
      } catch (e, stackTrace) {
        print("❌ Lỗi không xác định trong registration()");
        print("Exception: $e");
        print("StackTrace: $stackTrace");
      }
    } else {
      print("Please fill all fields");
    }
  }

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
              child: Text("Create Your\nNew Account!",
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
                    Text("Name",
                        style: TextStyle(
                          color: Color(0xFFB91635),
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        )),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Enter your name",
                        prefixIcon: Icon(Icons.person_outlined,
                            color: Color(0xFFB91635), size: 30),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 22),
                      ),
                      style: TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 50),
                    Text("Gmail",
                        style: TextStyle(
                          color: Color(0xFFB91635),
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        )),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
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
                            name = nameController.text;
                            mail = emailController.text;
                            password = passwordController.text;
                          });
                          registration();
                        }
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
                          child: Text("SIGN UP",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Already have an account?",
                            style: TextStyle(
                              color: Color(0xFF311937),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Sign In",
                              style: TextStyle(
                                color: Color(0xff621d3c),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
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
}
