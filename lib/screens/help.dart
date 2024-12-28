import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Text('Spectrometry & it\'s principle'),
          Text('Types of spectrometry'),
          Text('What it means'),
          Text('How to use this app'),
          Text('FAQ')
        ],
      ),
    );
  }
}
