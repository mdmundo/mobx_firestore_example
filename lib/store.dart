import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Include generated file
part 'store.g.dart';

// This is the class used by rest of your codebase
class Token = _Token with _$Token;

FirebaseFirestore firestore = FirebaseFirestore.instance;

// The store-class
abstract class _Token with Store {
  _Token() {
    _streamController = StreamController<QuerySnapshot>();

    _streamController.addStream(firestore.collection('tokens').snapshots());

    tokenStream = ObservableStream(_streamController.stream);
  }

  late final StreamController<QuerySnapshot> _streamController;

  late final ObservableStream<QuerySnapshot?> tokenStream;

  @action
  void increment() {
    firestore
        .collection('tokens')
        .add({
          'user': 'bull',
        })
        .then((value) => print("Token Added"))
        .catchError((error) => print("Failed to add token: $error"));
  }

  void dispose() async {
    await _streamController.close();
  }
}
