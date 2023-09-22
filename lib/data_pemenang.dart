import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir_training/blocs/peserta_bloc.dart';
import 'package:tugas_akhir_training/nama_peserta.dart';

import 'cubit/theme_mode_cubit.dart';

class DataPemenang extends StatefulWidget {
  const DataPemenang({super.key});

  @override
  State<DataPemenang> createState() => _DataPemenangState();
}

class _DataPemenangState extends State<DataPemenang> {
  late PesertaBloc pesertaBloc;
  List<NamaPeserta> pemenangList = [];

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
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeModeCubit>().toggleBrightness();
            },
            icon: BlocBuilder<ThemeModeCubit, ThemeMode>(
              builder: (context, state) {
                return state == ThemeMode.light ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode);
              },
            ),
          ),
        ],
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Winner List'),
      ),
      body: BlocBuilder<PesertaBloc, PesertaState>(
        builder: (context, state) {
          if (state is ListPemenangInitial && state.listPemenang.isNotEmpty) {
            return ListView.builder(
              itemCount: state.listPemenang.length,
              itemBuilder:(context, index) {
                return Card(
                  child: ListTile(
                    title: Text(state.listPemenang[index].namaPeserta,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.orange : Colors.amber,
                        )
                    ),
                    subtitle: Text(state.listPemenang[index].idPeserta,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.orange : Colors.amber,
                        )
                    ),
                    //show time stamp using trailing widget
                    // trailing: Text(state.listPemenang[index].timeStamp),
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
