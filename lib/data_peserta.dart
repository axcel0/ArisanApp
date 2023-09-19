import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
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
    print("Page : initState");
    pesertaBloc = BlocProvider.of<PesertaBloc>(context);
    pesertaBloc.add(DeleteAllPeserta());
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    print("Page : build");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Peserta',),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: BlocBuilder<PesertaBloc, PesertaState>(
        builder: (context, state) {
          if (state is ListPesertaInitial && state.listPeserta.isNotEmpty) {
            print("if state");
            print("state.listPeserta.length : ${state.listPeserta.length}");
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
                              //add dialog to confirm delete
                              showDialog(context: context, builder: (context) => AlertDialog(
                                title: const Text("Konfirmasi"),
                                content: const Text("Apakah anda yakin ingin menghapus data ini?"),
                                actions: [
                                  ElevatedButton(onPressed: () {
                                    setState(() {
                                      pesertaBloc.add(DeletePeserta(state.listPeserta[index].idPeserta));
                                      pesertaList.removeWhere((element) => element.idPeserta == state.listPeserta[index].idPeserta);
                                      updateSharedPreferences(pesertaList);
                                      Navigator.of(context).pop();
                                      Flushbar(
                                        backgroundColor: Colors.green,
                                        icon: const Icon(
                                          Icons.info_outline,
                                          color: Colors.white,
                                        ),
                                        title: "Success!",
                                        message: "Data berhasil dihapus",
                                        duration: const Duration(seconds: 2),
                                      ).show(context);
                                    });
                                  }, child: const Text("Ya")),
                                  ElevatedButton(onPressed: () {
                                    Navigator.of(context).pop();
                                  }, child: const Text("Tidak")),
                                ],
                              ));
                        }, icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );
              }
            );
          }else{
            return const Center(
              child: Text("Data Peserta masih kosong"),
            );
          }
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
          //check if the textfield is empty or not
        setState(() {
        if (namaController.text.isEmpty || nikController.text.isEmpty) {
          Navigator.of(context).pop();
          Flushbar(
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            title: "Warning!",
            message: "Data tidak boleh ada yang kosong",
            duration: const Duration(seconds: 2),
          ).show(context);
        } else {
          //if data already exist, notify user using snackbar from flushbar
          if(pesertaList.any((element) => element.namaPeserta == namaController.text) && pesertaList.any((element) => element.idPeserta == nikController.text)){
            Navigator.of(context).pop();
            Flushbar(
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              title: "Warning!",
              message: "Data sudah ada",
              duration: const Duration(seconds: 2),
            ).show(context);
          }else{
            //if data not exist, add data to list and save it to shared preferences
            pesertaBloc.add(AddNewPeserta(nikController.text, namaController.text));
            saveSharedPreferences([NamaPeserta(idPeserta: nikController.text, namaPeserta: namaController.text)]);
            Navigator.of(context).pop();
            Flushbar(
              backgroundColor: Colors.green,
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              title: "Success!",
              message: "Data berhasil ditambahkan",
              duration: const Duration(seconds: 2),
            ).show(context);
          }
        }
      });
    },
        child: const Text("Save")),
      ],
    );
  }
  
  Future<void> saveSharedPreferences(List<NamaPeserta> listPeserta) async {
    print("Page : saveSP");
    pesertaList.addAll(listPeserta);
    List<Map<String, dynamic>> jsonList = pesertaList.map((obj) => obj.toJson()).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("PesertaList", jsonList.map((e) => jsonEncode(e)).toList());
  }

  Future<void> updateSharedPreferences(List<NamaPeserta> listPeserta) async {
    print("Page : updateSP");
    pesertaList = listPeserta;
    List<Map<String, dynamic>> jsonList = pesertaList.map((obj) => obj.toJson()).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("PesertaList", jsonList.map((e) => jsonEncode(e)).toList());
  }

  void loadData() async {
    print("Page : loadData");
    pesertaList = await loadSharedPreferences();
    for (var element in pesertaList) {
      pesertaBloc.add(LoadPeserta(element.idPeserta, element.namaPeserta));
    }

    print(pesertaList.length);
    pesertaBloc.add(ShowPeserta());
  }

  Future<List<NamaPeserta>> loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList("PesertaList") ?? [];
    return jsonList.map((e) => NamaPeserta.fromJson(jsonDecode(e))).toList();
  }


}

