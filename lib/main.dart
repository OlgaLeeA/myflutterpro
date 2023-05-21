import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'firebase_options.dart';
import 'dart:convert';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController apiController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String serverResponse = '';

  Future<void> getData() async {
    try {
      final response = await http.post(
        Uri.parse('${apiController.text}/api/hello'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': nameController.text}),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          serverResponse = jsonResponse['message'];
        });
      } else {
        setState(() {
          serverResponse = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        serverResponse = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: apiController,
              decoration: const InputDecoration(labelText: 'API Endpoint'),
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Your Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: getData,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 16),
            Text('Server Response: $serverResponse'),
          ],
        ),
      ),
    );
  }
}

