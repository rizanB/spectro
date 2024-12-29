import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class NewExperimentScreen extends StatelessWidget {
  const NewExperimentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CalibrationHomePage();
  }
}

class CalibrationHomePage extends StatefulWidget {
  const CalibrationHomePage({super.key});

  @override
  _CalibrationHomePageState createState() => _CalibrationHomePageState();
}

class _CalibrationHomePageState extends State<CalibrationHomePage> {
  final List<double> concentrations = [];
  final List<double> absorbances = [];
  final List<Map<String, dynamic>> observations = [];
  final List<String> volumeUnits = ['µg/mL', 'mg/mL', 'g/L', '%'];
  String? selectedVolumeUnit = 'mg/mL';
  final TextEditingController concentrationController = TextEditingController();
  final TextEditingController absorbanceController = TextEditingController();
  final TextEditingController experimentNameController =
      TextEditingController();
  final TextEditingController absorbancePredictionController =
      TextEditingController();

  String linearEquation = '';
  String rSquared = '';
  bool showChart = false;

  double? predictConcentration(double absorbance) {
    print(absorbance);
    print(concentrations);
    print(linearEquation);
    if (concentrations.isEmpty) return null;

    final regExp = RegExp(r'y = ([\d.-]+)x \+ ([\d.-]+)');
    final match = regExp.firstMatch(linearEquation);

    if (match != null) {
      final slope = double.tryParse(match.group(1)!);
      final intercept = double.tryParse(match.group(2)!);

      if (slope != null && intercept != null) {
        return (absorbance - intercept) / slope;
      }
    }
    return null;
  }

  void addDataPoint() {
    final concentration = double.tryParse(concentrationController.text);
    final absorbance = double.tryParse(absorbanceController.text);

    if (concentration != null && absorbance != null) {
      setState(() {
        observations
            .add({'concentration': concentration, 'absorbance': absorbance});

        // for plotting graph
        concentrations.add(concentration);
        absorbances.add(absorbance);
      });

      concentrationController.clear();
      absorbanceController.clear();

      if (concentrations.length >= 3) {
        showChart = true;
        calculateLinearEquation();
      }
    }
  }

  void saveExperiment() async {
    if (observations.length >= 3) {
      final experimentName = experimentNameController.text.trim();

      if (experimentName.isEmpty) {
        _promptUserForExperimentName();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You need at least 3 observations to save')),
      );
    }
  }

  void _promptUserForExperimentName() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Experiment Name'),
          content: TextField(
            controller: experimentNameController,
            decoration: const InputDecoration(
              labelText: 'Experiment Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = experimentNameController.text.trim();
                if (name.isNotEmpty) {
                  final date = DateTime.now();
                  _saveExpWithName(name, date);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveExpWithName(String name, DateTime date) async {
    final prefs = await SharedPreferences.getInstance();

    // Create a data structure to store the experiment
    final experiment = {
      'name': name,
      'date': date.toIso8601String(),
      'observations': List<Map<String, dynamic>>.from(observations),
    };

    final List<String> experiments = prefs.getStringList('experiments') ?? [];
    experiments.add(jsonEncode(experiment));
    await prefs.setStringList('experiments', experiments);

    // Provide user feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Experiment "$name" saved successfully')),
    );

    // clearData();
    experimentNameController.clear();
  }

  void clearData() {
    setState(() {
      concentrations.clear();
      absorbances.clear();
      linearEquation = '';
      rSquared = '';
      showChart = false;
      observations.clear();
    });
  }

  void calculateLinearEquation() {
    if (concentrations.length <= 2) return;

    final n = concentrations.length;
    final sumX = concentrations.reduce((a, b) => a + b);
    final sumY = absorbances.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => concentrations[i] * absorbances[i])
        .reduce((a, b) => a + b);
    final sumX2 = concentrations.map((x) => x * x).reduce((a, b) => a + b);

    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    final intercept = (sumY - slope * sumX) / n;

    final meanY = sumY / n;
    final totalSS =
        absorbances.fold(0.0, (sum, y) => sum + (y - meanY) * (y - meanY));
    final residualSS = List.generate(
            n, (i) => absorbances[i] - (slope * concentrations[i] + intercept))
        .fold(0.0, (sum, res) => sum + res * res);

    final rSquaredValue = 1 - (residualSS / totalSS);

    setState(() {
      linearEquation =
          'y = ${slope.toStringAsFixed(2)}x + ${intercept.toStringAsFixed(2)}';
      rSquared = 'R² = ${rSquaredValue.toStringAsFixed(3)}';
    });
  }

  List<FlSpot> getRegressionLine() {
    if (concentrations.isEmpty) return [];
    calculateLinearEquation();

    final n = concentrations.length;
    final sumX = concentrations.reduce((a, b) => a + b);
    final sumY = absorbances.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => concentrations[i] * absorbances[i])
        .reduce((a, b) => a + b);
    final sumX2 = concentrations.map((x) => x * x).reduce((a, b) => a + b);

    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    final intercept = (sumY - slope * sumX) / n;

    return concentrations.map((x) => FlSpot(x, slope * x + intercept)).toList();
  }

