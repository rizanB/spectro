import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'A quick note',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                  'I didn\'t write this app to confuse you. I made it because it felt intuitive to have an efficient workflow on my phone that makes taking and plotting observations effortless.'),
              Text(
                  'Spectroscopy is a very common (and useful) tool - I\'ll try to help you understand why and how spectroscopy is used so you can start taking measurements without being confused about terms like absorbance.'),
              Text(
                  'If this app helps you, I\'ll be happy to hear your experience. Feature requests are also very welcome. I try to include things I find intuitive, but no promises there.'),
              Text(
                'Spectroscopy & it\'s principle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Types of spectroscopy'),
              Text('What it means'),
              Text(
                'When not to use spectroscopy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                  'What makes a scientist excellent is perhaps, not that they know a dozen sophisticated methods but that they possess a discerning eye to see which methods don\'t fit.'),
              Text('How to use this app')
            ],
          ),
        ),
      ),
    );
  }
}
