import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final tasksProbider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(tasks: [
    const Task(id: 1, label: 'Load rocket with supplies'),
    const Task(id: 2, label: 'Circle the home planet'),
    const Task(id: 3, label: 'Launch Rocket'),
    const Task(id: 4, label: 'head out to the first moon'),
    const Task(id: 5, label: 'Launch moon lander #1'),
  ]);
});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exploration!',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Space Exploration Planner!')),
      body: Column(children: const [Progress(), TaskList()]),
    );
  }
}

class Progress extends ConsumerWidget {
  const Progress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(tasksProbider);

    var numCompletedTasks = tasks.where((task) {
      return task.completed == true;
    }).length;

    return Column(
      children: [
        const SizedBox(height: 20, width: 70),
        const Text("you are this far awau from exploring the whole universe"),
        const SizedBox(height: 20, width: 70),
        LinearProgressIndicator(value: numCompletedTasks / tasks.length),
      ],
    );
  }
}

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(tasksProbider);

    return Column(
      children: tasks.map((task) => TaskItem(task: task)).toList(),
    );
  }
}

class TaskItem extends ConsumerWidget {
  final Task task;
  const TaskItem({super.key, required this.task});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  var task = ref.watch(tasksProbider);

    return Row(
      children: [
        Checkbox(
          value: task.completed,
          onChanged: (newValue) =>
              ref.read(tasksProbider.notifier).toggle(task.id),
        ),
        Text(task.label),
      ],
    );
  }
}

@immutable
class Task {
  final int id;
  final String label;
  final bool completed;

  const Task({required this.id, required this.label, this.completed = false});
  Task copyWith({int? id, String? label, bool? completed}) {
    return Task(
        id: id ?? this.id,
        label: label ?? this.label,
        completed: completed ?? this.completed);
  }
}

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier({tasks}) : super(tasks);
  void add(Task task) {
    state = [...state, task];
  }

  void toggle(int taskId) {
    state = [
      for (final item in state)
        if (taskId == item.id)
          item.copyWith(completed: !item.completed)
        else
          item
    ];
  }
}
