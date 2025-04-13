import 'package:flutter/material.dart';
import 'taskManagement.dart';

class ArchivePage extends StatefulWidget {
  final List<Task> archivedTasks;

  const ArchivePage({super.key, required this.archivedTasks});

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archived Tasks'),
        backgroundColor: Colors.blue[800],
        elevation: 10,
      ),
      body: widget.archivedTasks.isEmpty
          ? Center(
              child: Text('No archived tasks yet!',
                  style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: widget.archivedTasks.length,
              itemBuilder: (context, index) {
                final task = widget.archivedTasks[index];
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
                      'Time: ${Duration(seconds: task.timeInSeconds).inMinutes} min '
                      '${Duration(seconds: task.timeInSeconds).inSeconds % 60} sec',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.restore, color: Colors.green),
                          onPressed: () {
                            setState(() {
                              widget.archivedTasks.removeAt(index);
                            });
                            Navigator.pop(context, task);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              widget.archivedTasks.removeAt(index);
                            });
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
