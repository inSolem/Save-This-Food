import 'package:equatable/equatable.dart';
import 'package:save_this_food/models/product_model.dart';

class PCheckout extends Equatable {
  final String? orderID;
  final String? name;
  final String? email;
  final List<Product>? products;
  final String? total;

  const PCheckout({
    required this.orderID,
    required this.name,
    required this.email,
    required this.products,
    required this.total,
  });

  @override
  List<Object?> get props => [orderID, name, email, products, total];

  Map<String, Object> toDocument() {
    return {
      'orderID': orderID!,
      'name': name!,
      'email': email!,
      'products': products!,
      'total': total!,
    };
  }
}
