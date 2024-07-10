import 'package:flutter/material.dart';
import 'package:shopping_list/widgets/grocery_item_widget.dart';
import 'package:shopping_list/screens/new_item_screen.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceriesList extends StatefulWidget {
  const GroceriesList({super.key});

  @override
  State<GroceriesList> createState() => _GroceriesListState();
}

class _GroceriesListState extends State<GroceriesList> {
  final List<GroceryItem> _groceryList = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) {
          return const NewItemScreen();
        },
      ),
    );
    if (newItem == null) {
      return;
    }

    _groceryList.add(newItem);
    setState(() {});
  }

  void _removeItem(GroceryItem groceryItem) {
    // final _groceryItemIndex = _groceryList.indexOf(grocery_item);

    setState(() {
      _groceryList.remove(groceryItem);
    });
    print("removed");
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
      body: _groceryList.isEmpty
          ? const Center(
              child: Text("No items yet"),
            )
          : ListView.builder(
              itemCount: _groceryList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(_groceryList[index].id),
                  onDismissed: (direction) {
                    _removeItem(_groceryList[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: GroceryitemWidget(
                      name: _groceryList[index].name,
                      quantity: _groceryList[index].quantity.toString(),
                      categoryColor: _groceryList[index].category.color,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
