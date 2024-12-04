import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_album/bloc.dart';
import 'package:infinite_album/ui_Screen.dart';
import 'database_helper.dart';
import 'api_service.dart';

void main() async {
  // Ensure WidgetsFlutterBinding is initialized for database initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the local database
  await DatabaseHelper.instance.database;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Provide the AlbumBloc and PhotoBloc at the top of the widget tree
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AlbumBloc(ApiService(), DatabaseHelper.instance),
        ),
        BlocProvider(
          create: (context) => PhotoBloc(ApiService(), DatabaseHelper.instance),
        ),
      ],
      child: MaterialApp(
        title: 'Albums and Photos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AlbumScreen(),
      ),
    );
  }
}
