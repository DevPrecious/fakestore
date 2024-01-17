import 'package:fakestore/controllers/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StoreController _storeController;

  @override
  void initState() {
    _storeController = Get.put(StoreController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {},
        child: const Icon(Icons.shopping_cart),
      ),
      appBar: AppBar(
        title: const Text('Fake Store'),
        centerTitle: true,
        elevation: 0,
      ),
      body: GetBuilder<StoreController>(
          init: _storeController,
          builder: (controller) {
            return RefreshIndicator(
              onRefresh: () async {
                await controller.fetchProducts();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GetBuilder<StoreController>(
                      init: _storeController,
                      builder: (controller) {
                        return controller.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (controller.products
                                      .isLeft()) // Check if there's an error
                                    Text(
                                        'Error: ${controller.products.fold((l) => l, (r) => '')}'),
                                  if (controller.products
                                      .isRight()) // Check if there's a list of products
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8.0,
                                        mainAxisSpacing: 8.0,
                                      ),
                                      itemCount: controller.products
                                          .fold((l) => 0, (r) => r.length),
                                      itemBuilder: (context, index) {
                                        var product = controller.products.fold(
                                          (l) =>
                                              null, // Error case, return null
                                          (r) => r[index],
                                        );

                                        if (product == null) {
                                          // Handle error case
                                          return Container();
                                        }

                                        // Build your product item UI here
                                        return Card(
                                          child: Column(
                                            children: [
                                              Image.network(
                                                product.image ?? '',
                                                height: 130.0,
                                                width: double.infinity,
                                              ),
                                              Expanded(
                                                child:
                                                    Text(product.title ?? ''),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
