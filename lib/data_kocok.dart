import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir_training/data_pemenang.dart';

import 'blocs/peserta_bloc.dart';

class DataKocok extends StatefulWidget {
  const DataKocok({super.key});

  @override
  State<DataKocok> createState() => _DataKocokState();
}

class _DataKocokState extends State<DataKocok> {

  bool kocokPemenang = false;
  late PesertaBloc pesertaBloc;

  Stream<String> mulaiAcak(String id, String nama) async* {
    await Future.delayed(const Duration(seconds: 2));
    yield "Selamat kepada $nama, dengan Id $id";
  }
  @override
  void initState() {
    super.initState();
    pesertaBloc = BlocProvider.of<PesertaBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Demo'),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
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
                pesertaBloc.add(AddNewPemenang());
                kocokPemenang = true;
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
                      return Center(child: Text(snapshot.data.toString()));
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

}
