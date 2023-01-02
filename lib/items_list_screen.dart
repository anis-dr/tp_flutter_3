import 'package:flutter/material.dart';

import 'constants.dart';
import 'login_screen.dart';

class Dish {
  final String name;
  bool fav;

  Dish({
    required this.name,
    required this.fav,
  });
}

class ItemsListScreen extends StatefulWidget {
  const ItemsListScreen({Key? key}) : super(key: key);

  @override
  State<ItemsListScreen> createState() => _ItemsListScreenState();
}

enum MenuOptions { LOGOUT }

class _ItemsListScreenState extends State<ItemsListScreen> {
  final List<Dish> _dishesList = [
    Dish(name: "Pizza", fav: false),
    Dish(name: "Pasta", fav: false),
    Dish(name: "Burger", fav: false),
    Dish(name: "Salad", fav: false),
    Dish(name: "Sandwich", fav: false),
    Dish(name: "Soup", fav: false),
    Dish(name: "Fries", fav: false),
    Dish(name: "Tacos", fav: false),
    Dish(name: "Burrito", fav: false),
    Dish(name: "Sushi", fav: false),
    Dish(name: "Ramen", fav: false),
    Dish(name: "Noodles", fav: false),
    Dish(name: "Steak", fav: false),
    Dish(name: "Chicken", fav: false),
    Dish(name: "Fish", fav: false),
    Dish(name: "Rice", fav: false),
    Dish(name: "Eggs", fav: false),
    Dish(name: "Pancakes", fav: false),
    Dish(name: "Waffles", fav: false),
    Dish(name: "Ice Cream", fav: false),
    Dish(name: "Cake", fav: false),
    Dish(name: "Pie", fav: false),
    Dish(name: "Cookies", fav: false),
    Dish(name: "Donuts", fav: false),
    Dish(name: "Cupcakes", fav: false),
    Dish(name: "Muffins", fav: false),
    Dish(name: "Candy", fav: false),
    Dish(name: "Chocolate", fav: false),
    Dish(name: "Cheese", fav: false),
    Dish(name: "Bread", fav: false),
    Dish(name: "Peanut Butter", fav: false),
    Dish(name: "Jelly", fav: false),
    Dish(name: "Jam", fav: false),
    Dish(name: "Honey", fav: false),
    Dish(name: "Milk", fav: false),
    Dish(name: "Juice", fav: false),
    Dish(name: "Water", fav: false),
    Dish(name: "Tea", fav: false),
    Dish(name: "Coffee", fav: false),
    Dish(name: "Soda", fav: false),
    Dish(name: "Beer", fav: false),
    Dish(name: "Wine", fav: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (MenuOptions result) async {
              switch (result) {
                case MenuOptions.LOGOUT:
                  await supabase.auth.signOut();
                  // Navigate to the login screen
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  break;
              }
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: MenuOptions.LOGOUT,
                  child: Text('Logout'),
                )
              ];
            },
          ),
        ],
        title: const Text('Movies List'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            shrinkWrap: false,
            itemCount: _dishesList.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(_dishesList[index % _dishesList.length].name),
                  trailing: IconButton(
                    icon: Icon(
                      _dishesList[index % _dishesList.length].fav
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _dishesList[index % _dishesList.length].fav
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _dishesList[index % _dishesList.length].fav =
                            !_dishesList[index % _dishesList.length].fav;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
