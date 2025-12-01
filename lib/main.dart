import 'package:flutter/material.dart';
import 'package:student_list/data.dart';

void main() {
  getStudents();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Android Expert", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<StudentData>>(
        future: getStudents(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 84),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _Student(data: snapshot.data![index]);
              },
              itemCount: snapshot.data?.length,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => _AddStudentForm()));
          setState(() {});
        },
        label: Row(children: [Icon(Icons.add), Text("Add Student")]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _AddStudentForm extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Student")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(label: Text("First Name")),
              controller: _firstNameController,
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(label: Text("Last Name")),
              controller: _lastNameController,
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(label: Text("Course")),
              controller: _courseController,
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(label: Text("Score")),
              controller: _scoreController,
            ),
            SizedBox(height: 8),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            final newStudentData = await saveStudent(
              _firstNameController.text,
              _lastNameController.text,
              _courseController.text,
              int.parse(_scoreController.text),
            );
            Navigator.pop(context, newStudentData);
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        label: Row(children: [Icon(Icons.check), Text("Save")]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _Student extends StatelessWidget {
  final StudentData data;
  const _Student({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 1, color: Colors.black.withOpacity(0.05)),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,

            alignment: Alignment.center,

            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              data.firstName.characters.first,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),

          SizedBox(width: 8),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.firstName + ' ' + data.lastName),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.grey.shade200,
                  ),
                  child: Text(data.course, style: TextStyle(fontSize: 10)),
                ),
              ],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart_rounded, color: Colors.grey.shade400),
              Text(
                data.score.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
