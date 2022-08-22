import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_this_food/respositories/product/product_respository.dart';
import '../../models/paymentCheckout_model.dart';
import '../../models/product_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription? _productSubscription;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductLoading()) {
    on<LoadProducts>(_onLoadProducts);
    on<UpdateProducts>(_onUpdateProducts);
  }

  void _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) {
    _productSubscription?.cancel();
    _productSubscription = _productRepository.getAllProducts().listen(
          (products) => add(
            UpdateProducts(products),
          ),
        );
  }

  void _onUpdateProducts(
    UpdateProducts event,
    Emitter<ProductState> emit,
  ) {
    emit(ProductLoaded(products: event.products));
  }
}
