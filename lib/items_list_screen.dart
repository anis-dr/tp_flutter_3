import 'package:flutter/material.dart';

import 'constants.dart';
import 'login_screen.dart';

class Dish {
  final int id;
  final String name;
  bool fav;

  Dish({
    required this.id,
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
  final List<Dish> _dishesList = [];
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> onMenuOptionSelected(MenuOptions result) async {
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
  }

  Future<void> getData() async {
    var dishes = await supabase.rpc('get_dishes_for_user', params: {
      'user_id_input': supabase.auth.currentUser!.id,
    });

    final isAdmin = await supabase.rpc("is_admin");

    setState(() {
      _isAdmin = isAdmin;
      _dishesList.clear();
      for (var dish in dishes as List) {
        _dishesList.add(
          Dish(
            id: dish['id'] as int,
            name: dish['name'] as String,
            fav: dish['liked'] as bool,
          ),
        );
      }
    });
  }

  toggleFav(Dish dish) {
    setState(() {
      dish.fav = !dish.fav;
    });
  }

  Future<void> onLikePressed(int index) async {
    toggleFav(_dishesList[index]);
    var dishId = _dishesList[index % _dishesList.length].id;
    if (_dishesList[index % _dishesList.length].fav) {
      try {
        await supabase.from("like").insert([
          {
            "dish_id": dishId,
            "user_id": supabase.auth.currentUser!.id,
          }
        ]);
      } catch (e) {
        debugPrint(e.toString());
        toggleFav(_dishesList[index]);
      }
    } else {
      try {
        await supabase.from("like").delete().match(
          {
            "dish_id": dishId,
            "user_id": supabase.auth.currentUser!.id,
          },
        );
      } catch (e) {
        debugPrint(e.toString());
        toggleFav(_dishesList[index]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: () {
                // TODO: Add a new dish
                Navigator.pushNamed(context, '/add_dish');
              },
              child: const Icon(Icons.add),
            )
          : null,
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (MenuOptions result) async {
              await onMenuOptionSelected(result);
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
        title: const Text('Dishes'),
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
                      onLikePressed(index);
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
