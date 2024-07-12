import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/widgets/grocery_item_widget.dart';
import 'package:shopping_list/screens/new_item_screen.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class GroceriesList extends StatefulWidget {
  const GroceriesList({super.key});

  @override
  State<GroceriesList> createState() => _GroceriesListState();
}

class _GroceriesListState extends State<GroceriesList> {
  List<GroceryItem> _groceryList = [];
  var _isLoading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'test1-56877-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];

    if (response.statusCode >= 400) {
      error = 'Failed to fetch data. Please try again later.';
      setState(() {});
    }

    for (final item in listData.entries) {
      final category = categories.entries.firstWhere((categoryItem) {
        return categoryItem.value.title == item.value["category"];
      }).value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }

    setState(() {
      _groceryList = loadedItems;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) {
          return const NewItemScreen();
        },
      ),
    );

    if (newItem == null) return;

    setState(() {
      _groceryList.add(newItem);
    });
  }

  void _removeItem(GroceryItem groceryItem) async {
    final index = _groceryList.indexOf(groceryItem);

    setState(() {
      _groceryList.remove(groceryItem);
    });

    final url = Uri.https('test1-56877-default-rtdb.firebaseio.com',
        'shopping-list/${groceryItem.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryList.insert(index, groceryItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget showContent = const Center(
      child: Text("No items yet"),
    );

    if (_isLoading)
      showContent = Center(
        child: CircularProgressIndicator(),
      );

    if (_groceryList.isNotEmpty) {
      showContent = ListView.builder(
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
      );
    }

    if (error != null) {
      showContent = Center(
        child: Text(error!),
      );
    }

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
      body: showContent,
    );
  }
}
