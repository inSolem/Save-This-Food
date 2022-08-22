import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:save_this_food/widgets/payment_card.dart';
import 'package:sizer/sizer.dart';

import '../../blocs/payment/payment_bloc.dart';
import '../../controllers/cart_controller.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

final CartController controller = Get.find();

String generateOrderID() {
  Random _rnd = Random();
  const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return List.generate(4, (index) => _chars[_rnd.nextInt(_chars.length)])
      .join();
}

Future addOrder(
  String orderId,
) async {
  FirebaseFirestore.instance.collection("allOrders").doc(orderId).set({
    'name': "${user.displayName}",
    'email': "${user.email}",
    "purchaseDate": DateTime.now(),
    'purchases': controller.purchases,
    'total': controller.total,
  });
  try {
    FirebaseFirestore.instance
        .collection("buyerPurchaseRecords")
        .doc("${user.email}")
        .set({
      "orderIDs": FieldValue.arrayUnion([orderId]),
    }, SetOptions(merge: true));
  } catch (e) {
    FirebaseFirestore.instance
        .collection("buyerPurchaseRecords")
        .doc("${user.email}")
        .set({
      "orderIDs": orderId,
    });
  }
}

Future<int> getQuantityAvailable(String listingId) async {
  late Map<String, dynamic> allListing;
  await FirebaseFirestore.instance
      .collection('allListings')
      .doc(listingId)
      .get()
      .then((DocumentSnapshot doc) {
    allListing = doc.data() as Map<String, dynamic>;
  });
  return allListing["quantityAvailable"];
}

Future updateFirebaseQuantity() async {
  List<Map<String, dynamic>> purchases = controller.purchases;

  for (Map<String, dynamic> purchase in purchases) {
    int remainingQuantity = await getQuantityAvailable(purchase["listingID"]);
    remainingQuantity -= purchase["purchaseQuantity"] as int;

    FirebaseFirestore.instance
        .collection("allListings")
        .doc(purchase["listingID"])
        .update({"quantityAvailable": remainingQuantity});
  }
}

final user = FirebaseAuth.instance.currentUser!;

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? paymentMethod;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      try {
        int total = controller.total;
      } catch (e) {
        int total = 0;
      }

      return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            Stack(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_circle_left_outlined,
                    size: 25.sp,
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    child: Text(
                      "${controller.businessName}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                      ),
                    ),
                  ))
            ]),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  "Order Summary:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                children: const [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Item",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Quantity",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Total unit price",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                  top: BorderSide(color: Color(0xFFDFB288), width: 1),
                  bottom: BorderSide(color: Color(0xFFDFB288), width: 1),
                )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PaymentCard(
                          product: controller.products.keys.toList()[index],
                          quantity: controller.products.values.toList()[index],
                          index: index);
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Color(0xFFDFB288), width: 1),
                )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF546B2F),
                          ),
                        ),
                        Text(
                          "\u0024 ${controller.total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF546B2F),
                          ),
                        )
                      ]),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "By reserving you agree to our terms and conditions",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (builder) => paymentSheet(),
                  isDismissible: false,
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF546B2F),
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 100.sp, vertical: 2.sp),
                child: const Text(
                  'Reserve',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ]),
        )),
      );
    });
  }

  Widget paymentSheet() {
    String orderId = generateOrderID();
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 400,
        child: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            CardFormEditController cardController = CardFormEditController(
              initialDetails: state.cardFieldInputDetails,
            );
            if (state.status == PaymentStatus.initial) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Enter payment details",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      CardFormField(
                        controller: cardController,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            (cardController.details.complete)
                                ? context.read<PaymentBloc>().add(
                                      PaymentCreateIntent(
                                        billingDetails: BillingDetails(
                                            email: "${user.email}",
                                            name: "${user.displayName}"),
                                        totalAmount: controller.total,
                                        description: orderId,
                                      ),
                                    )
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("The form is not completed."),
                                    ),
                                  );
                          },
                          child: Text(
                              "Pay \u0024 ${controller.total.toStringAsFixed(2)}"),
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF546B2F),
                          )),
                    ]),
              );
            } else if (state.status == PaymentStatus.success) {
              addOrder(orderId);

              updateFirebaseQuantity();

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("The payment is successful."),
                  const SizedBox(
                    height: 10,
                    width: double.infinity,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PaymentBloc>().add(PaymentStart());
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      // Navigator.of(context).popUntil(ModalRoute.withName('/'));
                      Future.delayed(const Duration(milliseconds: 500), () {
                        controller.emptyCart();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF546B2F),
                    ),
                    child: const Text("Back to Home"),
                  ),
                ],
              );
            } else if (state.status == PaymentStatus.failure) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("The payment failed."),
                  const SizedBox(
                    height: 10,
                    width: double.infinity,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PaymentBloc>().add(PaymentStart());
                      ElevatedButton.styleFrom(
                        primary: const Color(0xFF546B2F),
                      );
                    },
                    child: const Text("Try again"),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
