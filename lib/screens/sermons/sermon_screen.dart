import 'package:flutter/material.dart';
import 'package:louvor_app/models/Sermon.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/models/sermon_manager.dart';

class CultoScreen extends StatelessWidget {

  CultoScreen(Culto s) : sermon = s != null ? s.clone() : Culto();

  final Culto sermon;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
        value: sermon,
    child: Scaffold(
      appBar: AppBar(
        title: sermon != null ? Text("Música") : Text(sermon.titulo),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                TextFormField(
                      initialValue: sermon.titulo,
                      onSaved: (titulo) => sermon.titulo = titulo,
                      decoration: const InputDecoration(
                        hintText: 'Nome',
                        border: InputBorder.none,
                        labelText: 'Nome',
                      ),
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextFormField(
                      initialValue: sermon.texto_base,
                      onSaved: (tb) => sermon.texto_base = tb,
                      decoration: const InputDecoration(
                        hintText: 'Artista',
                        border: InputBorder.none,
                        labelText: 'Artista',
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextFormField(
                      initialValue: sermon.tags,
                      onSaved: (tags) => sermon.tags = tags,
                      decoration: const InputDecoration(
                        hintText: 'Letra',
                        border: InputBorder.none,
                        labelText: 'Letra',
                      ),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: TextFormField(
                      initialValue: sermon.tema,
                      onSaved: (tema) => sermon.tema = tema,
                      decoration: const InputDecoration(
                        hintText: 'Tom',
                        border: InputBorder.none,
                        labelText: 'Tom',
                      ),
                      style: const TextStyle(
                          fontSize: 16
                      ),
                    ),
                  ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: TextFormField(
                    initialValue: sermon.texto,
                    onSaved: (texto) => sermon.texto = texto,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      filled: true,
                      hintText: 'Cifra',
                      labelText: 'Cifra',
                    ),
                    onChanged: (value) {
                      sermon.texto = value;
                    },
                    maxLines: 5,
                  ),
              ),
            Consumer<Culto>(
               builder: (_, sermon, __) {
                 return RaisedButton(
                   onPressed: () async {
                     if (formKey.currentState.validate()) {
                       formKey.currentState.save();
                       await sermon.save();
                       context.read<CultoManager>().update(sermon);
                       Navigator.of(context).pop();
                     }
                   },
                   textColor: Colors.white,
                   color: primaryColor,
                   disabledColor: primaryColor.withAlpha(100),
                   child: const Text(
                     'Salvar',
                     style: TextStyle(fontSize: 18.0),
                   ),
                 );
               },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}