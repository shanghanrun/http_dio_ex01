import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_dio_ex01/model/todos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Provider example',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Todos> todoList = [];

  @override
  void initState() {
    super.initState();
    getTodoList().then((list) {
      setState(() {
        todoList = list.map((json) => Todos.fromJson(json)).toList();
      });
    });
  }

  Future<List<dynamic>> getTodoList() async {
    final dio = Dio();
    final res = await dio.get('https://jsonplaceholder.typicode.com/todos');

    return res.data; // List<dynamic> 형태 => List<Map<String,dynamic>> 일 경우 많다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dio Test')),
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, i) {
            final item = todoList[i];
            return ListTile(
              title: Text('#${item.id}'),
              subtitle: Text(item.title),
              trailing: Checkbox(
                  value: item.completed,
                  onChanged: (bool? value) {
                    setState(() {
                      item.completed = value ?? false;
                      // 새로운 값이 null이면 기본값은 false
                    });
                  }),
            );
          }),
    );
  }
}
