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
  List<NamaPeserta> pemenangList = [];

  @override
  void initState(){
    super.initState();
    pesertaBloc = BlocProvider.of<PesertaBloc>(context);
    pesertaBloc.add(DeleteAllPeserta());
    pesertaBloc.add(DeleteAllPemenang());
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Data Peserta',),
      ),
      body: BlocBuilder<PesertaBloc, PesertaState>(
        builder: (context, state) {
          if (state is ListPesertaInitial && state.listPeserta.isNotEmpty) {
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
                            showDialog(context: context, builder: (context) => showEditDialog(state.listPeserta[index].idPeserta, state.listPeserta[index].namaPeserta));
                          },
                          icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              //add dialog to confirm delete
                              showDialog(context: context, builder: (context) => AlertDialog(
                                backgroundColor: Colors.white.withOpacity(0.8),
                                title: const Text("Konfirmasi", textAlign: TextAlign.center,),
                                content: const Text("Apakah anda yakin ingin menghapus data ini?", textAlign: TextAlign.center,),
                                actions: [
                                  ElevatedButton(onPressed: () {
                                    Navigator.of(context).pop();
                                  }, child: const Text("Batal", style: TextStyle(color: Colors.blue))),

                                  ElevatedButton(onPressed: () {
                                    Colors.white.withOpacity(0.8);
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
                                  }, child: const Text("Hapus", style: TextStyle(color: Colors.red))),
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

  AlertDialog showEditDialog(String editId, String editNama) {
    var namaController = TextEditingController();
    var nikController = TextEditingController();

    var oldId = editId;
    var oldNama = editNama;

    nikController.text = editId;
    namaController.text = editNama;

    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.8),
      title: const SizedBox(
        height: 25,
        child: Text("Edit Data", textAlign: TextAlign.center,),
      ),
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              //change font family of text
              child: const Text("Nama"),
            ),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                hintText: "Masukkan Nama",
              ),
            ),
            const SizedBox(
              height: 15,
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
              if(pesertaList.any((element) => element.idPeserta == nikController.text && element.idPeserta != oldId)){
                Navigator.of(context).pop();
                Flushbar(
                  backgroundColor: Colors.red,
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  title: "Warning!",
                  message: "NIK sudah ada",
                  duration: const Duration(seconds: 2),
                ).show(context);
              }//NIK must be numeric
              else if(nikController.text.contains(RegExp(r'[a-zA-Z]'))){
                Navigator.of(context).pop();
                Flushbar(
                  backgroundColor: Colors.red,
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  title: "Warning!",
                  message: "NIK harus berupa angka",
                  duration: const Duration(seconds: 2),
                ).show(context);
              }
              else{

                pesertaBloc.add(EditPeserta(nikController.text, namaController.text, oldId, oldNama));
                pesertaBloc.add(EditPemenang(nikController.text, namaController.text, oldId, oldNama));

                var tempList = pesertaList.firstWhere((element) => element.idPeserta == oldId && element.namaPeserta == oldNama);
                tempList.idPeserta = nikController.text;
                tempList.namaPeserta = namaController.text;

                updateSharedPreferences(pesertaList);

                if(pemenangList.any((element) => element.idPeserta == oldId)){
                  var tempPemenang = pemenangList.firstWhere((element) => element.idPeserta == oldId && element.namaPeserta == oldNama);
                  tempPemenang.idPeserta = nikController.text;
                  tempPemenang.namaPeserta = namaController.text;

                  updatePemenangSharedPreferences(pemenangList);
                }
                
                Navigator.of(context).pop();
                Flushbar(
                  backgroundColor: Colors.green,
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  title: "Success!",
                  message: "Data berhasil diubah",
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

  AlertDialog showAddDialog() {
    var namaController = TextEditingController();
    var nikController = TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const SizedBox(
        height: 25,
        child: Text("Tambah Data", textAlign: TextAlign.center,),
      ),
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(
              height: 15,
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
        }
        else {
          //if data already exist, notify user using snackbar from flushbar
          if(pesertaList.any((element) => element.idPeserta == nikController.text)){
            Navigator.of(context).pop();
            Flushbar(
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              title: "Warning!",
              message: "NIK sudah ada",
              duration: const Duration(seconds: 2),
            ).show(context);
          }
          //NIK must be numeric
          else if(nikController.text.contains(RegExp(r'[a-zA-Z]'))){
            Navigator.of(context).pop();
            Flushbar(
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              title: "Warning!",
              message: "NIK harus berupa angka",
              duration: const Duration(seconds: 2),
            ).show(context);
          }
          else{
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
    pesertaList.addAll(listPeserta);
    List<Map<String, dynamic>> jsonList = pesertaList.map((obj) => obj.toJson()).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("PesertaList", jsonList.map((e) => jsonEncode(e)).toList());
  }

  Future<void> updateSharedPreferences(List<NamaPeserta> listPeserta) async {
    pesertaList = listPeserta;
    List<Map<String, dynamic>> jsonList = pesertaList.map((obj) => obj.toJson()).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("PesertaList", jsonList.map((e) => jsonEncode(e)).toList());
  }

  Future<void> updatePemenangSharedPreferences(List<NamaPeserta> listPeserta) async {
    pemenangList = listPeserta;
    List<Map<String, dynamic>> jsonList = pemenangList.map((obj) => obj.toJson()).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("PemenangList", jsonList.map((e) => jsonEncode(e)).toList());
  }

  void loadData() async {
    pesertaList = await loadSharedPreferences();
    pemenangList = await loadPemenangSharedPreferences();
    for (var element in pesertaList) {
      pesertaBloc.add(LoadPeserta(element.idPeserta, element.namaPeserta));
    }

    for (var element in pemenangList) {
      pesertaBloc.add(LoadPemenang(element.idPeserta, element.namaPeserta));
    }
    pesertaBloc.add(ShowPemenang());
    pesertaBloc.add(ShowPeserta());
  }

  Future<List<NamaPeserta>> loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList("PesertaList") ?? [];
    return jsonList.map((e) => NamaPeserta.fromJson(jsonDecode(e))).toList();
  }

  Future<List<NamaPeserta>> loadPemenangSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList("PemenangList") ?? [];
    return jsonList.map((e) => NamaPeserta.fromJson(jsonDecode(e))).toList();
  }


}

