import 'package:flutter/material.dart';
import 'taskManagement.dart';
import 'dart:async';

class FailurePage extends StatefulWidget {
  final VoidCallback onExtendTime;
  final VoidCallback onPostponeTask;
  final Task currentTask;

  FailurePage({
    required this.onExtendTime,
    required this.onPostponeTask,
    required this.currentTask,
  });

  @override
  _FailurePageState createState() => _FailurePageState();
}

class _FailurePageState extends State<FailurePage> {
  int _remainingTime = 0; // الوقت المتبقي
  bool _timerInProgress = false; // حالة المؤقت
  Timer? _timer; // المؤقت

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
          _showCompletionDialog(); // عرض مربع حوار بعد انتهاء الوقت
        }
      });
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Did you complete the task?',
            style:
                TextStyle(color: Colors.black), // لون النص الأسود في الدايلوج
          ),
          content: Text(
            'Did you finish the task successfully?',
            style:
                TextStyle(color: Colors.black), // لون النص الأسود في الدايلوج
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskManagementPage(),
                  ),
                );
                widget.currentTask.isCompleted =
                    true; // وضع علامة خضراء على المهمة
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.red), // لون النص أحمر
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FailurePage(
                      onExtendTime: widget.onExtendTime,
                      onPostponeTask: widget.onPostponeTask,
                      currentTask: widget.currentTask,
                    ),
                  ),
                );
              },
              child: Text(
                'No',
                style: TextStyle(color: Colors.red), // لون النص أحمر
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // إلغاء المؤقت عند إزالة الصفحة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Incomplete',
          style: TextStyle(color: Colors.white), // لون النص أبيض
        ),
        backgroundColor: Colors.red[900], // لون الشريط العلوي أحمر داكن
      ),
      backgroundColor: Colors.red, // لون خلفية الصفحة أحمر
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.white, // لون الأيقونة أبيض
            ),
            SizedBox(height: 20),
            Text(
              'You couldn\'t complete the task on time.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // لون النص أبيض
              ),
            ),
            SizedBox(height: 20),
            if (_timerInProgress)
              Column(
                children: [
                  Text(
                    'Remaining Time: ${_remainingTime ~/ 60} minutes ${_remainingTime % 60} seconds',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white, // لون النص أبيض
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ElevatedButton(
              onPressed: () {
                widget.onExtendTime(); // تمديد الوقت
                _startExtendedTimer(widget.currentTask.timeInSeconds ~/
                    3); // بدء مؤقت بثلث الوقت
              },
              child: Text(
                'Extend Time',
                style: TextStyle(color: Colors.red), // لون النص أحمر
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // لون خلفية الزر أبيض
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                widget.onPostponeTask(); // تأجيل المهمة
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskManagementPage(),
                  ),
                );
              },
              child: Text(
                'Postpone Task',
                style: TextStyle(color: Colors.red), // لون النص أحمر
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // لون خلفية الزر أبيض
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskManagementPage(),
                  ),
                );
              },
              child: Text(
                'Back to Tasks',
                style: TextStyle(color: Colors.red), // لون النص أحمر
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // لون خلفية الزر أبيض
              ),
            ),
          ],
        ),
      ),
    );
  }
}
