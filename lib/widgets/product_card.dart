import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_this_food/controllers/cart_controller.dart';

import '../models/product_model.dart';

import '../controllers/cart_controller.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final int chosenQuantity;
  final CartController controller;
  final bool isFirstCard;

  const ProductCard({
    Key? key,
    required this.product,
    required this.chosenQuantity,
    required this.controller,
    required this.isFirstCard,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  void dispose() {
    _quantityCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product;
    final bool isFirstCard = widget.isFirstCard;

    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/product_page', arguments: {
            "chosenProduct": product,
            "displayButton": false,
          });
        },
        child: Container(
          height: 135,
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Color(0xFFDFB288), width: 1),
                  top: BorderSide(color: Color(0xFFDFB288), width: 1))),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, bottom: 5, top: 10, right: 5),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xFFDFB288), width: 1),
                              top: BorderSide(
                                  color: Color(0xFFDFB288), width: 1))),
                      child: Image.network(
                        product.listingImage,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text("Stock: ${product.quantityAvailable}",
                        style: const TextStyle(
                          fontSize: 12,
                        ))
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.listingName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Collect: ${product.displayCollectionTimeForProductScreen()}",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      // const SizedBox(
                      //   height: 1,
                      // ),
                      // Text("${product.description}",
                      //     style: const TextStyle(
                      //       fontSize: 12,
                      //     )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          "\u0024 ${product.price.toStringAsFixed(2)} / ${product.unitOfMeasurement}",
                          style: const TextStyle(
                            color: Color(0xFF556B2F),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide(color: Color(0xFFDFB288), width: 1),
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Quantity",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFCC8441),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Color(0xFFCC8441),
                                  ),
                                  onPressed: isFirstCard
                                      ? () {}
                                      : () {
                                          minus(product);
                                        },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: TextField(
                                    readOnly: isFirstCard,
                                    textAlign: TextAlign.center,
                                    controller: _quantityCountController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      FilteringTextInputFormatter.deny("." "-"),
                                    ],
                                    style: const TextStyle(
                                        fontSize: 16, color: Color(0xFFCC8441)),
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
                                      _updateQuantityCount(
                                          product.quantityAvailable, text);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Color(0xFFCC8441),
                                  ),
                                  onPressed: isFirstCard
                                      ? () {}
                                      : () {
                                          add(product);
                                        },
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "\u0024 ${_priceCount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF546B2F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
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
      widget.controller.updateProduct(product, _quantityCount);
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
    int chosenQuantity = widget.chosenQuantity;
    _quantityCount = chosenQuantity;
    _quantityCountController.text = "$chosenQuantity";
    updatePrice(widget.product.price);
    super.initState();
  }
  //^^^Quantity counter logic^^^

  //Price logic
  double _priceCount = 0;
  void updatePrice(double price) {
    _priceCount = price * _quantityCount;
  }
  //^^^Price logic^^^
}
