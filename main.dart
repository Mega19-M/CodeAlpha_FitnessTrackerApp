import 'package:flutter/material.dart';

void main() {
  runApp(const FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker App',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const FitnessScreen(),
    );
  }
}

class Activity {
  final String type;
  final int durationMinutes;
  final int calories;

  Activity({
    required this.type,
    required this.durationMinutes,
    required this.calories,
  });
}

class FitnessScreen extends StatefulWidget {
  const FitnessScreen({super.key});

  @override
  State createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State {
  final List _activities = [
    Activity(type: 'Running', durationMinutes: 30, calories: 300),
    Activity(type: 'Cycling', durationMinutes: 45, calories: 400),
  ];

  final _typeController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();

  int get totalCalories => _activities.isEmpty
      ? 0
      : _activities.map((e) => e.calories).reduce((a, b) => a + b);

  int get totalMinutes => _activities.isEmpty
      ? 0
      : _activities.map((e) => e.durationMinutes).reduce((a, b) => a + b);

  void _addActivity() {
    final type = _typeController.text.trim();
    final duration = int.tryParse(_durationController.text) ?? 0;
    final calories = int.tryParse(_caloriesController.text) ?? 0;

    if (type.isNotEmpty && duration > 0 && calories > 0) {
      setState(() {
        _activities.add(
          Activity(
            type: type,
            durationMinutes: duration,
            calories: calories,
          ),
        );
        _typeController.clear();
        _durationController.clear();
        _caloriesController.clear();
      });
      Navigator.pop(context);
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Activity (e.g. Running)',
              ),
            ),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duration (mins)',
              ),
            ),
            TextField(
              controller: _caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Calories Burned',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addActivity,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Tracker'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.deepOrange[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Total Mins',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$totalMinutes mins',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.orange[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Total Calories',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$totalCalories kcal',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  final item = _activities[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.directions_run,
                        color: Colors.deepOrange,
                      ),
                      title: Text(item.type),
                      subtitle: Text('${item.durationMinutes} mins'),
                      trailing: Text(
                        '${item.calories} kcal',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
