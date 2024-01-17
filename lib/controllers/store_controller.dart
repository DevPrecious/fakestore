import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fakestore/models/product_model.dart';
import 'package:fakestore/repository/store_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final StoreRepository _repository = StoreRepository();
  Either<String, List<ProductModel>> products = right([]);
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void load() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isLoading = !isLoading;
      refresh();
    });
  }

  fetchProducts() async {
    try {
      load();
      var result = await _repository.getProducts();
      result.fold(
        (error) => print("Error: $error"),
        (data) {
          products = right(data);
          update();
        },
      );
    } finally {
      load();
    }
  }
}
