import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tugas_akhir_training/blocs/peserta_bloc.dart';
import 'cubit/theme_mode_cubit.dart';
import 'data_kocok.dart';
import 'data_pemenang.dart';
import 'data_peserta.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory()
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PesertaBloc>(
          create: (context) => PesertaBloc(),
        ),
        BlocProvider(
          create: (context) => ThemeModeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeMode>(
          builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(
              //use google font as theme
              textTheme: GoogleFonts.latoTextTheme(
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
                titleMedium: TextStyle(color: Colors.black87),
                titleSmall: TextStyle(color: Colors.black),
                bodySmall: TextStyle(color: Colors.black),
                labelLarge: TextStyle(color: Colors.black),
                labelSmall: TextStyle(color: Colors.black),
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              //use google font as theme
              textTheme: GoogleFonts.latoTextTheme(
                Theme.of(context).textTheme,
              ),
              //use color scheme of material theme
              colorScheme: ColorScheme.fromSwatch(
                brightness: Brightness.dark,
                primarySwatch: Colors.indigo,
                backgroundColor: Colors.black87,
                accentColor: Colors.white12,
                cardColor: Colors.blueGrey.shade900,
                errorColor: Colors.red,
              ),
              primaryTextTheme: const TextTheme(
                titleLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white),
                bodyLarge: TextStyle(color: Colors.white),
                titleMedium: TextStyle(color: Colors.white70),
                titleSmall: TextStyle(color: Colors.white),
                bodySmall: TextStyle(color: Colors.white),
                labelLarge: TextStyle(color: Colors.white),
                labelSmall: TextStyle(color: Colors.white),
              ),
              useMaterial3: true,
            ),
            themeMode: state,
            title: 'Arisan Software',
            home: const MyHomePage(title: 'Arisan Software'),
            debugShowCheckedModeBanner: false,
          );
        },
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
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.people_alt_rounded, size: 75, color: Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.blueAccent : Colors.indigo,),
                    ),//add text with primary color same as foreground color
                    Text("Participant",
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
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const DataPemenang()));
                },
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.workspace_premium_rounded, size: 75, color: Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.amber : Colors.orange,),
                    ),
                    Text("Winner",
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
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.shuffle_rounded, size: 75, color: Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.blue : Colors.teal,),
                    ),
                    Text("Shuffle",
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
