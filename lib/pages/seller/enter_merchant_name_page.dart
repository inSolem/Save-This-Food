import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sizer/sizer.dart';

class EnterMerchantNamePage extends StatefulWidget {
  const EnterMerchantNamePage({Key? key}) : super(key: key);

  @override
  State<EnterMerchantNamePage> createState() => _EnterMerchantNamePageState();
}

final user = FirebaseAuth.instance.currentUser;

class _EnterMerchantNamePageState extends State<EnterMerchantNamePage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _locationController = TextEditingController();
  final _logoController = TextEditingController();

  addSeller() async {
    user?.updateDisplayName(_nameController.text.trim()) ??
        user?.updateDisplayName(_nameController.text.trim());

    Navigator.pushNamed(context, '/merchant_sign_in');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _locationController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  Future addSellerDetails() async {
    String? email = user?.email;
    addSeller();
    FirebaseFirestore.instance.collection("SellerDetails").doc(email!).set({
      "name": _nameController.text.trim(),
      "address": _addressController.text.trim(),
      "location": _locationController.text.trim(),
      "logo": _logoController.text.trim(),
    });
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            "What is the business name?",
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
                          borderSide:
                              BorderSide(color: const Color(0xFFDFB288)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF556B2F)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Enter business name",
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
                          "Address",
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
                      controller: _addressController,
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
                        hintText: "What is the merchant address",
                        fillColor: const Color(0xFFEFE4D5),
                        filled: true,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  //business location
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          "Google map location",
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
                      controller: _locationController,
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
                        hintText: "Google map link to address",
                        fillColor: const Color(0xFFEFE4D5),
                        filled: true,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  //business location
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          "Logo",
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
                      controller: _logoController,
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
                        hintText: "Logo image url",
                        fillColor: const Color(0xFFEFE4D5),
                        filled: true,
                      ),
                    ),
                  ),

                  SizedBox(height: 5.h),

                  //Continue Button
                  TextButton(
                    onPressed: () {
                      addSellerDetails();
                    },
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
          ),
        ));
      },
    );
  }
}
