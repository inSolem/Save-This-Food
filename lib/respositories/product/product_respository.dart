import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:save_this_food/models/product_model.dart';
import 'base_product_respository.dart';

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProductRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Product>> getAllProducts() {
    return _firebaseFirestore
        .collection("allListings")
        .orderBy("endTime")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<List<Product>> getAllOrders(String email) {
    return _firebaseFirestore
        .collection("allOrders")
        .where((product) => product.email.isEqual(email))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }
}
