import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ForgetPasswordPage extends StatefulWidget {
  ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      Navigator.pushNamed(context, '/sign_in');
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Password reset link sent! Check your email!"),
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
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
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.sp,
                          ),
                        ),
                      ),
                    ]),
                  ),

                  SizedBox(height: 6.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                    child: Text(
                      "Enter your Email and we will send you a password rest link",
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 4.h),

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

                  TextButton(
                    onPressed: passwordReset,
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: const Color(0xFF546B2F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10.h),
                      child: Text(
                        "Reset Password",
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
