import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:save_this_food/controllers/cart_controller.dart';
import 'package:sizer/sizer.dart';
import '../../blocs/product/product_bloc.dart';
import '../../models/product_model.dart';
import '../../widgets/product_card.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    final dataMap = (ModalRoute.of(context)?.settings.arguments) as Map;
    final Product product = dataMap["chosenProduct"];
    final int chosenQuantity = dataMap["chosenQuantity"];

    final CartController controller = Get.put(CartController());

    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return Obx(
        () => Scaffold(
          backgroundColor: const Color(0xFFEFE4D5),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 30.h,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(children: <Widget>[
                      Positioned.fill(
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(product.listingImage)),
                      ),

                      Positioned(
                          bottom: 1,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  const Color.fromRGBO(0, 0, 0, 0.2),
                                  const Color.fromRGBO(0, 0, 0, 0),
                                ],
                              ),
                            ),
                          )),

                      //Back Button
                      Positioned(
                        top: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              controller.emptyCart();
                            });
                          },
                          child: Icon(
                            Icons.arrow_circle_left_outlined,
                            size: 25.sp,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 30,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 21.sp,
                                  backgroundColor: const Color(0xFF556B2F),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(product.businessLogo),
                                    backgroundColor: Colors.white,
                                    radius: 20.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.sp,
                                ),
                                Text(
                                  product.businessName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  //Current Order
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("Current Order",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          )),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: ProductCard(
                      isFirstCard: true,
                      product: product,
                      chosenQuantity: chosenQuantity,
                      controller: controller,
                    ),
                  ),
                  //^^^Current Order^^^

                  const SizedBox(
                    height: 30,
                  ),

                  //Other listings

                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF546B2F),
                          ),
                        );
                      } else if (state is ProductLoaded) {
                        List products = state.products
                            .where((element) =>
                                element.businessName == product.businessName)
                            .where((element) => element != product)
                            .where((element) => element.quantityAvailable > 0)
                            .where((element) => element.endTime
                                .toLocal()
                                .isAfter(DateTime.now().toLocal()))
                            .toList();
                        if (products.isEmpty) {
                          return Text("");
                        } else {
                          return Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                      "Other listings by ${product.businessName}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      )),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 400,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    return ProductCard(
                                        isFirstCard: false,
                                        product: products[index],
                                        chosenQuantity: 0,
                                        controller: controller);
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      } else {
                        return Text("Something went wrong");
                      }
                    },
                  ),
                  //^^^Other listings^^^
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              color: const Color(0xFFEFE4D5),
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Color(0xFFDFB288), width: 1))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF546B2F),
                            ),
                          ),
                          Text(
                            "\u0024 ${controller.total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF546B2F),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: enableButtonCheck(controller.total)
                          ? () => {
                                Navigator.pushNamed(context, '/payment_page'),
                              }
                          : null,
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF546B2F),
                          onSurface: const Color(0xFF546B2F).withOpacity(0.8)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 80.sp, vertical: 2.sp),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )),
        ),
      );
    });
  }

  bool enableButtonCheck(double totalPrice) {
    if (totalPrice == 0) {
      return false;
    } else {
      return true;
    }
  }
}
