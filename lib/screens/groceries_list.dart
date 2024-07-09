import 'package:flutter/material.dart';
import 'package:shopping_list/widgets/GroceryItemWidget.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/screens/new_item_screen.dart';

class GroceriesList extends StatefulWidget {
  const GroceriesList({super.key});

  @override
  State<GroceriesList> createState() => _GroceriesListState();
}

class _GroceriesListState extends State<GroceriesList> {
  void _addItem() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return NewItemScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your groceries",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: GroceryitemWidget(
              name: groceryItems[index].name,
              quantity: groceryItems[index].quantity.toString(),
              categoryColor: groceryItems[index].category.color,
            ),
          );
        },
      ),
    );
  }
}
