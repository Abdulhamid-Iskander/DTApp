import 'package:flutter/material.dart';
import 'good.dart';
import 'notGood.dart';

class StatusPage extends StatefulWidget {
  final String username;
  final String firstName;

  StatusPage({required this.username, required this.firstName});

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  void _navigateToResponse(String status) {
    if (status == 'Good') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GoodStatusPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotGoodStatusPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${widget.firstName}!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(height: 20),
            Text(
              'Are you feeling good today?',
              style: TextStyle(fontSize: 18, color: Colors.deepPurple),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _navigateToResponse('Good'),
                  child: Text('Good'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _navigateToResponse('Not Good'),
                  child: Text('Not Good'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
