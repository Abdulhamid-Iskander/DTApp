import 'package:flutter/material.dart';
import 'taskManagement.dart'; // استيراد صفحة إدارة المهام

class FinalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Goal Achieved!'),
        backgroundColor: Colors.green, // لون خلفية الأب بار أخضر
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have completed all your tasks for today!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green, // لون النص أخضر
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Icon(
              Icons.check_circle, // أيقونة تأكيد
              size: 100,
              color: Colors.green, // لون الأيقونة أخضر
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // العودة إلى صفحة إدارة المهام
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TaskManagementPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // لون الخلفية أخضر
                foregroundColor: Colors.white, // لون النص أبيض
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // حواف دائرية
                ),
              ),
              child: Text('Back to Tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
