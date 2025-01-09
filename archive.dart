import 'package:flutter/material.dart';
import 'taskManagement.dart';

class ArchivePage extends StatelessWidget {
  final List<Task> archivedTasks;

  ArchivePage({required this.archivedTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archived Tasks'),
        backgroundColor: Colors.blue[800],
        elevation: 10,
      ),
      body: ListView.builder(
        itemCount: archivedTasks.length,
        itemBuilder: (context, index) {
          final task = archivedTasks[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                task.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                'Time: ${task.timeInSeconds ~/ 60} minutes ${task.timeInSeconds % 60} seconds',
                style: TextStyle(fontSize: 14),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.restore, color: Colors.green),
                    onPressed: () {
                      // استعادة المهمة إلى صفحة المهام
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskManagementPage(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // حذف المهمة من الأرشيف
                      archivedTasks.remove(task);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
