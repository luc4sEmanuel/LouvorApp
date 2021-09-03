import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:louvor_app/models/user.dart';
import 'package:louvor_app/models/user_manager.dart';

import 'Sermon.dart';

class CultoManager extends ChangeNotifier{

  CultoManager(){
   // _loadAllSermons();
  }

  final Firestore firestore = Firestore.instance;

  User user;

  List<Culto> allSermons = [];

  String _search = '';

  String get search => _search;
  set search(String value){
    _search = value;
    notifyListeners();
  }

  List<Culto> get filteredSermons {
    final List<Culto> filteredSermons = [];

    if(search.isEmpty){
      filteredSermons.addAll(allSermons);
    } else {
      filteredSermons.addAll(
          allSermons.where(
                  (p) => p.titulo.toLowerCase().contains(search.toLowerCase())
          )
      );
    }

    return filteredSermons;
  }

  Future<void> _loadAllSermons() async {
    final QuerySnapshot snapSermons =
    await firestore.collection('sermons').getDocuments();

    allSermons = snapSermons.documents.map(
            (d) => Culto.fromDocument(d)).toList();

    notifyListeners();
  }

  Future<void> _loadAllSermon(UserManager userManager) async {
    final QuerySnapshot snapSermons =
    await firestore.collection('sermons').where('uid', isEqualTo: userManager.user.id).where('ativo', isEqualTo: 'True').getDocuments();

    allSermons = snapSermons.documents.map(
            (d) => Culto.fromDocument(d)).toList();

    notifyListeners();
  }

  void update(Culto sermon){
    allSermons.removeWhere((s) => s.id == sermon.id);
    sermon.uid = user.id;
    print(sermon.ativo);
    allSermons.add(sermon);
    sermon.save();
  notifyListeners();
}

  updateUser(UserManager userManager) {
    user = userManager.user;

    if(user != null){
      _loadAllSermon(userManager);
    }
  }

}