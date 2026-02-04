import 'dart:io';

import 'package:todo/core/routes.dart';
import 'package:todo/data/database/databse_helper.dart';
import 'package:todo/domain/models/todo_model.dart';
import 'package:todo/presentation/widgets/loader.dart';
import 'package:todo/presentation/widgets/no_data_found.dart';
import 'package:todo/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/utils/extension.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/presentation/theme/app_theme.dart';
import 'package:todo/presentation/theme/text_theme.dart';
import 'package:todo/presentation/theme/theme_helper.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isLoading = true;
  bool isFetching = false;

  @override
  void initState() {
    // ref.read(dataProvider).getTodoList();
    getData();
    super.initState();
  }

  Future<void> getData() async {
    await ref.read(dataProvider).getTodoList();
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  void loadMore() async {
    if (isFetching) {
      return;
    }
    isFetching = true;
    await ref.read(dataProvider).getMoreTodoList();
    isFetching = false;
  }

  // @override
  // void dispose() {
  //   DatabaseHelper().closeDb();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Todo')),
      bottomNavigationBar: Padding(
        padding: all12.copyWith(bottom: Platform.isIOS ? 20 : 16),
        child: FilledButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.addTodo);
          },
          child: Text('Add Todo', style: AppTextTheme.body),
        ),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final todos = ref.watch(dataProvider.select((value) => value.todos));
    if (isLoading) {
      return const Loader();
    }
    if (todos.data.isEmpty) {
      return RefreshIndicator(onRefresh: getData, child: const NoDataFound());
    }
    return RefreshIndicator(
      onRefresh: getData,
      child: NotificationListener(
        onNotification: (notification) {
          return onScrollNotification(notification, loadMore);
        },
        child: ListView.separated(
          padding: all12,
          itemCount: todos.data.length,
          separatorBuilder: (ctx, i) => vSpace12,
          itemBuilder: (ctx, i) => buildListTile(todos.data[i]),
        ),
      ),
    );
  }

  Widget buildListTile(TodoModel todo) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.addTodo, arguments: {'todo': todo});
      },
      child: Container(
        padding: symmetricH16,
        decoration: basicShadowDecoradtion,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.calendar_today_rounded),
              contentPadding: EdgeInsets.zero,
              title: Text(todo.todo),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: all4.add(symmetricH4),
                    decoration: BoxDecoration(
                      color: todo.completed
                          ? AppTheme.greenColor
                          : AppTheme.redColor,
                      borderRadius: circular12,
                    ),
                    child: Text(
                      todo.completed ? 'Completed' : 'Pending',
                      style: AppTextTheme.white.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => onDelete(todo.id),
                    color: AppTheme.redColor,
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDelete(int id) async {
    final shouldDelete = await showConfirmationDialog(
      title: 'Delete Todo',
      subTitle: 'Are you sure you want to delete this todo?',
      context: context,
    );

    if (shouldDelete ?? false) {
      if (mounted) {
        showLoader(context);
      }
      final dataProv = ref.read(dataProvider);
      await dataProv.deleteTodo(id: id);
      if (mounted) {
        Navigator.pop(context); // Close loader
      }
    }
  }
}
