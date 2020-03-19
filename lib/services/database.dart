import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_haushaltsbuch/models/transfer.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference _transferCollection = Firestore.instance.collection('transfers');

  final CollectionReference _categoryCollection = Firestore.instance.collection('categories');

  final CollectionReference _recurringTransferCollection =
      Firestore.instance.collection('recurringTransfers');

  Future<void> createTransfer(Transfer transfer) async {
    try {
      DocumentReference docRef =
          await _transferCollection.document(uid).collection('userTransfers').add({
        'userID': uid,
        'name': transfer.name,
        'date': transfer.date,
        'amount': transfer.amount,
        'category': transfer.category,
        'isExpense': transfer.isExpense,
        'isRecurring': transfer.isRecurring,
      });

      if (transfer.isRecurring) {
        await _createRecurringTransferReference(transfer.date, docRef.documentID);
      }
    } catch (e) {
      //TODO: Implement errorhandling
    }
  }

  ///Creates a new reference to "recurringTransfers"
  ///
  ///Takes in a [date] to check if a document for this day already exists (if not, creates a new document)
  ///
  ///and a [docID] to store it as the reference.
  Future<void> _createRecurringTransferReference(int date, String docID) async {
    DocumentSnapshot snapshot = await _recurringTransferCollection.document('$date').get();
    if (snapshot.exists) {
      //If there is already an entry for this day
      var snapShotData = snapshot.data;
      List transferReferences = snapShotData['transferReferences'];
      transferReferences.add(docID);
      snapShotData['transferReferences'] = transferReferences;
      await _recurringTransferCollection.document('$date').updateData(snapShotData);
    } else {
      Map<String, List> newDay = {
        'transferReferences': [docID]
      };
      await _recurringTransferCollection.document('$date').setData(newDay);
    }
  }

  //user created new category
  Future<void> updateUserCategories() async {}

  //get list of transfers of statisticpage
  ///Runs a query with selected parameters [categories] and [dateRange].
  ///
  ///Deserializes returned data to List<Transfer>.
  Future<List<Transfer>> getSelectedTransfersBy(
      {List<String> categories, List<String> dateRange}) async {
    if (categories.isEmpty) {
      print('returning []');
      return [];
    }
    try {
      QuerySnapshot snapshot = await _transferCollection
          .where('userID', isEqualTo: uid)
          .where('date', isGreaterThanOrEqualTo: dateRange[0])
          .where('date', isLessThanOrEqualTo: dateRange[1])
          .where('category', whereIn: categories)
          .orderBy('date')
          .getDocuments();
      List<Transfer> transferList = [];
      snapshot.documents.forEach((transferData) {
        transferList.add(Transfer(
            isExpense: transferData.data['isExpense'],
            name: transferData.data['name'],
            amount: transferData.data['amount'],
            isRecurring: transferData.data['isRecurring'],
            category: transferData.data['category'],
            date: transferData.data['date']));
      });
      print('first transfer : ${transferList[0].date}');
      print('last transfer : ${transferList.last.date}');
      print(transferList.length);
      return transferList;
    } catch (e) {
      print(e);
    }
  }

  // brew list from snapshot
  List<Transfer> _transferListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Transfer(
          date: doc.data['date'],
          name: doc.data['name'],
          amount: doc.data['amount'],
          category: doc.data['category'],
          isExpense: doc.data['isExpense'],
          isRecurring: doc.data['isRecurring']);
    }).toList();
  }

  // get brews stream
  Stream<List<Transfer>> get transfers {
    return _transferCollection
        .document(uid)
        .collection('userTransfers')
        .orderBy('date', descending: true)
        .snapshots()
        .map(_transferListFromSnapshot);
  }
}
