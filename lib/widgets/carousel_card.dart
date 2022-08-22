import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../models/product_model.dart';

class CarouselCard extends StatelessWidget {
  final Product? product;
  final bool disableInkWell;

  const CarouselCard({
    Key? key,
    this.product,
    required this.disableInkWell,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return AbsorbPointer(
        absorbing: disableInkWell,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/product_page', arguments: {
              "chosenProduct": product,
              "displayButton": true,
            });
          },
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 200,
                  ),
                  Positioned.fill(
                    top: 0,
                    child: Container(
                      height: 120,
                      width: 300,
                      child: Image.network(
                        product!.listingImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 0,
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
                  Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        color: const Color(0xFFDFB288),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: Text(
                            "${product?.quantityAvailable} left",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                  Positioned(
                    bottom: 90,
                    left: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: const Color(0xFF556B2F),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(product!.businessLogo),
                              backgroundColor: Colors.white,
                              radius: 24,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            product!.businessName,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product!.listingName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            product!.displayCollectionTime(),
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "\u0024 ${product!.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF556B2F)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );
    });
  }
}
