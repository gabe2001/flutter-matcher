import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'matcher/records.dart';

void main() => runApp(const MatcherApp());

class MatcherApp extends StatelessWidget {
  const MatcherApp({super.key});

  static const String _title = 'Matcher App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.green,
        focusColor: Colors.white,
      ),
      debugShowCheckedModeBanner: true,
      home: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<RecordsCount> _futureRecordsCount;

  @override
  void initState() {
    super.initState();
    _refreshRecordsCount();
  }

  void _flushRecords() {
    flushRecords();
    setState(() {
      _futureRecordsCount = getRecordsCount();
    });
  }

  void _refreshRecordsCount() {
    setState(() {
      _futureRecordsCount = getRecordsCount();
    });
  }

  void _addExcelRecords() {
    addExcelData();
    setState(() {
      _futureRecordsCount = getRecordsCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matcher'),
      ),
      body: Center(
        child: FutureBuilder<RecordsCount>(
          future: _futureRecordsCount,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Records: ${snapshot.data!.records}');
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      persistentFooterButtons: [
        FloatingActionButton(
          onPressed: _refreshRecordsCount,
          tooltip: 'Refresh Records Count',
          backgroundColor: Colors.blue,
          child: const Icon(Icons.refresh),
        ),
        FloatingActionButton(
          onPressed: _addExcelRecords,
          tooltip: 'Load HDD Data',
          backgroundColor: Colors.lightGreen,
          child: const Icon(Icons.table_chart),
        ),
        FloatingActionButton(
          onPressed: _flushRecords,
          tooltip: 'Flush Data',
          backgroundColor: Colors.orange,
          child: const Icon(Icons.delete),
        ),
        FloatingActionButton(
          onPressed: _exit,
          tooltip: 'Exit',
          backgroundColor: Colors.red,
          child: const Icon(Icons.exit_to_app),
        ),
      ],
      bottomNavigationBar: BottomAppBar(
        child: FutureBuilder<RecordsCount>(
          future: _futureRecordsCount,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Records: ${snapshot.data!.records}');
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void _exit() => exit(0);
}
