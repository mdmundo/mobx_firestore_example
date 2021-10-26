import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import 'store.dart';

final store = Token();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'How many docs are there in the collection:',
            ),
            Observer(
              builder: (_) => store.tokenStream.status == StreamStatus.waiting
                  ? CircularProgressIndicator()
                  : Text(
                      '${store.tokenStream.value?.size}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
            ),
            const Text(
              'Docs in the collection:',
            ),
            Observer(
              builder: (_) => Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView(
                  children: store.tokenStream.value?.docs
                          .map(
                            (doc) => ListTile(
                              title: Text(doc.get('user')),
                              subtitle: Text(doc.get('secret')),
                            ),
                          )
                          .toList() ??
                      <Widget>[],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: store.increment,
        tooltip: 'Add to collection',
        child: const Icon(Icons.add),
      ),
    );
  }
}
