import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_planner/src/providers/task_form_dialog_provider.dart';
import 'package:task_planner/src/screens/components/dialogs/add_task_dialog.dart';
import 'package:task_planner/src/screens/components/tasks/task_stats.dart';
import 'package:task_planner/src/screens/daily_screen.dart';
import 'package:task_planner/src/screens/monthly_screen.dart';
import 'package:task_planner/src/screens/weekly_screen.dart';

import '../providers/task_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizador Pessoal'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Diário'),
            Tab(text: 'Semanal'),
            Tab(text: 'Mensal'),
          ],
        ),
      ),
      body:
          taskProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TaskStats(),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        DailyScreen(),
                        WeeklyScreen(),
                        MonthlyScreen(),
                      ],
                    ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return ChangeNotifierProvider(
                create: (_) => TaskFormDialogProvider(),
                child: const AddTaskDialog(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
