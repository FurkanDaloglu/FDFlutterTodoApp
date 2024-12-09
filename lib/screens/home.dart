import 'package:fd_flutter_todo_app/constants/color.dart';
import 'package:fd_flutter_todo_app/constants/tasktype.dart';
import 'package:fd_flutter_todo_app/model/task.dart';
import 'package:fd_flutter_todo_app/model/todo.dart';
import 'package:fd_flutter_todo_app/screens/add_new_task.dart';
import 'package:fd_flutter_todo_app/service/todo_service.dart';
import 'package:fd_flutter_todo_app/todoitem.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<String> todo = ["Study Lessons", "Run 5K", "Go to Party"];
  // List<String> completed = ["Game meetup", "Take out tash"];

  List<Task> todo = [
    Task(
      type: TaskType.note,
      title: "Study Lessons",
      description: "Study Comp117",
      isCompleted: false,
    ),
    Task(
      type: TaskType.calender,
      title: "Go to Party",
      description: "Attend to party",
      isCompleted: false,
    ),
    Task(
      type: TaskType.contest,
      title: "Run 5K",
      description: "Run 5 kilometers",
      isCompleted: false,
    ),
  ];
  List<Task> completed = [
    Task(
      type: TaskType.calender,
      title: "Go to Party",
      description: "Attend to party",
      isCompleted: false,
    ),
    Task(
      type: TaskType.contest,
      title: "Run 5K",
      description: "Run 5 kilometers",
      isCompleted: false,
    ),
  ];

  void addNewTask(Task newTask) {
    setState(() {
      todo.add(newTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    TodoService todoService = TodoService();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            backgroundColor: HexColor(backgroundColor),
            body: Column(
              children: [
                //header
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("lib/assets/images/header.png"),
                          fit: BoxFit.cover)),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "October 2024",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          "My Todo List",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                //Top column
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: SingleChildScrollView(
                      child: FutureBuilder(
                        future: todoService.getUncompletedTodos(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Todo>> snapshot) {
                          print(snapshot.data);
                          if (snapshot.data == null) {
                            return const CircularProgressIndicator(); //loading iconu
                          } else {
                            return ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return TodoItem(
                                  task: snapshot.data![index],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                //completed text
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Completed",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                //Bottom Column
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: SingleChildScrollView(
                      child: FutureBuilder(
                        future: todoService.getCompletedTodos(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Todo>> snapshot) {
                          print(snapshot.data);
                          if (snapshot.data == null) {
                            return const CircularProgressIndicator(); //loading iconu
                          } else {
                            return ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return TodoItem(
                                  task: snapshot.data![index],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddNewTaskScreen(
                          addNewTask: (newTask) => addNewTask(newTask),
                        ),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Arka plan rengi
                      foregroundColor: Colors.white, // Yazı rengi
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 25.0),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text("Add New Task"),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
