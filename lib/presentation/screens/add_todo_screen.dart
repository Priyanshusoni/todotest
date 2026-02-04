import 'dart:io';

import 'package:todo/core/utils/utils.dart';
import 'package:todo/domain/models/todo_model.dart';
import 'package:todo/presentation/widgets/input_field.dart';
import 'package:todo/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/presentation/theme/theme_helper.dart';

class AddTodoScreen extends ConsumerStatefulWidget {
  final TodoModel? todo;
  const AddTodoScreen({super.key, this.todo});

  @override
  ConsumerState<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends ConsumerState<AddTodoScreen> {
  final formKey = GlobalKey<FormState>();

  String todoDescription = '';
  bool isCompleted = false;

  bool get isEdit => widget.todo != null;

  @override
  void initState() {
    if (isEdit) {
      todoDescription = widget.todo!.todo;
      isCompleted = widget.todo!.completed;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
        titleSpacing: 0,
      ),
      bottomNavigationBar: Padding(
        padding: all12.copyWith(bottom: Platform.isIOS ? 20 : 16),
        child: FilledButton(
          onPressed: onPressed,
          child: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: all12,
          children: [
            InputField(
              initialValue: todoDescription,
              title: 'Todo',
              hintText: 'Write your todo here',
              validator: (String? value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter todo';
                }
                return null;
              },
              onChanged: (value) => todoDescription = value,
            ),
            vSpace16,
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Completed'),
              value: isCompleted,
              onChanged: (value) {
                setState(() {
                  isCompleted = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void onPressed() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    showLoader(context);
    final res = isEdit
        ? await ref
              .read(dataProvider)
              .updateTodo(
                id: widget.todo!.id,
                todo: todoDescription,
                completed: isCompleted,
              )
        : await ref
              .read(dataProvider)
              .addTodo(todo: todoDescription, completed: isCompleted);
    if (mounted) {
      Navigator.pop(context);
      if (res) Navigator.pop(context, true);
    }
  }
}
