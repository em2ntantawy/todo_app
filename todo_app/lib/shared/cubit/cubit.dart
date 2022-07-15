// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/done_tasks/done_tasks.dart';
import 'package:todo_app/modules/new_tasks/new_tasks.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/archived_tasks/archived_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    newTasks(),
    doneTasks(),
    archivedTasks(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void ChangeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  Database database;
  List<Map> NewTasks = [];
  List<Map> DoneTasks = [];
  List<Map> ArchivedTasks = [];

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  Future<void> createDatabase() async {
    String dbPath = await getDatabasesPath();
    String Path = join(dbPath, 'Todo.db');
    openDatabase(
      //'Todo.db',
      Path,
      version: 1,
      onCreate: (database, version) async {
        print('database created');
        await database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT, date TEXT,time TEXT,status TEXT)')
            .then((value) {
          print('Table created');
        }).catchError((error) {
          print('error when create table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    database?.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks (title , date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error when Inserting ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) async {
    NewTasks = [];
    DoneTasks = [];
    ArchivedTasks = [];
    emit(AppLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      print(value);
      value.forEach((element) {
        if (element['status'] == 'new') {
          NewTasks.add(element);
        } else if (element['status'] == 'done') {
          DoneTasks.add(element);
          print(DoneTasks);
        } else {
          ArchivedTasks.add(element);
          print(ArchivedTasks);
        }
      });
      emit(AppGetDatabaseState());
    });
    // ignore: dead_code
    // print(tasks[0]);
  }

  void UpdateData({
    @required String status,
    @required int id,
  }) {
    emit(AppLoadingState());

    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', '$id']).then((value) {
      emit(AppUpdateDatabaseState());
      getDataFromDatabase(database);
    });
  }

  void DeleteData({
    @required int id,
  }) {
    //emit(AppLoadingState());

    database.rawDelete('DELETE FROM tasks WHERE id = ?', ['$id']).then((value) {
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database);
    });
  }

  void ChangeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
