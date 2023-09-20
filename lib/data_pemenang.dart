import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir_training/blocs/peserta_bloc.dart';
import 'package:tugas_akhir_training/nama_peserta.dart';

class DataPemenang extends StatefulWidget {
  const DataPemenang({super.key});

  @override
  State<DataPemenang> createState() => _DataPemenangState();
}

class _DataPemenangState extends State<DataPemenang> {
  late PesertaBloc pesertaBloc;
  List<NamaPeserta> pemenangList = [];

  // List<NamaPeserta> daftarNamaMenang = [
  //   NamaPeserta(idPeserta: "0", namaPeserta: "a"),
  //   NamaPeserta(idPeserta: "1", namaPeserta: "b"),
  //   NamaPeserta(idPeserta: "2", namaPeserta: "c"),
  //   NamaPeserta(idPeserta: "3", namaPeserta: "d"),
  // ];

  // String _name = "";

  // static String KEY_MY_STRING = "my_string";
  // Future<String> getStringPreferences() async {
  //   final preferences = await SharedPreferences.getInstance();
  //   return preferences.getString(KEY_MY_STRING) ?? "";
  // }

  @override
  void initState() {
    super.initState();
    // initData();
    pesertaBloc = BlocProvider.of<PesertaBloc>(context);
    pesertaBloc.add(DeleteAllPemenang());
    loadData();
    // pesertaBloc.add(ShowPemenang());
  }

  // void initData() async {
  //   _name = await getStringPreferences();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Pemenang Arisan'),
      ),
      body: BlocBuilder<PesertaBloc, PesertaState>(
        builder: (context, state) {
          if (state is ListPemenangInitial && state.listPemenang.isNotEmpty) {
            return ListView.builder(
              itemCount: state.listPemenang.length,
              itemBuilder:(context, index) {
                return Card(
                  child: ListTile(
                    title: Text(state.listPemenang[index].namaPeserta),
                    subtitle: Text(state.listPemenang[index].idPeserta),
                  )
                );
              }
            );
          }else{
            return const Center(
              child: Text("Belum ada pemenang, silahkan kocok terlebih dahulu"),
            );
          }
        }),
    );
  }

  void loadData() async {
    pemenangList = await loadSharedPreferences();
    for (var element in pemenangList) {
      pesertaBloc.add(LoadPemenang(element.idPeserta, element.namaPeserta));
    }

    pesertaBloc.add(ShowPemenang());
  }

  Future<List<NamaPeserta>> loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList("PemenangList") ?? [];
    return jsonList.map((e) => NamaPeserta.fromJson(jsonDecode(e))).toList();
  }
}
