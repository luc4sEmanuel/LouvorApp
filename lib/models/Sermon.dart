import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Culto extends ChangeNotifier {

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef => firestore.document('sermons/$id');

  String id;
  String titulo;
  String texto_base;
  String tema;
  String livro;
  String data;
  String texto;
  String tags;
  String uid;
  String ativo;

  Culto({this.id, this.titulo, this.texto_base, this.tema, this.texto, this.data, this.tags, this.uid, this.ativo}){}

  Culto.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    titulo = document['titulo'] as String;
    texto_base = document['texto_base'] as String;
    tema = document['tema'] as String;
    livro = document['livro'] as String;
    data = document['data'] as String;
    texto = document['texto'] as String;
    tags = document['tags'] as String;
    uid = document['uid'] as String;
    ativo = document['ativo'] as String;
  }

  Future<void> save() async {
    final Map<String, dynamic> blob = {
      'titulo': titulo,
      'texto_base': texto_base,
      'tema': tema,
      'data': data,
      'texto': texto,
      'tags': tags,
      'uid': uid,
      'ativo': ativo,
    };
    if (ativo == null)
      ativo = 'True';
    
    if(id == null){
      final doc = await firestore.collection('sermons').add(blob);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(blob);
    }

    notifyListeners();
  }

  //Sermon();

  Culto.fromTituloDescricao(String titulo, String descricao, String livro, String tema, String data) {
    this.titulo = titulo;
    this.texto_base = descricao;
    this.tema = tema;
    this.livro = livro;
    this.texto = texto;
    this.data = data;
  }

  Culto.fromJson(Map<String, dynamic> json)
      : titulo = json['titulo'],
        texto_base = json['descricao'],
        tema = json['status'],
        livro = json['livro'],
        tags = json['tags'],
        texto = json['texto'],
        data = json['data'],
        uid = json['uid'],
        ativo = json['ativo'];

  Map toJson() => {
    'titulo': titulo,
    'descricao': texto_base,
    'status': tema,
    'livro': livro,
    'tags': tags,
    'texto': texto,
    'data': data,
    'uid': uid,
    'ativo': ativo
  };

  Culto clone(){
    return Culto(
        id: id,
        titulo: titulo,
        texto_base: texto_base,
        tema: tema,
        texto: texto,
        data: data,
        tags: tags,
        uid: uid,
        ativo: ativo
    );
  }

  void delete(Culto s){
    s.ativo = 'False';
    s.save();
    notifyListeners();
  }
}
class Book{
  String nome;
  String abreviatura;
  String testamento;

  Book();

  Book.fromNameTestament(String nome, String abreviatura, String testamento){
    this.nome = nome;
    this.abreviatura = abreviatura;
    this.testamento = testamento;
  }
}