//firebase
import 'package:cloud_firestore/cloud_firestore.dart';
//flutter basic packages
import 'package:flutter/material.dart';
//Allow responsive layout
import 'package:sizer/sizer.dart';
//pages
//extract code from database
import 'package:save_this_food/models/quotes.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  //Extract Quotes out from database as Stream<List<Quotes>>
  Stream<List<Quotes>> readQuotes() => FirebaseFirestore.instance
      .collection("quotes")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Quotes.fromJson(doc.data())).toList()
            ..shuffle());

  //Display quotes in the form of ListTile
  Widget buildQuote(Quotes quoteDetail) => ListTile(
        title: Text(
          '${quoteDetail.quote}',
          style: TextStyle(fontSize: 12.sp),
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          '-${quoteDetail.author}',
          style: TextStyle(fontSize: 10.sp),
          textAlign: TextAlign.center,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
            backgroundColor: Color(0xFFEFE4D5),
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 6.h),
                    //Page header
                    Text(
                      "SAVE DELICIOUS FOOD FROM WASTE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),

                    SizedBox(height: 6.h),

                    //Display logo
                    Image.asset(
                      "assets/img/Logo.png",
                      height: 28.h,
                      width: 28.w,
                    ),

                    //Display quotes on food waste
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 2.h),
                        child: StreamBuilder<List<Quotes>>(
                          stream: readQuotes(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(
                                "We ran out of quote today",
                                style: TextStyle(fontSize: 12.sp),
                                textAlign: TextAlign.center,
                              );
                            } else if (snapshot.hasData) {
                              final quotes = snapshot.data!;
                              //See ListTile for design style
                              return ListView(
                                children:
                                    quotes.map(buildQuote).take(1).toList(),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ),

                    //Create an account button
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_up');
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
                          "Create an account",
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                    ),

                    SizedBox(height: 1.h),

                    //I already have account button
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_in');
                      },
                      style: TextButton.styleFrom(primary: Color(0xFF546B2F)),
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 0),
                        child: Text(
                          "I already have an account",
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                    ),

                    //Sign up as merchant button
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/merchant_sign_up');
                      },
                      style: TextButton.styleFrom(primary: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Sign up as merchant",
                          style: TextStyle(fontSize: 11.sp),
                        ),
                      ),
                    ),

                    SizedBox(height: 1.h),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
