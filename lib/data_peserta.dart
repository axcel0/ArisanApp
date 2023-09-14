import 'package:flutter/material.dart';

class DataPeserta extends StatelessWidget {
  const DataPeserta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Demo'),
        //add theme to this appbar
        backgroundColor: Theme.of(context).colorScheme.primary,

      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.end,

        children: [
          Padding(
            padding: const EdgeInsets.all(10),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    showDialog(context: context, builder: (BuildContext context) => showAddDialog());
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AlertDialog showAddDialog() {
    return AlertDialog(
      title: const Text("Tambah Data"),
      content: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text("Nama"),
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: "Masukkan Nama",
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text("NIK"),
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: "Masukkan NIK",
            ),
          ),

        ],
      ),
      actions: [
        ElevatedButton(onPressed: (

            ) {}, child: const Text("Tambah")),

      ],
    );
  }
}
