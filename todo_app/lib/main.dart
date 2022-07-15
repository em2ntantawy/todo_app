import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:todo_app/layout/home_screen.dart';
import 'package:todo_app/shared/bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      runApp(MyApp());

      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
