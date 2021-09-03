import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:louvor_app/screens/base/base_screen.dart';
import 'package:louvor_app/screens/login/login_screen.dart';
import 'package:louvor_app/screens/sermon_list.dart';
import 'package:louvor_app/screens/sermons/sermon_screen.dart';
import 'package:louvor_app/screens/sermons/sermons_screen.dart';
import 'package:louvor_app/screens/signup/signup_screen.dart';

import 'models/Sermon.dart';
import 'models/sermon_manager.dart';

Future<void> main() async {
  runApp(MyApp());
}
//Future<void> main() async {
//
//  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();
//
//  runApp(MaterialApp(
//    home: LoginScreen(),
//    localizationsDelegates: [
//      GlobalMaterialLocalizations.delegate,
//      GlobalWidgetsLocalizations.delegate
//    ],
//    supportedLocales: [const Locale('pt', 'BR')],
//  ));
//}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CultoManager>(
          create: (_) => CultoManager(),
          lazy: false,
          update: (_, userManager, sermonManager) =>
              sermonManager..updateUser(userManager),
        )
      ],
      child: MaterialApp(
        title: 'Louvor',
        debugShowCheckedModeBanner: false,
        home: BaseScreen(),
        initialRoute: '/base',
        onGenerateRoute: (settings){
          switch(settings.name){
            case '/login':
              return MaterialPageRoute(
                  builder: (_) => LoginScreen()
              );
            case '/signup':
              return MaterialPageRoute(
                  builder: (_) => SignUpScreen()
              );
            case '/sermon':
              return MaterialPageRoute(
                  builder: (_) => CultoScreen(
                      settings.arguments as Culto
                  )
              );
            case '/sermons':
              return MaterialPageRoute(
                  builder: (_) => CultosScreen()
              );
            case '/base':
            default:
              return MaterialPageRoute(
                  builder: (_) => BaseScreen()
              );
          }
        },
      ),
    );
  }
}