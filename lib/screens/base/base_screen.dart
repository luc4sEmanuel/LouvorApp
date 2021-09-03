import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/models/page_manager.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:louvor_app/screens/login/login_screen.dart';
import 'package:louvor_app/screens/sermon_list.dart';
import 'package:louvor_app/screens/sermons/sermons_screen.dart';
import 'package:firebase_admob/firebase_admob.dart';

class BaseScreen extends StatelessWidget {

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
      builder: (_, userManager, __){
    return PageView(
    controller: pageController,
    physics: const NeverScrollableScrollPhysics(),
    children: <Widget>[
      Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: const Text('Louvor'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset("assets/sermon_tile.png", width: 900),
        ),
//        body: GestureDetector(
//    onTap: (){
//        Navigator.of(context).pushNamed('/sermons');
//        }
//        ),
      ),
    CultosScreen(),
    ],
    );
      },
    ),
    );
  }
}