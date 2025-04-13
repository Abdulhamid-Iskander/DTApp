import 'package:flutter/material.dart';
import 'taskManagement.dart';
import 'dart:async';

class FailurePage extends StatefulWidget {
  final VoidCallback onExtendTime;
  final VoidCallback onPostponeTask;
  final Task currentTask;

  const FailurePage({
    super.key,
    required this.onExtendTime,
    required this.onPostponeTask,
    required this.currentTask,
  });

  @override
  _FailurePageState createState() => _FailurePageState();
}

class _FailurePageState extends State<FailurePage> {
  int _remainingTime = 0;
  bool _timerInProgress = false;
  Timer? _timer;

  void _startExtendedTimer(int initialTime) {
    setState(() {
      _remainingTime = initialTime;
      _timerInProgress = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _timerInProgress = false;
          _showCompletionDialog();
        }
      });
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Did you complete the task?'),
          content: Text('Did you finish the task successfully?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  widget.currentTask.isCompleted = true;
                });
                _timer?.cancel(); // إيقاف المؤقت قبل مغادرة الصفحة
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TaskManagementPage()),
                );
              },
              child: Text('Yes', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {}); // إعادة بناء الصفحة نفسها دون إنشائها من جديد
              },
              child: Text('No', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Incomplete', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[900],
      ),
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'You couldn\'t complete the task on time.',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            if (_timerInProgress)
              Column(
                children: [
                  Text(
                    'Remaining Time: ${Duration(seconds: _remainingTime).inMinutes} min '
                    '${_remainingTime % 60} sec',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ElevatedButton(
              onPressed: () {
                widget.onExtendTime();
                _startExtendedTimer(widget.currentTask.timeInSeconds ~/ 3);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text('Extend Time', style: TextStyle(color: Colors.red)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                widget.onPostponeTask();
                _timer?.cancel(); // إيقاف المؤقت عند مغادرة الصفحة
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TaskManagementPage()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text('Postpone Task', style: TextStyle(color: Colors.red)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _timer?.cancel(); // إيقاف المؤقت عند مغادرة الصفحة
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TaskManagementPage()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text('Back to Tasks', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
