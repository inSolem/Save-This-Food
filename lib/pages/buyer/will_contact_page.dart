import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WillContact extends StatefulWidget {
  WillContact({Key? key}) : super(key: key);

  @override
  State<WillContact> createState() => _WillContactState();
}

class _WillContactState extends State<WillContact> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Color(0xFFEFE4D5),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
                child: Column(
              children: [
                SizedBox(height: 6.h),
                Text(
                  "Thank You",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Image.asset(
                  "assets/img/LogoMan.png",
                  height: 40.h,
                  width: 40.w,
                ),
                SizedBox(height: 6.h),
                Text(
                  "Our agent will contact you shortly",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Color(0xFF546B2F),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                    child: Text(
                      "Back to Landing Page",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      );
    });
  }
}
