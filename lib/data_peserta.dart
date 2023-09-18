import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir_training/nama_peserta.dart';
import 'main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/peserta_bloc.dart';

class DataPeserta extends StatefulWidget {
  const DataPeserta({super.key});

  @override
  State<DataPeserta> createState() => _DataPesertaState();
}

class _DataPesertaState extends State<DataPeserta> {

  late PesertaBloc pesertaBloc;
  List<NamaPeserta> pesertaList = [];

  @override
  void initState(){
    super.initState();
    pesertaBloc = BlocProvider.of<PesertaBloc>(context);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Demo'),
        //add theme to this appbar
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: BlocBuilder<PesertaBloc, PesertaState>(
        builder: (context, state) {
          if (state is ListPesertaInitial) {
            saveSharedPreferences(state.listPeserta);
            return ListView.builder(
              itemCount: state.listPeserta.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(state.listPeserta[index].namaPeserta),
                    subtitle: Text(state.listPeserta[index].idPeserta),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {

                        }, icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {

                        }, icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );
              }
            );
          }
          return Container();
        },
      ),
      //add floatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => showAddDialog());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  AlertDialog showAddDialog() {
    var namaController = TextEditingController();
    var nikController = TextEditingController();

    return AlertDialog(
      title: const Text("Tambah Data"),
      content: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text("Nama"),
          ),
           TextField(
            controller: namaController,
            decoration: const InputDecoration(
              hintText: "Masukkan Nama",
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text("NIK"),
          ),
           TextField(
            controller: nikController,
            decoration: const InputDecoration(
              hintText: "Masukkan NIK",
            ),
          ),

        ],
      ),
      actions: [
        ElevatedButton(onPressed: () {
          pesertaBloc.add(AddNewPeserta(nikController.text, namaController.text));
          Navigator.of(context).pop();
        }, child: const Text("Tambah")),

      ],
    );
  }
  
  Future<void> saveSharedPreferences(List<NamaPeserta> listPeserta) async {
    List<Map<String, dynamic>> jsonList = listPeserta.map((obj) => obj.toJson()).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("PesertaList", jsonList.map((e) => jsonEncode(e)).toList());
  }

  Future<List<NamaPeserta>> loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList("PesertaList") ?? [];
    return jsonList.map((e) => NamaPeserta.fromJson(jsonDecode(e))).toList();
  }

  void loadData() async {

    if (pesertaList.isEmpty) {
      pesertaList = await loadSharedPreferences();
      pesertaList.forEach((element) {
        pesertaBloc.add(AddNewPeserta(element.idPeserta, element.namaPeserta));
      });
    }
    pesertaBloc.add(ShowPeserta());
  }

}

