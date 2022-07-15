import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:path/path.dart';

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      direction: DismissDirection.endToStart,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 70.0,
              height: 40.0,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        Color.fromARGB(255, 98, 92, 212),
                        Color.fromARGB(255, 243, 159, 211)
                      ]),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Center(
                  child: Text(
                '${model['time']}',
                style: TextStyle(color: Colors.white),
              )),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).UpdateData(
                    status: 'done',
                    id: model['id'],
                  );
                },
                icon: Icon(
                  Icons.check_box,
                  color: Color.fromARGB(255, 61, 114, 62),
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).UpdateData(
                    status: 'archive',
                    id: model['id'],
                  );
                },
                icon: Icon(
                  Icons.archive,
                  color: Color.fromARGB(255, 154, 162, 67),
                ))
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).DeleteData(id: model['id']);
      },
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete Confirmation"),
              content: const Text("Are you sure you want to delete this item?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Delete")),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
      background: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.delete, color: Colors.white),
              Text('Move to trash', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );

Widget taskBuilder(
  @required List<Map> task,
) =>
    ConditionalBuilder(
      condition: task.length > 0,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) {
            print('task status  ${task[index]['status']}');
            return buildTaskItem(task[index], context);
          },
          separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: .2,
                color: Colors.purple[100],
              ),
          itemCount: task.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/1.jpg'),
            // Icon(
            //   Icons.menu,
            //   size: 100,
            //   color: Colors.grey,
            // ),
            Text(
              'No Tasks yet, Please Add Some Tasks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
