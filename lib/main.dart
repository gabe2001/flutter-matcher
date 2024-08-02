import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'matcher/records.dart';
import 'matcher/match.dart';

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
  late Future<MatchResult> _matchResult;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _refreshRecordsCount();
    _initMatchResult();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
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

  void _initMatchResult() {
    setState(() {
      _matchResult = initMatches();
    });
  }

  void _getMatches(String input) {
    setState(() {
      _matchResult = getMatches(input);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matcher'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: 12,
              decoration: const InputDecoration(
                  hintText: 'Query [JSON]',
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.greenAccent))),
            ),
            ElevatedButton(
                onPressed: () {
                  _getMatches(_textEditingController.text);
                },
                child: const Text('Match it now!')),
            FutureBuilder<MatchResult>(
              future: _matchResult,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.matchResult.toString());
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },

            )
          ],
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
              return Text('Records: "${snapshot.data!.records}"');
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
