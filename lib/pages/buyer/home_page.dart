import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:save_this_food/blocs/product/product_bloc.dart';
import 'package:save_this_food/home_widgets/custom_navbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sizer/sizer.dart';
import '../../models/product_model.dart';
import '../../widgets/carousel_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Sizer(builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color(0xFFEFE4D5),
          bottomNavigationBar: const CustomNavBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //Save it before it's too late
                  SizedBox(height: 40.sp),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("Save it before it's too late",
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
                            .where((product) => product.endTime
                                .toLocal()
                                .isAfter(DateTime.now().toLocal()))
                            .where((product) => product.quantityAvailable > 0)
                            .toList();

                        if (items.isEmpty) {
                          return const Text(
                              "Ops, we ran out of food for this category\nPlease come back later");
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
                                      disableInkWell: false,
                                    ))
                                .toList(),
                          );
                        }
                      } else {
                        return Text("Something went wrong");
                      }
                    },
                  ),
                  //^^^Save it before it's too late^^^
                  //A pleasant surprise
                  SizedBox(height: 40.sp),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("A pleasant surprise",
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
                            .where(
                                (product) => product.category == "Surprise Bag")
                            .where((product) => product.endTime
                                .toLocal()
                                .isAfter(DateTime.now().toLocal()))
                            .where((product) => product.quantityAvailable > 0)
                            .toList();

                        if (items.isEmpty) {
                          return const Text(
                              "Ops, we ran out of food for this category\nPlease come back later");
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
                                      disableInkWell: false,
                                    ))
                                .toList(),
                          );
                        }
                      } else {
                        return const Text("Something went wrong");
                      }
                    },
                  ),
                  //^^^A pleasant surprise^^^
                  //Fresh from the market
                  SizedBox(height: 40.sp),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("Fresh from the market",
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
                            .where(
                                (product) => product.category != "Surprise Bag")
                            .where((product) => product.endTime
                                .toLocal()
                                .isAfter(DateTime.now().toLocal()))
                            .where((product) => product.quantityAvailable > 0)
                            .toList();
                        if (items.isEmpty) {
                          return const Text(
                              "Ops, we ran out of food for this category\nPlease come back later");
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
                                      disableInkWell: false,
                                    ))
                                .toList(),
                          );
                        }
                      } else {
                        return const Text("Something went wrong");
                      }
                    },
                  ),
                  //^^^Fresh from the market^^^

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
