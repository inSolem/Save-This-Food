import 'package:equatable/equatable.dart';
import '/models/product_model.dart';

class Checkout extends Equatable {
  final List<Product> products;

  const Checkout({this.products = const <Product>[]});

  @override
  List<Object?> get props => [products];

  Map productQuantity(products) {
    var quantity = Map();

    products.forEach((product) {
      if (!quantity.containsKey(product)) {
        quantity[product] = 1;
      } else {
        quantity[product] += 1;
      }
    });

    return quantity;
  }

  double get total =>
      products.fold(0, (total, current) => total + current.price);

  String get totalString => total.toStringAsFixed(2);
}
