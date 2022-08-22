import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_this_food/blocs/product/product_bloc.dart';
import 'package:save_this_food/home_widgets/custom_navbar.dart';
import 'package:save_this_food/models/product_model.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/carousel_card.dart';

class SurpriseBagPage extends StatelessWidget {
  const SurpriseBagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
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
                    child: Text("Surprise Bag",
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
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          scrollDirection: Axis.vertical,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return CarouselCard(
                              product: items[index],
                              disableInkWell: false,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        );
                      }
                    } else {
                      return Text("Something went wrong");
                    }
                  },
                ),
                //^^^Save it before it's too late^^^
              ],
            ),
          ),
        ),
      );
    });
  }
}
