import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reto_cotrafa/core/router/routes.dart';

class MenuComponent extends StatefulWidget {
  const MenuComponent({super.key});

  @override
  State<StatefulWidget> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<MenuComponent> {
  Map<String, String?> credentials = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('test'),
            accountEmail: Text(credentials['email'] ?? ''),
            currentAccountPicture: CircleAvatar(),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Inicio"),
            onTap: () {
              context.go(Routes.home);
            },
          ),
          ExpansionTile(
            title: Text("Inventario"),
            leading: Icon(Icons.shopping_cart),
            children: [
              GestureDetector(
                child: Container(
                    width: 250,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.black26,
                    )),
                    child: Text("Agregar Inventario",
                        style: TextStyle(color: Colors.black))),
                onTap: () {
                  context.go(Routes.addInventory);
                },
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Container(
                    width: 250,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.black26,
                    )),
                    child: Text(
                      "Consultar Inventario",
                      style: TextStyle(color: Colors.black),
                    )),
                onTap: () {
                  context.go(Routes.inventories);
                },
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
