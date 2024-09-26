import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  SharedPreferences? prefs;
  List<String> nameList = [];

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      nameList = prefs?.getStringList('nameList') ?? [];
    });
  }

  void clearPreferences() async {
    prefs = await SharedPreferences.getInstance();
    prefs?.remove('nameList');
    setState(() {
      nameList = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              loadPreferences();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              clearPreferences();
            },
          ),
        ],
      ),
      body: nameList.isNotEmpty
          ? ListView.builder(
              itemCount: nameList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(nameList[index]),
                );
              },
            )
          : const Center(
              child: Text('No values stored.'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondPage()),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  TextEditingController controller = TextEditingController();
  SharedPreferences? prefs;
  List<String> nameList = [];

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      nameList = prefs?.getStringList('nameList') ?? [];
    });
  }

  void savePreferences() async {
    if (prefs != null) {
      nameList.add(controller.text);
      prefs?.setStringList('nameList', nameList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new string'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Enter a string',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  savePreferences();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add String'),
            ),
          ],
        ),
      ),
    );
  }
}
