import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    Key? key,
    required this.todo,
    required this.onDelete,
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey[200],
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MMM/yy - EE').format(todo.dateTime),
                style: TextStyle(fontSize: 12),
              ),
              Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              onPressed: doNothing,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'edit',
            ),
            SlidableAction(
              onPressed: doNothing,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              label: 'delete',
            ),
          ],
        ),
    )

    // child: Slidable(
    //   child:  ,
    //   actionExtentRatio: 0.25,
    //   actionPane: const SlidableDrawerActionPane(),
    //   secondaryActions: [
    //     IconSlideAction(
    //       color: Colors.red,
    //       icon: Icons.delete_outline,
    //       caption: 'Deletar',
    //       onTap: () {
    //         onDelete(todo);
    //       },
    //     ),
    //   ],
    // ),

    );  // );
  }
  void doNothing(BuildContext context) {
    onDelete(todo);
  }
}



