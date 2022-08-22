import 'package:get/get.dart';
import 'package:save_this_food/models/product_model.dart';

class CartController extends GetxController {
  var _products = {}.obs;

  void updateProduct(Product product, int quantity) {
    if (quantity == 0) {
      _products.removeWhere((key, value) => key == product);
    } else {
      _products[product] = quantity;
    }
  }

  void emptyCart() {
    _products = {}.obs;
  }

  get products => _products;

  get total => _products.entries
      .map((product) => product.key.price * product.value)
      .toList()
      .reduce((value, element) => value + element);

  get businessName => _products.entries.first.key.businessName;

  get purchases => _products.entries
      .map((product) => purchase(product.key.listingId, product.value,
          product.key.price, product.key.startTime, product.key.endTime))
      .toList();
}

Map<String, dynamic> purchase(String listingId, int quantity, double unitCost,
    DateTime startTime, DateTime endTime) {
  return {
    "listingID": listingId,
    "purchaseQuantity": quantity,
    "pricePerUnit": unitCost,
    "startTime": startTime,
    "endTime": endTime,
  };
}
