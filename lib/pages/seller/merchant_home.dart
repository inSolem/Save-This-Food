import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_this_food/blocs/product/product_bloc.dart';
import 'package:save_this_food/home_widgets/custom_navbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sizer/sizer.dart';
import '../../home_widgets/merchant_navbar.dart';
import '../../models/product_model.dart';
import '../../widgets/carousel_card.dart';

class MerchantHomePage extends StatelessWidget {
  const MerchantHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.signOut();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Sizer(builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color(0xFFEFE4D5),
          bottomNavigationBar: const MerchantNavBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [Text("THIS IS HOME TRUELY")],
              ),
            ),
          ),
        );
      }),
    );
  }
}