  Widget buildDataInputRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: concentrationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'concentration'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: absorbanceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'absorbance'),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(onPressed: addDataPoint, child: const Text('Add')),
      ],
    );
  }

  GlobalKey repaintKey = GlobalKey();

  Widget buildGraph() {
    return RepaintBoundary(
      key: repaintKey,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                concentrations.length,
                (i) => FlSpot(concentrations[i], absorbances[i]),
              ),
              isCurved: false,
              barWidth: 4,
              isStrokeCapRound: true,
            ),
            LineChartBarData(
              spots: getRegressionLine(),
              isCurved: false,
              barWidth: 2,
              isStrokeCapRound: true,
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: const Text('Absorbance'),
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text('Concentration ($selectedVolumeUnit)'),
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveGraph() async {
    try {
      // Request storage permission
      PermissionStatus status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission is required')),
        );
        return;
      }

      RenderRepaintBoundary boundary = repaintKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0); // High-res image
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      // Get the appropriate directory based on Android version
      Directory directory;
      if (Platform.isAndroid && (await Permission.storage.isGranted)) {
        // For Android 10 and higher, use external storage directory
        directory = await getExternalStorageDirectory() ??
            await getApplicationDocumentsDirectory();
      } else {
        // For other platforms, use application documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      final filePath = '${directory.path}/graph_image.png';

      // Save the image to the directory
      final file = File(filePath);
      await file.writeAsBytes(buffer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Graph saved to $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving graph')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spectro Calibration Graph'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Concentration of sample in:'),
                Spacer(),
                SizedBox(
                  width: 100,
                  child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Select unit for concentration'),
                      value: selectedVolumeUnit,
                      icon: Icon(Icons.arrow_drop_down),
                      items: volumeUnits.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedVolumeUnit = value;
                        });
                      }),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (concentrations.isNotEmpty)
                  ElevatedButton(
                    onPressed: clearData,
                    child: const Text('Clear Observations'),
                  ),
                if (concentrations.length >= 3)
                  ElevatedButton(
                      onPressed: () {
                        saveExperiment();
                      },
                      child: const Text('Save experiment'))
              ],
            ),
            buildDataInputRow(),
            Expanded(
                child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(tabs: [
                          Tab(
                            text: 'Data',
                            icon: Icon(Icons.table_view),
                          ),
                          Tab(
                            icon: Icon(Icons.show_chart),
                            text: 'Graph',
                          ),
                          Tab(
                            text: 'Predict',
                          )
                        ]),
                        Expanded(
                            child: TabBarView(children: [
                          ListView.builder(
                            itemCount: observations
                                .length, // Use observations list here
                            itemBuilder: (context, index) {
                              final observation = observations[
                                  index]; // Get the observation at the current index
                              return ListTile(
                                title: Text(
                                    'Concentration: ${observation['concentration']} ${selectedVolumeUnit}'), // Access concentration from observation map
                                subtitle: Text(
                                    'Absorbance: ${observation['absorbance']}'), // Access absorbance from observation map
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        final observation = observations[index];
                                        final concentrationEditController =
                                            TextEditingController(
                                                text:
                                                    observation['concentration']
                                                        .toString());
                                        final absorbanceEditController =
                                            TextEditingController(
                                                text: observation['absorbance']
                                                    .toString());

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Edit Observation'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller:
                                                        concentrationEditController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Concentration ($selectedVolumeUnit)',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextField(
                                                    controller:
                                                        absorbanceEditController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText:
                                                                'Absorbance'),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    final newConcentration =
                                                        double.tryParse(
                                                            concentrationEditController
                                                                .text);
                                                    final newAbsorbance =
                                                        double.tryParse(
                                                            absorbanceEditController
                                                                .text);

                                                    if (newConcentration !=
                                                            null &&
                                                        newAbsorbance != null) {
                                                      setState(() {
                                                        // Update the specific observation
                                                        observations[index] = {
                                                          'concentration':
                                                              newConcentration,
                                                          'absorbance':
                                                              newAbsorbance,
                                                        };

                                                        // Sync with concentrations and absorbances lists
                                                        concentrations[index] =
                                                            newConcentration;
                                                        absorbances[index] =
                                                            newAbsorbance;

                                                        // Recalculate the linear equation and chart if needed
                                                        if (concentrations
                                                                .length >=
                                                            3) {
                                                          calculateLinearEquation();
                                                        }
                                                      });
                                                      Navigator.pop(context);
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Invalid input values')),
                                                      );
                                                    }
                                                  },
                                                  child: const Text('Save'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            observations.removeAt(
                                                index); // Remove from observations
                                            concentrations.removeAt(
                                                index); // Remove from concentrations
                                            absorbances.removeAt(
                                                index); // Remove from absorbances
                                          });
                                          if (concentrations.length < 3) {
                                            showChart = false;
                                          }
                                        },
                                        icon: const Icon(Icons.delete)),
                                  ],
                                ),
                              );
                            },
                          ),

                          //content for first tab ends here

                          Column(children: [
                            if (showChart) ...[
                              const SizedBox(height: 10),
                              Text(
                                'Linear regression: $linearEquation',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                rSquared,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(height: 300, child: buildGraph()),
                              ElevatedButton(
                                onPressed: _saveGraph,
                                child: const Text('Save Graph'),
                              ),
                            ]
                          ]),

                          // content for second tab ends here..

                          Column(
                            children: [
                              TextField(
                                controller: absorbancePredictionController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText:
                                      'Enter Absorbance',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final absorbanceInput = double.tryParse(
                                      absorbancePredictionController.text);

                                  if (absorbanceInput != null) {
                                    final predictedConcentration =
                                        predictConcentration(absorbanceInput);

                                    if (predictedConcentration != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Predicted concentration: ${predictedConcentration.toStringAsFixed(2)} $selectedVolumeUnit')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Failed to predict concentration.')),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please enter a valid absorbance value.')),
                                    );
                                  }
                                },
                                child: const Text('Predict Concentration'),
                              ),
                            ],
                          )
                        ])),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}
