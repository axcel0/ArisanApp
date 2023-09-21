import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir_training/data_pemenang.dart';
import 'package:confetti/confetti.dart';
import 'blocs/peserta_bloc.dart';
import 'nama_peserta.dart';

class DataKocok extends StatefulWidget {
  DataKocok({super.key});
  bool isShuffling = false;
  final confetti = ConfettiController(duration: const Duration(seconds: 2));



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

    final outputPemenang = "$id, $nama";
    widget.confetti.play();
    yield outputPemenang;
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text('Kocok Peserta', style: TextStyle(color: Colors.white),),
          ),
          body: changeView(kocokPemenang),
        ),
        ConfettiWidget(
          confettiController: widget.confetti,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple,
            Colors.yellow,
            Colors.red,
          ],
          //set emission count
          numberOfParticles: 10,
          emissionFrequency: 0.05,
          maxBlastForce: 100,
          minBlastForce: 80,
        )
      ]
    );
  }

  Widget changeView(bool kocokView) {
    switch (kocokView) {
      case false : {

        return Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {

                var listdataPesertaComparison = listdataPeserta;
                listdataPesertaComparison.removeWhere((item1) => listdataPemenang.any((item2) => item1.idPeserta == item2.idPeserta && item1.namaPeserta == item2.namaPeserta));

                //if (listdataPemenang.length < listdataPeserta.length) {
                if (listdataPesertaComparison.isNotEmpty) {
                  pesertaBloc.add(AddNewPemenang());
                  kocokPemenang = true;
                } else {
                  kocokPemenang = false;
                  Flushbar(
                    backgroundColor: Colors.red,
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    title: "Warning!",
                    message: "Semua peserta sudah dapat!",
                    duration: const Duration(seconds: 2),
                  ).show(context);
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
                      final output = snapshot.data?.split(", ");
                      return Center(
                          child: SizedBox(
                            //auto height
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                const SizedBox(
                                  child: Text(
                                    "Selamat kepada", style: TextStyle(fontSize: 35), textAlign: TextAlign.right,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          output![1],
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          output[0],
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ],
                                    )
                                )
                              ],
                            ),
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
