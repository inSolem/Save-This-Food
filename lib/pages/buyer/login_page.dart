import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
            backgroundColor: const Color(0xFFEFE4D5),
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 6.h),
                    //Page header
                    Text(
                      "LET'S SAVE FOOD!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28.sp,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    //Display logo
                    Image.asset(
                      "assets/img/Logo.png",
                      height: 40.h,
                      width: 40.w,
                    ),

                    //Display quotes on food waste
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        child: Text(
                          "Do you know: if it were a country, food waste would be the third highest greenhouse gasses emitter",
                          style: TextStyle(fontSize: 12.sp),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    //Create an account button
                    TextButton(
                      onPressed: () {
                        //Move onto sign_in_page
                        Navigator.pushNamed(context, '/sign_in');
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Color(0xFF546B2F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 40),
                        child: Text(
                          "Continue with Email",
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
