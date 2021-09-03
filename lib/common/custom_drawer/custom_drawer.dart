import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/common/custom_drawer/drawer_tile.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer_header.dart';
import 'package:louvor_app/models/user_manager.dart';

class CustomDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<UserManager>(
        builder: (_, userManager, __)
    {
      return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 203, 236, 241),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
            ),
          ),
          ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              const Divider(),
              DrawerTile(
                iconData: Icons.home,
                title: 'Início',
                page: 0,
              ),
              DrawerTile(
                iconData: Icons.library_books,
                title: 'Cultos',
                page: 1,
              ),
            ],
          ),
        ],
      );
    }
    ),
    );
  }
}