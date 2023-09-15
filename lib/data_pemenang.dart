import 'package:flutter/material.dart';
class DataPemenang extends StatelessWidget {
  const DataPemenang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Demo'),
        //add theme to this appbar
        backgroundColor: Theme.of(context).colorScheme.primary,

      ),
      body: const Center(),
    );
  }
}
