import 'package:flutter/material.dart';

class FoodInventoryScreen extends StatelessWidget {
  const FoodInventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Inventory')),
      body: const Center(
        child: Text('Food item management (CRUD) will be here'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add food item or create meal
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
