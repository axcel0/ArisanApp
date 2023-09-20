import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir_training/blocs/peserta_bloc.dart';
import 'data_kocok.dart';
import 'data_pemenang.dart';
import 'data_peserta.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PesertaBloc>(
      create: (context) => PesertaBloc(),
      child: MaterialApp(
        theme: ThemeData(
          //use google font as theme
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
          //use color scheme of material theme
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
            backgroundColor: Colors.white38,
            accentColor: Colors.white12,
            cardColor: Colors.blueGrey.shade50,
            errorColor: Colors.red,
            brightness: Brightness.light,
          ),

          useMaterial3: true,
        ),
        title: 'Arisan Software',
        home: const MyHomePage(title: 'Arisan Software'),
        debugShowCheckedModeBanner: false,
    ),
);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _name = "";

  static String KEY_MY_STRING = "my_string";
  Future<void> saveStringPreferences(String lastString) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(KEY_MY_STRING, lastString);
  }
  Future<String> getStringPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(KEY_MY_STRING) ?? "";
  }
  //override initState
  @override
  void initState() {
    super.initState();
    initData();
  }
  void initData() async {
    _name = await getStringPreferences();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 180,
              child: ElevatedButton(
                //change radius of button
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DataPeserta()));
                },
                child: const Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.people_alt_rounded, size: 75, color: Colors.orange,),
                    ),
                    Text("Data Peserta", style: TextStyle(fontSize: 15, ), textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 150,
              height: 180,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => DataPemenang()));
                },
                child: const Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.workspace_premium_rounded, size: 75, color: Colors.yellow,),
                    ),
                    Text("Data Pemenang", style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 150,
              height: 180,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const DataKocok()));
                },
                child: const Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.shuffle_rounded, size: 75, color: Colors.deepPurple,),
                    ),
                    Text("Kocok", style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
