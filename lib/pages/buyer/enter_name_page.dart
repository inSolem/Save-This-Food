import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sizer/sizer.dart';

class EnterNamePage extends StatefulWidget {
  const EnterNamePage({Key? key}) : super(key: key);

  @override
  State<EnterNamePage> createState() => _EnterNamePageState();
}

final user = FirebaseAuth.instance.currentUser;

class _EnterNamePageState extends State<EnterNamePage> {
  final _nameController = TextEditingController();

  addBuyer() async {
    user?.updateDisplayName(_nameController.text.trim()) ??
        user?.updateDisplayName(_nameController.text.trim());

    Navigator.pushNamed(context, '/home');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
            body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 4.h),
                //Container containing back button and Page Title
                SizedBox(
                  width: 100.w,
                  child: Stack(children: <Widget>[
                    //Back Button
                    Positioned(
                      left: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 30.sp,
                        ),
                      ),
                    ),
                    //Page Title
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "How would you like to be addressed?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 5.h),

                //The Text "Email"
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),

                //Text input box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFFDFB288)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF556B2F)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Enter your name",
                      fillColor: const Color(0xFFEFE4D5),
                      filled: true,
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                //Continue Button
                TextButton(
                  onPressed: addBuyer,
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: const Color(0xFF546B2F),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 15.h),
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      },
    );
  }
}
