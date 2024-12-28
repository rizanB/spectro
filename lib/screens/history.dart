import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> experiments = [];

  @override
  void initState() {
    super.initState();
    loadExperiments();
  }

  Future<void> loadExperiments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? savedExperiments = prefs.getStringList('experiments');

      if (savedExperiments != null) {
        setState(() {
          experiments = savedExperiments
              .map((e) => jsonDecode(e) as Map<String, dynamic>)
              .toList(); // Parse JSON back into a list
        });
      }
    } catch (e) {
      // Handle potential errors, e.g., JSON decoding issues
      debugPrint('Error loading experiments: $e');
      setState(() {
        experiments = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: experiments.isEmpty
          ? const Center(
              child: Text('No experiments saved yet'),
            )
          : ListView.builder(
              itemCount: experiments.length,
              itemBuilder: (context, index) {
                final experiment = experiments[index];
                final date = DateTime.parse(experiment['date']);
                final formattedDate =
                    DateFormat('yyyy-MM-dd HH:mm').format(date);

                return Card(
                  child: ListTile(
                    title: Text(
                      experiment['name']?.toString().isNotEmpty == true
                          ? experiment['name']
                          : 'Unnamed Experiment',
                    ),
                    subtitle: Text(formattedDate),
                    onTap: () {
                      // Navigate to a detailed screen or display observations
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExperimentDetailsScreen(
                            experiment: experiment,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

// Placeholder for ExperimentDetailsScreen
class ExperimentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> experiment;

  const ExperimentDetailsScreen({Key? key, required this.experiment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> observations = experiment['observations'] ?? [];
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
              'Date of experiment: ${experiment['date']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
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
