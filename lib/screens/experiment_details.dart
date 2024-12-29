import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExperimentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> experiment;

  const ExperimentDetailsScreen({super.key, required this.experiment});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> observations = experiment['observations'] ?? [];
    final date = DateTime.parse(experiment['date']);
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);

    return Scaffold(
      appBar: AppBar(
        title: Text(experiment['name'] ?? 'Experiment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date of experiment: ${formattedDate}',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 16),
            const Text(
              'Observations:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: observations.length,
                itemBuilder: (context, index) {
                  final observation = observations[index];
                  return ListTile(
                    title:
                        Text('Concentration: ${observation['concentration']}'),
                    subtitle: Text('Absorbance: ${observation['absorbance']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
