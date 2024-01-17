import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fakestore/models/product_model.dart';
import 'package:http/http.dart' as http;

class StoreRepository {
  Uri url = Uri.parse('https://fakestoreapi.com/products');

  Future<Either<String, List<ProductModel>>> getProducts() async {
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        List<ProductModel> products =
            jsonList.map((json) => ProductModel.fromJson(json)).toList();
        return right(products);
      }
      throw 'Some unexpected error occured!';
    } catch (e) {
      return left("from here ${e.toString()}");
    }
  }
}
