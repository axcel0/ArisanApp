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
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            backgroundColor: Colors.white38,
            accentColor: Colors.white12,
            cardColor: Colors.blueGrey.shade50,
            errorColor: Colors.red,
          ),
          primaryTextTheme: const TextTheme(
            titleLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black),
            bodyLarge: TextStyle(color: Colors.black),
            titleMedium: TextStyle(color: Colors.blue),
            titleSmall: TextStyle(color: Colors.black),
            bodySmall: TextStyle(color: Colors.black),
            labelLarge: TextStyle(color: Colors.black),
            labelSmall: TextStyle(color: Colors.black),
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          //use google font as theme
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
          //use color scheme of material theme
          colorScheme: ColorScheme.fromSwatch(
            brightness: Brightness.dark,
            primarySwatch: Colors.indigo,
            backgroundColor: Colors.black87,
            accentColor: Colors.white12,
            cardColor: Colors.white10,
            errorColor: Colors.red,
          ),
          primaryTextTheme: const TextTheme(
            titleLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            bodyLarge: TextStyle(color: Colors.white),
            titleMedium: TextStyle(color: Colors.white),
            titleSmall: TextStyle(color: Colors.white),
            bodySmall: TextStyle(color: Colors.white),
            labelLarge: TextStyle(color: Colors.white),
            labelSmall: TextStyle(color: Colors.white),
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.light,
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
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.people_alt_rounded, size: 75, color: Colors.blueAccent,),
                    ),//add text with primary color same as foreground color
                    Text("Data Peserta",
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).primaryTextTheme.titleMedium!.color,
                    ), textAlign: TextAlign.center,),
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
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.workspace_premium_rounded, size: 75, color: Colors.amber,),
                    ),
                    Text("Data Pemenang",
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).primaryTextTheme.titleMedium!.color,
                    ), textAlign: TextAlign.center,),
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
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) =>  DataKocok()));
                },
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.shuffle_rounded, size: 75, color: Colors.teal,),
                    ),
                    Text("Kocok",
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).primaryTextTheme.titleMedium!.color,
                    ), textAlign: TextAlign.center,),
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
