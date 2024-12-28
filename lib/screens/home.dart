import 'package:flutter/material.dart';
import 'new_exp.dart';
import 'history.dart';
import 'help.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spectroscopy Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewExperimentScreen()),
              ),
              child: Text('New Experiment'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              ),
              child: Text('History'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpScreen()),
              ),
              child: Text('Help'),
            ),
          ],
        ),
      ),
    );
  }
}
