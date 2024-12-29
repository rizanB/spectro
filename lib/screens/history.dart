import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spectro/screens/experiment_details.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> experiments = [];
  String? _selectedSortOption = 'Date: recent first'; // Default sort by Date: recent first

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
        _sortExperiments(_selectedSortOption!); // Sort after loading data
      }
    } catch (e) {
      // Handle potential errors, e.g., JSON decoding issues
      debugPrint('Error loading experiments: $e');
      setState(() {
        experiments = [];
      });
    }
  }

  void _sortExperiments(String criteria) {
    setState(() {
      if (criteria == 'Date: recent first') {
        experiments.sort((a, b) {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA); // Sort by date, latest first
        });
      } else if (criteria == 'Date: oldest first') {
        experiments.sort((a, b) {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return dateA.compareTo(dateB); // Sort by date, oldest first
        });
      } else if (criteria == 'Name: a-z') {
        experiments.sort((a, b) {
          final nameA = a['name']?.toString().toLowerCase() ?? '';
          final nameB = b['name']?.toString().toLowerCase() ?? '';
          return nameA.compareTo(nameB); // Sort by name, A-Z
        });
      } else if (criteria == 'Name: z-a') {
        experiments.sort((a, b) {
          final nameA = a['name']?.toString().toLowerCase() ?? '';
          final nameB = b['name']?.toString().toLowerCase() ?? '';
          return nameB.compareTo(nameA); // Sort by name, Z-A
        });
      }
      _selectedSortOption = criteria; // Update selected option
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Column(
        children: [
          // Sorting Dropdown
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Sort experiments by: '),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: _selectedSortOption,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        _sortExperiments(newValue);
                      }
                    },
                    items: <String>[
                      'Date: recent first',
                      'Date: oldest first',
                      'Name: a-z',
                      'Name: z-a',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // List of experiments
          experiments.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text('No experiments saved yet'),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
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
                ),
        ],
      ),
    );
  }
}
