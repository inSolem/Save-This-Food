import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? keys});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      Navigator.pushNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('No user found for that email.'),
              );
            });
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Wrong password provided for that user.'),
              );
            });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                      //Back Button
                      Positioned(
                        left: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 30.sp,
                          ),
                        ),
                      ),
                      //Page Title
                      Center(
                        child: Text(
                          "Hello Again",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.sp,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(height: 4.h),

                  Image.asset(
                    "assets/img/LogoBag.png",
                    height: 20.h,
                    width: 20.w,
                  ),

                  SizedBox(height: 4.h),

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
                        hintText: "Enter your email",
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
                          "Password",
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

                  SizedBox(height: 5.h),

                  //Continue Button
                  TextButton(
                    onPressed: signIn,
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
                        "Sign In",
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                  ),

                  SizedBox(height: 5.h),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/forget_password');
                    },
                    child: Text("Forgot password?",
                        style: TextStyle(color: Color(0xFF556B2F))),
                  ),

                  SizedBox(height: 2.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/sign_up');
                        },
                        child: Text(
                          "Register Now",
                          style: TextStyle(color: Color(0xFF556B2F)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
