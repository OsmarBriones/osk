import 'package:flutter/material.dart';
import 'package:untitled/Global/OSKEncryptor.dart';
import 'package:untitled/Secret/Infrastructure/SecretsDao.dart';
import 'Secret/Application/SecretsManager.dart';
import 'Secret/Infrastructure/Pages/SecretsMainPage.dart';
import '../../Global/OSKGlobals.dart' as globals;
import 'Testing.dart';
import 'Global/OSKServer.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await SecretsDao.save(OSKEncryptor.encrypt('[{"secretId":1,"userId":"osmar123","secret":"8908235","uris":["www.facebook.com","www.mobile.facebook.com"]},{"secretId":2,"userId":"osmar123","secret":"j9gb5409","uris":["www.twitter.com","www.mobile.twitter.com"]}]',globals.masterSecret));
  await initApp();
  runApp(const Osk());
}

Future<void> initApp() async {

  await SecretsManager.initData();
  OSKServer.start();

}

class Osk extends StatelessWidget {
  const Osk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)  {

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Open Secret Keeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SecretsManager.getMainScreen(),
    );
  }
}