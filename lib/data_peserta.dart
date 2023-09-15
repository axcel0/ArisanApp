import 'dart:js';

import 'package:flutter/material.dart';
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
  List<NamaPeserta> daftarNamaPeserta = [
    NamaPeserta(idPeserta: "0", namaPeserta: "a"),
    NamaPeserta(idPeserta: "1", namaPeserta: "b"),
    NamaPeserta(idPeserta: "2", namaPeserta: "c"),
    NamaPeserta(idPeserta: "3", namaPeserta: "d"),
  ];


  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Demo'),
        //add theme to this appbar
        backgroundColor: Theme.of(context).colorScheme.primary,

      ),
      body: ListView.builder(
        itemCount: daftarNamaPeserta.length,
        itemBuilder: (context, index)
          {

        return Card(
          child: ListTile(
            title: Text(daftarNamaPeserta[index].namaPeserta),
            subtitle: Text(daftarNamaPeserta[index].idPeserta),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
              ],
            ),
          ),
        );
      }),
      //add floatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => showAddDialog(context));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  AlertDialog showAddDialog(BuildContext context) {
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
            decoration: InputDecoration(
              hintText: "Masukkan Nama",
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text("NIK"),
          ),
           TextField(
            controller: nikController,
            decoration: InputDecoration(
              hintText: "Masukkan NIK",

            ),
          ),

        ],
      ),
      actions: [
        ElevatedButton(onPressed: () {
          daftarNamaPeserta.add(NamaPeserta(idPeserta: nikController.text, namaPeserta: namaController.text));
          setState(() {});
          Navigator.of(context).pop();
        }, child: const Text("Tambah")),

      ],
    );
  }
}

