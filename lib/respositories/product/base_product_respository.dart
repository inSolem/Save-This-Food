import 'package:save_this_food/models/product_model.dart';

abstract class BaseProductRepository {
  Stream<List<Product>> getAllProducts();
}
