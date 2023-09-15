import 'package:flutter/material.dart';
import 'package:tugas_akhir_training/nama_peserta.dart';

class DataPemenang extends StatelessWidget {
  DataPemenang({super.key});

  List<NamaPeserta> daftarNamaMenang = [
    NamaPeserta(idPeserta: "0", namaPeserta: "a"),
    NamaPeserta(idPeserta: "1", namaPeserta: "b"),
    NamaPeserta(idPeserta: "2", namaPeserta: "c"),
    NamaPeserta(idPeserta: "3", namaPeserta: "d"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemenang Arisan'),
        //add theme to this appbar
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
        itemCount: daftarNamaMenang.length,
        itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(daftarNamaMenang[index].namaPeserta),
            subtitle: Text(daftarNamaMenang[index].idPeserta),
          ),
        );
      }),
    );
  }
}
