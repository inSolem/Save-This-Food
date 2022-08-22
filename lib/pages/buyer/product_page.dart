import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_this_food/models/product_model.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';

class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void dispose() {
    _quantityCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataMap = (ModalRoute.of(context)?.settings.arguments) as Map;
    Product product = dataMap["chosenProduct"];
    bool displayButton = dataMap["displayButton"];
    final cartController = Get.put(CartController());

    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return Scaffold(
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
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_circle_left_outlined,
                            size: 25.sp,
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 90,
                          left: 35,
                          child: Container(
                            color: const Color(0xFFDFB288),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: Text(
                                "${product.quantityAvailable} left",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
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
                    height: 10,
                  ),

                  Stack(
                    children: <Widget>[
                      Container(
                        height: 60,
                      ),
                      Positioned(
                        top: 0,
                        left: 30,
                        child: Text(
                          product.listingName,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFDFB288)),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          right: 20,
                          child: Text(
                            "\u0024 ${product.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF546B2F),
                            ),
                          )),
                    ],
                  ),

                  //Collection time
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time),
                          const Text(
                            " Collection: ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              product.displayCollectionTimeForProductScreen(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            color: const Color(0xFFDEEE3D4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: Text(
                                product.displayDate(),
                                style: const TextStyle(
                                    fontSize: 16, color: Color(0xFFDFB288)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //^^^Collection Time^^^
                  const SizedBox(
                    height: 20,
                  ),
                  //Address
                  InkWell(
                    onTap: () {
                      Uri address = Uri.parse(product.businessLocation);
                      launchMap(address);
                    },
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xFFDFB288), width: 1),
                              top: BorderSide(
                                  color: Color(0xFFDFB288), width: 1))),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  product.address,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  //^^^Address^^^
                  //Product description
                  const SizedBox(
                    height: 20,
                  ),

                  if (product.category == "Surprise Bag") ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "What is in the bag",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ] else ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Item description",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(
                    height: 10,
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text("${product.description}"),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  if (product.category == "Surprise Bag") ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                            "Remember that the content’s of the Surprise Bag depend on the unsold items of the day"),
                      ),
                    ),
                  ] else
                    ...[],

                  Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: Color(0xFFDFB288), width: 1),
                      ))),
                  //^^^Product description^^^
                  //What you need to know
                  const SizedBox(
                    height: 20,
                  ),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "What you need to know",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "The store may provide packaging for your food, but bringing your own bag to carry it home is highly recommended",
                      ),
                    ),
                  ),

                  Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: Color(0xFFDFB288), width: 1),
                      ))),
                  //^^^What you need to know^^^

                  //Reserve button
                  if (displayButton == true) ...[
                    //^^^Quantity Picker^^^
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        const Text(
                          "Quantity",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFCC8441),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  minus(product);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  shape: const CircleBorder(),
                                  side: const BorderSide(
                                      color: Color(0xFFCC8441)),
                                ),
                                child: const Text(
                                  "-",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFCC8441),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 65,
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    controller: _quantityCountController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      FilteringTextInputFormatter.deny("." "-"),
                                    ],
                                    style: const TextStyle(
                                        fontSize: 18, color: Color(0xFFCC8441)),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFCC8441)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFCC8441)),
                                      ),
                                    ),
                                    onSubmitted: (text) {
                                      if (text == "") {
                                        text = "0";
                                      }
                                      ;
                                      _updateQuantityCount(
                                          product.quantityAvailable, text);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              TextButton(
                                onPressed: () {
                                  add(product);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  shape: const CircleBorder(),
                                  side: const BorderSide(
                                      color: Color(0xFFCC8441)),
                                ),
                                child: const Text(
                                  "+",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFCC8441),
                                  ),
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xFFDFB288), width: 1),
                                  top: BorderSide(
                                      color: Color(0xFFDFB288), width: 1))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF546B2F),
                                    ),
                                  ),
                                  Text(
                                    "\u0024 ${_priceCount.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF546B2F),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: enableButtonCheck(_quantityCount)
                              ? () => {
                                    Navigator.pushNamed(
                                        context, '/checkout_page',
                                        arguments: {
                                          "chosenProduct": product,
                                          "chosenQuantity": _quantityCount,
                                        }),
                                    cartController.updateProduct(
                                        product, _quantityCount),
                                  }
                              : null,
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xFF546B2F),
                              onSurface:
                                  const Color(0xFF546B2F).withOpacity(0.8)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 80.sp, vertical: 2.sp),
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
                      ],
                      //^^^Reserve button^^^
                    )
                    //^^^Quantity Picker^^^
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void launchMap(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  //Quantity counter logic
  int _quantityCount = 0;
  final _quantityCountController = TextEditingController();

  void add(Product product) {
    setState(() {
      _quantityCount++;
      _updateCount(product);
    });
  }

  void minus(Product product) {
    setState(() {
      _quantityCount--;
      _updateCount(product);
    });
  }

  void _updateCount(Product product) {
    if (_quantityCount < 0) {
      _quantityCount = 0;
    } else if (_quantityCount > product.quantityAvailable) {
      _quantityCount = product.quantityAvailable;

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(
              'There are only ${product.quantityAvailable} quantity available'),
        ),
      );
    } else {
      _quantityCountController.text = "$_quantityCount";
    }

    updatePrice(product.price);
  }

  void _updateQuantityCount(int quantityAvailable, String text) {
    int tempQuantityCount = int.parse(text);
    if (tempQuantityCount > quantityAvailable) {
      _quantityCountController.text = "$quantityAvailable";
      _quantityCount = quantityAvailable;
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text('There are only $quantityAvailable quantity available'),
        ),
      );
    } else {
      _quantityCountController.text = "$tempQuantityCount";
      _quantityCount = tempQuantityCount;
    }
    // _updateCount(quantityAvailable);
  }

  @override
  void initState() {
    _quantityCountController.text = "$_quantityCount";
    super.initState();
  }
  //^^^Quantity counter logic^^^

  //Price logic
  double _priceCount = 0;
  void updatePrice(double price) {
    _priceCount = price * _quantityCount;
  }
  //^^^Price logic^^^

  bool enableButtonCheck(int _quantityCount) {
    if (_quantityCount != 0) {
      return true;
    } else {
      return false;
    }
  }
}
