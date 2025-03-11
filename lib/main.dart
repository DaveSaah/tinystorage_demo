import 'package:flutter/material.dart';
import 'package:tiny_storage/tiny_storage.dart';
import 'package:tiny_locator/tiny_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize TinyStorage and register it with tiny_locator
  final storage = await TinyStorage.init('user_data.txt', path: './tmp');
  locator.add<TinyStorage>(() => storage);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tiny Storage Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _idController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    final storage = locator.get<TinyStorage>(); // Get storage instance
    final storedData = storage.get('user_info');

    if (storedData != null) {
      // Update form controllers with stored values
      setState(() {
        _nameController.text = storedData['name'] ?? '';
        _ageController.text = storedData['age'] ?? '';
        _idController.text = storedData['id'] ?? '';
        _dobController.text = storedData['dob'] ?? '';
        _phoneController.text = storedData['phone'] ?? '';
      });
    }
  }

  Future<void> _saveData() async {
    final storage =
        locator.get<TinyStorage>(); // Get instance from tiny_locator
    final newUserData = {
      'name': _nameController.text.trim(),
      'age': _ageController.text.trim(),
      'id': _idController.text.trim(),
      'dob': _dobController.text.trim(),
      'phone': _phoneController.text.trim(),
    };

    storage.set('user_info', newUserData);
    _loadStoredData(); // Reload stored data to update UI
  }

  void _showFormDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Your Info'),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'ID Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _dobController,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(),
                      hintText: 'YYYY-MM-DD',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveData();
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Tiny Storage Demo',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormDialog,
        child: const Icon(
          Icons.edit,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Full Name', _nameController.text),
            _buildInfoRow('Age', _ageController.text),
            _buildInfoRow('ID Number', _idController.text),
            _buildInfoRow('Date of Birth', _dobController.text),
            _buildInfoRow('Phone Number', _phoneController.text),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            value.isNotEmpty ? value : 'Not provided',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
