import 'package:flutter/material.dart';
import 'taskManagement.dart';

class FinalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Goal Not Achieved!'),
        backgroundColor: Colors.red, // تغيير لون الشريط العلوي إلى الأحمر
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You did not complete all your tasks for today!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // تغيير لون النص إلى الأبيض
              ),
            ),
            SizedBox(height: 20),
            Icon(Icons.error,
                size: 100, color: Colors.red), // تغيير الأيقونة إلى شعار الفشل
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TaskManagementPage()),
                );
              },
              child: Text('Back to Tasks'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.red, // تغيير لون خلفية الصفحة إلى الأحمر
    );
  }
}
