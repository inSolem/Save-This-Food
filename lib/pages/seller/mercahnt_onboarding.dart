//Only for SaveThisFood admin to access

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MerchantOnboarding extends StatefulWidget {
  const MerchantOnboarding({
    Key? key,
  });

  @override
  State<MerchantOnboarding> createState() => _MerchantOnboardingState();
}

class _MerchantOnboardingState extends State<MerchantOnboarding> {
  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //Adding data to Firebase

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (passwordConfirmed()) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Navigator.pushNamed(context, '/enter_merchant_name');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: Text('Please provide a stronger password'),
                );
              });
        } else if (e.code == 'email-already-in-use') {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: Text(
                      'The account already exists for that email.\n\nPlease contact merchant for another email'),
                );
              });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                  'Password and Confirm Password do not match \n\nPlease re-enter password'),
            );
          });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
            body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 4.h),
                  //Container containing back button and Page Title
                  SizedBox(
                    width: 100.w,
                    child: Stack(children: <Widget>[
                      //Page Title
                      Center(
                        child: Text(
                          "Merchant Onboarding",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.sp,
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
                          "Email",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),

                  //Email box
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      controller: _emailController,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: const Color(0xFFDFB288)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF556B2F)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "What is the merchant email",
                        fillColor: const Color(0xFFEFE4D5),
                        filled: true,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          "Enter a Password",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      obscureText: true,
                      controller: _passwordController,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: const Color(0xFFDFB288)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF556B2F)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Enter Password",
                        fillColor: const Color(0xFFEFE4D5),
                        filled: true,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          "Confirm Password",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      obscureText: true,
                      controller: _confirmPasswordController,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFDFB288)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF556B2F)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Re-enter Password",
                        fillColor: const Color(0xFFEFE4D5),
                        filled: true,
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  //Continue Button
                  TextButton(
                    onPressed: signUp,
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: const Color(0xFF546B2F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 16.h),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
