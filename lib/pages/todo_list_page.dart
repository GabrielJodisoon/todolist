import 'package:flutter/material.dart';
import 'package:todo_list/repositories/todo_repository.dart';

import '../models/todo.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> todos = [];
  Todo? deleteTodo;
  int? deleteTodoPos;
  String? errorText;

  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  @override
  void initState(){
    super.initState();
    
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Lista de Tarefas')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma Tarefa',
                          hintText: 'Ex: Estudar Flutter',
                          errorText: errorText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;
                        if(text.isEmpty){
                          setState(() {
                            errorText = 'Informe uma tarefa';

                          });
                          return;
                        }
                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );

                          todos.add(newTodo);
                          errorText = null;
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: const EdgeInsets.all(13),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'voce possui ${todos.length} task pendetes',
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ElevatedButton(
                        onPressed: showDeleteAllConfirmation,
                        child: Text("Limpar tudo"))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Limpar Tudo?'),
            content: Text(
                'Voce tem certeza que deseja remover todas as tarefas?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(primary: Colors.grey),
                child: Text(
                  'Cancelar',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteAllTodos();
                },
                style: TextButton.styleFrom(primary: Colors.red),
                child: Text(
                  'Limpar',
                ),
              )
            ],
          ),
    );
  }


  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);

  }

  void onDelete(Todo todo) {
    deleteTodo = todo;
    deleteTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} removida com sucesso!',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
            label: 'Desfazer',
            textColor: Colors.blue,
            onPressed: () {
              setState(() {
                todos.insert(deleteTodoPos!, deleteTodo!);
              });
              todoRepository.saveTodoList(todos);

            }),
        duration: Duration(seconds: 4),
      ),
    );
  }
}
