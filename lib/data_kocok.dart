import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir_training/data_pemenang.dart';

import 'blocs/peserta_bloc.dart';
import 'nama_peserta.dart';

class DataKocok extends StatefulWidget {
  const DataKocok({super.key});

  @override
  State<DataKocok> createState() => _DataKocokState();
}

class _DataKocokState extends State<DataKocok> {

  bool kocokPemenang = false;
  late PesertaBloc pesertaBloc;
  List<NamaPeserta> listdataPeserta = [];
  List<NamaPeserta> listdataPemenang = [];

  Stream<String> mulaiAcak(String id, String nama) async* {
    await Future.delayed(const Duration(seconds: 2));
    addDataPemenang(id, nama);
    yield "Selamat kepada $nama, dengan Id $id";
  }

  @override
  void initState() {
    super.initState();
    pesertaBloc = BlocProvider.of<PesertaBloc>(context);
    pesertaBloc.add(DeleteAllPemenang());
    pesertaBloc.add(DeleteAllPeserta());
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kocok Peserta'),
        //backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: changeView(kocokPemenang),
    );
  }

  Widget changeView(bool kocokView) {
    switch (kocokView) {
      case false : {
        return Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (listdataPemenang.length < listdataPeserta.length) {
                  pesertaBloc.add(AddNewPemenang());
                  kocokPemenang = true;
                } else {
                  kocokPemenang = false;
                }
                
              });
            },
            child: const Text("Mulai Kocok"),
          ),
        );
      }
      case true : {
        return BlocBuilder<PesertaBloc, PesertaState>(
          builder: (context, state) {
            if (state is ShowPemenangInitial) {
              return StreamBuilder<String>(
                  stream: mulaiAcak(state.newIdPeserta, state.newNamaPeserta),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData) {
                      return Center(
                        child: Row(
                          children: [
                            Text(snapshot.data.toString(), style: TextStyle(fontSize: 35),),
                            Stack(
                              children: [
                                Container(
                                  color: Colors.green,

                                )
                              ],
                            )
                          ],
                        )
                        //child: Text(snapshot.data.toString())
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text("Error!"));
                    }

                    return Container();
                  }
              );
            }
            return Container();
          },
        );
      }
    }
  }

  addDataPemenang(String id, String nama) async {
    var getOldPemenang = await loadSharedPreferences();
    saveSharedPreferences(getOldPemenang, id, nama);
  }

  void loadData() async {
    listdataPemenang = await loadSharedPreferences();
    listdataPeserta = await loadPesertaSharedPreferences();
    for (var element in listdataPemenang) {
      pesertaBloc.add(LoadPemenang(element.idPeserta, element.namaPeserta));
    }

    for (var element in listdataPeserta) {
      pesertaBloc.add(LoadPeserta(element.idPeserta, element.namaPeserta));
    }

    pesertaBloc.add(ShowPemenang());
    pesertaBloc.add(ShowPeserta());
  }

  Future<List<NamaPeserta>> loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList("PemenangList") ?? [];
    return jsonList.map((e) => NamaPeserta.fromJson(jsonDecode(e))).toList();
  }

  Future<List<NamaPeserta>> loadPesertaSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList("PesertaList") ?? [];
    return jsonList.map((e) => NamaPeserta.fromJson(jsonDecode(e))).toList();
  }

  Future<void> saveSharedPreferences(List<NamaPeserta> listPemenang, String newId, String newName) async {
    listPemenang.add(NamaPeserta(idPeserta: newId, namaPeserta: newName));
    List<Map<String, dynamic>> jsonList = listPemenang.map((obj) => obj.toJson()).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("PemenangList", jsonList.map((e) => jsonEncode(e)).toList());

    print("List Pemenang");
    for (var i in listPemenang) {
      print("${i.idPeserta}, ${i.namaPeserta}");
    }
  }

  loadDataPeserta() async {
    listdataPeserta = await loadPesertaSharedPreferences();
    print("listdataPeserta : ${listdataPeserta.length}");
  }

}
