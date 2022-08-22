import 'package:flutter/widgets.dart';
import 'package:save_this_food/controllers/cart_controller.dart';
import 'package:save_this_food/models/product_model.dart';

class PaymentCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final int index;

  const PaymentCard({
    Key? key,
    required this.product,
    required this.quantity,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalUnitPrice = quantity * product.price;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${product.listingName}",
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${quantity} ${product.unitOfMeasurement}",
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "\u0024 ${totalUnitPrice.toStringAsFixed(2)}",
                  ),
                ),
              )
            ],
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  product.displayCollectionTime(),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w300),
                ),
              )),
        ],
      ),
    );
  }
}
