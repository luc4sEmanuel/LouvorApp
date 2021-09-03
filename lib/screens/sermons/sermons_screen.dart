import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/models/sermon_manager.dart';
import 'package:louvor_app/screens/sermons/components/sermon_list_tile.dart';
import 'package:provider/provider.dart';

import 'components/search_dialog.dart';
import 'components/sermon_list_tile.dart';

class CultosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<CultoManager>(
          builder: (_, sermonManager, __){
            if(sermonManager.search.isEmpty){
              return const Text('Músicas');
            } else {
              return LayoutBuilder(
                builder: (_, constraints){
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(context: context,
                          builder: (_) => SearchDialog(sermonManager.search));
                      if(search != null){
                        sermonManager.search = search;
                      }
                    },
                    child: Container(
                        width: constraints.biggest.width,
                        child: Text(
                          'Músicas: ${sermonManager.search}',
                          textAlign: TextAlign.center,
                        )
                    ),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          Consumer<CultoManager>(
            builder: (_, sermonManager, __){
              if(sermonManager.search.isEmpty){
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(context: context,
                        builder: (_) => SearchDialog(sermonManager.search));
                    if(search != null){
                      sermonManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    sermonManager.search = '';
                  },
                );
              }
            },
          ),
          IconButton(icon: Icon(Icons.add),
    onPressed: (){
    Navigator.of(context).pushNamed(
    '/sermon',
    ); },
    )
    ],
      ),
      body: Consumer<CultoManager>(
        builder: (_, sermonManager, __){
          final filteredSermons = sermonManager.filteredSermons;
          return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: filteredSermons.length,
              itemBuilder: (_, index){
                return SermonListTile(filteredSermons[index]);
              }
          );
        },
      ),
    );
  }
}