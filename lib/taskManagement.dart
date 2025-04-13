import 'package:flutter/material.dart';
import 'dart:async';
import 'success.dart';
import 'failure.dart';
import 'final.dart';
import 'archive.dart';

class Task {
  String name;
  int timeInSeconds;
  bool isCompleted;
  bool isPostponed;
  DateTime createdAt;
  int remainingTime;

  Task({
    required this.name,
    required this.timeInSeconds,
    this.isCompleted = false,
    this.isPostponed = false,
    required this.createdAt,
    this.remainingTime = 0,
  });
}

List<Task> globalTasks = [];
List<Task> archivedTasks = [];

class TaskManagementPage extends StatefulWidget {
  const TaskManagementPage({super.key});

  @override
  _TaskManagementPageState createState() => _TaskManagementPageState();
}

class _TaskManagementPageState extends State<TaskManagementPage> {
  List<Task> tasks = [];
  int _remainingTime = 0;
  bool _taskInProgress = false;
  Timer? _timer;
  Task? _currentTask;

  @override
  void initState() {
    super.initState();
    tasks = globalTasks;
  }

  void _startTimer(Task task) {
    if (!mounted) return;
    setState(() {
      _taskInProgress = true;
      _currentTask = task;
      _remainingTime =
          task.remainingTime > 0 ? task.remainingTime : task.timeInSeconds;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          task.remainingTime = _remainingTime;
        } else {
          _timer?.cancel();
          _taskInProgress = false;
          _showTaskCompletionDialog();
        }
      });
    });
  }

  void _cancelTask() {
    if (_currentTask != null) {
      _currentTask!.remainingTime = _remainingTime;
    }
    _timer?.cancel();
    if (mounted) {
      setState(() {
        _taskInProgress = false;
        _currentTask = null;
      });
    }
  }

  void _extendTime() {
    if (_currentTask != null && mounted) {
      setState(() {
        _remainingTime += (_remainingTime ~/ 3);
        _currentTask!.timeInSeconds = _remainingTime;
      });
      _startTimer(_currentTask!);
    }
  }

  void _postponeTask() {
    if (_currentTask != null && mounted) {
      setState(() {
        _currentTask!.isPostponed = true;
        _taskInProgress = false;
        _currentTask = null;
      });
    }
  }

  void _showTaskCompletionDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Did you complete the task?'),
            content: Text('Did you finish the task successfully?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (mounted) {
                    setState(() {
                      _currentTask?.isCompleted = true;
                    });
                  }
                  if (tasks.every((task) => task.isCompleted)) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => FinalPage()),
                    );
                  } else if (tasks
                      .any((task) => !task.isCompleted && !task.isPostponed)) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskManagementPage()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SuccessPage()),
                    );
                  }
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (mounted) {
                    setState(() {
                      _currentTask?.isPostponed = true;
                    });
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FailurePage(
                        onExtendTime: _extendTime,
                        onPostponeTask: _postponeTask,
                        currentTask: _currentTask!,
                      ),
                    ),
                  );
                },
                child: Text('No'),
              ),
            ],
          );
        },
      );
    });
  }

  void _showAddTaskDialog() {
    final taskNameController = TextEditingController();
    final taskMinutesController = TextEditingController();
    final taskSecondsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskNameController,
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.deepPurple[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextField(
                controller: taskMinutesController,
                decoration: InputDecoration(
                  labelText: 'Minutes',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.deepPurple[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextField(
                controller: taskSecondsController,
                decoration: InputDecoration(
                  labelText: 'Seconds',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.deepPurple[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                if (taskNameController.text.isNotEmpty &&
                    (taskMinutesController.text.isNotEmpty ||
                        taskSecondsController.text.isNotEmpty)) {
                  final minutes = int.tryParse(taskMinutesController.text) ?? 0;
                  final seconds = int.tryParse(taskSecondsController.text) ?? 0;
                  final totalTime = minutes * 60 + seconds;

                  if (mounted) {
                    setState(() {
                      tasks.add(Task(
                        name: taskNameController.text,
                        timeInSeconds: totalTime,
                        createdAt: DateTime.now(),
                      ));
                      globalTasks = tasks;
                    });
                  }
                  Navigator.pop(context);
                }
              },
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
          backgroundColor: Colors.deepPurple[300],
        );
      },
    );
  }

  void _moveToArchive(Task task) {
    setState(() {
      tasks.remove(task);
      archivedTasks.add(task);
      globalTasks = tasks;
    });
  }

  void _editTaskTime(Task task) {
    final taskMinutesController = TextEditingController();
    final taskSecondsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskMinutesController,
                decoration: InputDecoration(
                  labelText: 'Minutes',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.deepPurple[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextField(
                controller: taskSecondsController,
                decoration: InputDecoration(
                  labelText: 'Seconds',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.deepPurple[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                if (taskMinutesController.text.isNotEmpty ||
                    taskSecondsController.text.isNotEmpty) {
                  final minutes = int.tryParse(taskMinutesController.text) ?? 0;
                  final seconds = int.tryParse(taskSecondsController.text) ?? 0;
                  final totalTime = minutes * 60 + seconds;

                  if (mounted) {
                    setState(() {
                      task.timeInSeconds = totalTime;
                      task.remainingTime = totalTime;
                    });
                  }
                  Navigator.pop(context);
                }
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
          backgroundColor: Colors.deepPurple[300],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        actions: [
          IconButton(
            icon: Icon(Icons.archive, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArchivePage(archivedTasks: archivedTasks),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _showAddTaskDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('ADD NEW TASK'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final progress = (_remainingTime / task.timeInSeconds);
                  final color = Color.lerp(Colors.red, Colors.green, progress)!;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: task.isCompleted
                        ? Colors.yellow[100]
                        : task.isPostponed
                            ? Colors.blue[100]
                            : Colors.deepPurple[300],
                    child: ListTile(
                      title: Text(
                        task.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: task.isCompleted || task.isPostponed
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Time: ${task.timeInSeconds ~/ 60} minutes ${task.timeInSeconds % 60} seconds',
                        style: TextStyle(
                          fontSize: 14,
                          color: task.isCompleted || task.isPostponed
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_currentTask == task && _taskInProgress)
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[300],
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(color),
                                strokeWidth: 5,
                              ),
                            )
                          else
                            IconButton(
                              icon: Icon(Icons.play_arrow, color: Colors.white),
                              onPressed: () {
                                if (task.isPostponed) {
                                  setState(() {
                                    task.isPostponed = false;
                                  });
                                }
                                _startTimer(task);
                              },
                            ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'archive') {
                                _moveToArchive(task);
                              } else if (value == 'edit') {
                                _editTaskTime(task);
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  value: 'archive',
                                  child: Text('Move to Archive'),
                                ),
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit Task Time'),
                                ),
                              ];
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_taskInProgress && _currentTask != null)
              Column(
                children: [
                  Text(
                    'Remaining Time: ${_remainingTime ~/ 60} minutes ${_remainingTime % 60} seconds',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
