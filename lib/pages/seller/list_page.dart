import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../blocs/product/product_bloc.dart';
import '../../home_widgets/merchant_navbar.dart';
import '../../models/product_model.dart';
import '../../widgets/carousel_card.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Add new Listing",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/new_listing');
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Color(0xFF546B2F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2, horizontal: 20.h),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFFEEE3D4),
                            size: 25,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("Current Listings",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is ProductLoaded) {
                        List<Product> items = state.products
                            .where((product) =>
                                product.businessName ==
                                "Newcastle United") //Cannot feed name from Firebase due to FirebaseAuth
                            .where((product) => product.endTime
                                .toLocal()
                                .isAfter(DateTime.now().toLocal()))
                            .toList();
                        if (items.isEmpty) {
                          return const Text("No current listings");
                        } else {
                          return CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: false,
                              aspectRatio: 1.8,
                              viewportFraction: 0.8,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                            ),
                            items: items
                                .map((product) => CarouselCard(
                                      product: product,
                                      disableInkWell: true,
                                    ))
                                .toList(),
                          );
                        }
                      } else {
                        return const Text("Something went wrong");
                      }
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("Past Listings",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is ProductLoaded) {
                        List<Product> items = state.products
                            .where((product) =>
                                product.businessName ==
                                "Newcastle United") //Cannot feed name from Firebase due to FirebaseAuth
                            .where((product) => product.endTime
                                .toLocal()
                                .isBefore(DateTime.now().toLocal()))
                            .toList();
                        if (items.isEmpty) {
                          return const Text("No past listings");
                        } else {
                          return CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: false,
                              aspectRatio: 1.8,
                              viewportFraction: 0.8,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                            ),
                            items: items
                                .map((product) => CarouselCard(
                                      product: product,
                                      disableInkWell: true,
                                    ))
                                .toList(),
                          );
                        }
                      } else {
                        return const Text("Something went wrong");
                      }
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text(
                      "Sign out",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
