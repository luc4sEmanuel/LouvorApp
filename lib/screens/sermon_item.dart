import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:louvor_app/models/Sermon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CultoItem extends StatefulWidget {
  final Culto todo;
  final int index;

  CultoItem({Key key, @required this.todo, @required this.index})
      : super(key: key);

  @override
  _CultoItemState createState() => _CultoItemState(todo, index);
}

class _CultoItemState extends State<CultoItem> {
  final List<String> _livros = <String>[ 'Gênesis', 'Êxodo', 'Levítico', 'Números', 'Deuteronômio', 'Josué', 'Juízes', 'Rute', 'I Samuel', 'II Samuel', 'I Reis', 'II Reis', 'I Crônicas', 'II Crônicas', 'Esdras', 'Neemias',
    'Ester', 'Jó', 'Salmos', 'Provérbios', 'Eclesiastes', 'Cânticos dos Cânticos', 'Isaías', 'Jeremias', 'Lamentações', 'Ezequiel', 'Daniel', 'Oseias', 'Joel', 'Amós', 'Obadias', 'Jonas', 'Miqueias', 'Naum', 'Habacuque',
    'Sofonias', 'Ageu', 'Zacarias', 'Malaquias', 'Mateus', 'Marcos', 'Lucas', 'João', 'Atos', 'Romanos', '1 Coríntios', '2 Coríntios', 'Gálatas', 'Efésios', 'Filipenses', 'Colossenses', '1 Tessalonicenses', '2 Tessalonicenses',
    '1 Timóteo', '2 Timóteo', 'Tito', 'Filemom', 'Hebreus', 'Tiago', '1 Pedro', '2 Pedro', '1 João', '2 João', '3 João', 'Judas', 'Apocalipse'];

  final List<String> _abrev = <String>['Gn','Êx','Lv','Nm','Dt','Js','Jz','Rt','1Sm','2Sm','1Rs','2Rs','1Cr','2Cr','Ed','Ne','Et','Jó','Sl','Pv','Ec','Ct','Is','Jr','Lm','Ez','Dn','Os','Jl','Am','Ob','Jn','Mq','Na','Hc','Sf','Ag','Zc','Ml','Mt','Mc','Lc','Jo','At','Rm','1Co','2Co','Gl','Ef','Fp','Cl','Ts','2Ts','1Tn','2Tm','Tt','Fm','Hb','Tg','1Pe','2Pe','1Jo','2Jo','3Jo','Jd','Ap'];

  List<Book> book = List<Book>(66);
  String livro = 'Mateus';
  Culto _todo;
  int _index;
  DateTime date = DateTime.now();
  String dateStr = '';

  void initState() {
    super.initState();
    dateStr = date.toString();
    //Fix livros do AT e NT
    String t = '';
    for(int i=0; i<66;i++){
      if(i<39){
        t = 'AT';
      }
      else {
        t = 'NT';
      }
      book[i] = Book.fromNameTestament(_livros[i],_abrev[i],t);
    }
  }

  final _tituloController = TextEditingController();
  final _texto_baseController = TextEditingController();
  final _temaController = TextEditingController();
  final _dataController = TextEditingController();

  final key = GlobalKey<ScaffoldState>();

  _CultoItemState(Culto todo, int index) {
    this._todo = todo;
    this._index = index;
    if (_todo != null) {
      _tituloController.text = _todo.titulo;
      _texto_baseController.text = _todo.texto_base;
      _temaController.text = _todo.tema;
      livro = _todo.livro;
      dateStr = _todo.data;
      date = DateTime.parse(dateStr);
    }
  }

  _saveItem() async {
    if (_tituloController.text.isEmpty || _temaController.text.isEmpty) {
      key.currentState.showSnackBar(SnackBar(
          content: Text('Título e tema são obrigatórios.')
      ));
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Culto> list = [];

      var data = prefs.getString('list');
      if (data != null) {
        var objs = jsonDecode(data) as List;
        list = objs.map((obj) => Culto.fromJson(obj)).toList();
      }

      _todo = Culto.fromTituloDescricao(
          _tituloController.text, _texto_baseController.text, livro, _temaController.text, dateStr);
      if (_index != -1) {
        list[_index] = _todo;
      } else {
        list.add(_todo);
      }
      prefs.setString('list', jsonEncode(list));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text('Cadastrar Culto')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _tituloController,
                decoration: InputDecoration(
                    hintText: 'Título',
                    border: OutlineInputBorder(),
                    labelText: 'Título'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _temaController,
                decoration: InputDecoration(
                    hintText: 'Tema',
                    border: OutlineInputBorder(),
                    labelText: 'Tema'),
              ),
            ),
            SearchableDropdown.single(
              items: _livros.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: livro,
              hint: "Selecione um livro",
              searchHint: "Selecione um livro",
              onChanged: (value) {
                setState(() {
                  livro = value;
                  List<String> verso = _texto_baseController.text.split(' ');
                  if(verso.length <= 1)
                    _texto_baseController.text = value + ' ';
                  else
                    _texto_baseController.text = value + ' ' + verso[1];
                });
              },
              isExpanded: true,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _texto_baseController,
                decoration: InputDecoration(
                    hintText: 'Texto-base',
                    border: OutlineInputBorder(),
                    labelText: 'Texto-base'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _FormDatePicker(
                date: date,
                onChanged: (value) {
                  setState(() {
                    date = value;
                    dateStr = date.toString();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                minWidth: double.infinity,
                child: RaisedButton(
                  child: Text(
                    'Salvar',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () => _saveItem(),
                ),
              ),
            ),
          ],
        ));
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged onChanged;

  _FormDatePicker({
    this.date,
    this.onChanged,
  });

  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Data',
              ///style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              intl.DateFormat.yMd('pt_BR').format(widget.date),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        FlatButton(
          child: Text('Alterar'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              locale : const Locale("pt","BR"),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}
