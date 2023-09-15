import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/peserta_bloc.dart';

class DataKocok extends StatefulWidget {
  const DataKocok({super.key});

  @override
  State<DataKocok> createState() => _DataKocokState();
}

class _DataKocokState extends State<DataKocok> {

  bool kocokPemenang = false;
  late PesertaBloc pesertaBloc;

  Stream<String> mulaiAcak() async* {
    await Future.delayed(Duration(seconds: 5));
    yield "Hore Hore Hore!";
  }
  @override
  void initState() {
    // TODO: implement initState
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
            child: Text("Mulai Kocok"),
          ),
        );
      }
      case true : {
        return BlocBuilder<PesertaBloc, PesertaState>(
          builder: (context, state) {
            return StreamBuilder<String>(
              stream: mulaiAcak(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  return Center(child: Text(snapshot.data.toString()));
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error!"));
                }

                return Container();
              }
            );
          },
        );
      }
    }
  }

}
