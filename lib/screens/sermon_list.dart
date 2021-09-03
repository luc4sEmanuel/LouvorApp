import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:louvor_app/models/Sermon.dart';
import 'package:louvor_app/screens/sermon_item.dart';
import 'package:firebase_admob/firebase_admob.dart';

class CultoList extends StatefulWidget {
  @override
  _CultoListState createState() => _CultoListState();
}

class _CultoListState extends State<CultoList> {

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['church', 'bible', 'jesus'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[],
  );

  BannerAd myBanner;
  InterstitialAd myInterstitial;
  int clicks = 0;

  void startBanner() {
    myBanner = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.opened) {
          // MobileAdEvent.opened
          // MobileAdEvent.clicked
          // MobileAdEvent.closed
          // MobileAdEvent.failedToLoad
          // MobileAdEvent.impression
          // MobileAdEvent.leftApplication
        }
        print("BannerAd event is $event");
      },
    );
  }

  void displayBanner() {
    myBanner
      ..load()
      ..show(
        anchorOffset: 0.0,
        anchorType: AnchorType.bottom,
      );
  }

  @override
  void dispose() {
    myBanner?.dispose();
    myInterstitial?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-3241906809446166~7375934745");

    startBanner();
    displayBanner();
    _reloadList();
  }

  InterstitialAd buildInterstitial() {
    return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: MobileAdTargetingInfo(testDevices: <String>[]),
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myInterstitial?.show();
          }
          if (event == MobileAdEvent.clicked || event == MobileAdEvent.closed) {
            myInterstitial.dispose();
            clicks = 0;
          }
        });
  }

  void onTap(position) {
    shouldDisplayTheAd();
    if (position == 0) {
      Navigator.pushNamed(context, '/first');
    } else {
      Navigator.pushNamed(context, '/second');
    }
  }

  void shouldDisplayTheAd() {
    clicks++;
    print(clicks.toString());
    if (clicks >= 3) {
      myInterstitial = buildInterstitial()
        ..load()
        ..show();
      clicks = 0;
    }
  }

  List<Culto> list = [];
  final _doneStyle =
  TextStyle(color: Colors.green, decoration: TextDecoration.lineThrough);

  _reloadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('list');
    if (data != null) {
      setState(() {
        var objs = jsonDecode(data) as List;
        list = objs.map((obj) => Culto.fromJson(obj)).toList();
      });
    }
  }

  _removeItem(int index) {
    setState(() {
      list.removeAt(index);
    });
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('list', jsonEncode(list)));
  }

  _showAlertDialog(BuildContext context, String conteudo,
      Function confirmFunction, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text(conteudo),
          actions: [
            FlatButton(
              child: Text('Não'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text('Sim'),
              onPressed: () {
                confirmFunction(index);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Louvor'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${list[index].titulo}'),
            subtitle: Text('${list[index].tema}'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CultoItem(todo: list[index], index: index),
                )).then((value) => _reloadList()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _showAlertDialog(context,
                      'Confirma a exclusão deste culto?', _removeItem, index),
                ),
//                Visibility(
//                  visible: list[index].tema == 'A',
//                  child: IconButton(
//                    icon: Icon(Icons.check),
//                    onPressed: () => _showAlertDialog(context,
//                        'Confirma a finalização deste culto?', _doneItem, index),
//                  ),
//                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CultoItem(todo: null, index: -1),
            )).then((value) => _reloadList()),
      ),
    );
  }
}
