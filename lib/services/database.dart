import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_haushaltsbuch/models/transfer.dart';
import 'package:flutter_haushaltsbuch/utility/dateFormatter.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference _transferCollection = Firestore.instance.collection('transfers');

  final CollectionReference _totalsCollection = Firestore.instance.collection('totals');

  final CollectionReference _categoryCollection = Firestore.instance.collection('categories');

  final CollectionReference _recurringTransferCollection =
      Firestore.instance.collection('recurringTransfers');

  Future<void> createTransfer(Transfer transfer) async {
    try {
      DocumentReference docRef =
          await _transferCollection.document(uid).collection('transfers').add({
        'userID': uid,
        'name': transfer.name,
        'date': transfer.date,
        'amount': transfer.amount,
        'category': transfer.category,
        'isExpense': transfer.isExpense,
        'isRecurring': transfer.isRecurring,
      });

      _addToTotals(transfer);
      if (transfer.isRecurring) {
        await _createRecurringTransferReference(transfer.date, docRef.documentID);
      }
    } catch (e) {
      //TODO: Implement errorhandling
    }
  }

  ///Adds the transfer to the totalsCollection to aggregate Data.
  Future<void> _addToTotals(Transfer transfer) async {
    String dateString = '${transfer.date}';
    String year = dateString.substring(0, 4);
    String month = dateString.substring(4, 6);
    String week = DateFormatter().calculateWeek(transfer.date);
    await _addToTotalMonths(transfer, week, year, month);
    await _addToTotalYears(transfer, year, month);
  }

  Future<void> _addToTotalYears(Transfer transfer, String year, String month) async {
    DocumentReference totalsYearRef =
        _totalsCollection.document(uid).collection('years').document(year);
    DocumentSnapshot yearSnapshot = await totalsYearRef.get();

    if (yearSnapshot.exists) {
      Map snapshotData = yearSnapshot.data;
      if (snapshotData.containsKey(month)) {
        //If theres an entry for this month
        Map<String, dynamic> monthData = snapshotData[month];
        if (monthData.containsKey(transfer.category)) {
          //If theres an entry for this category in this month
          double oldAmount = monthData[transfer.category];
          double newAmount = oldAmount + transfer.amount;
          snapshotData[month][transfer.category] = newAmount;
          await totalsYearRef.setData(snapshotData);
        } else {
          //If theres no entry for transfer.category in this month
          snapshotData[month][transfer.category] = transfer.amount;
          await totalsYearRef.setData(snapshotData);
        }
      } else {
        //If theres no entry for this month
        snapshotData[month] = {transfer.category: transfer.amount};
        await totalsYearRef.setData(snapshotData);
      }
    } else {
      //If theres no entry for this month
      Map<String, Map<String, double>> data = {
        month: {transfer.category: transfer.amount}
      };
      await totalsYearRef.setData(data);
    }
  }

  Future<void> _addToTotalMonths(Transfer transfer, String week, String year, String month) async {
    DocumentReference totalsMonthRef =
        _totalsCollection.document(uid).collection('months').document(year + month);
    DocumentSnapshot monthSnapshot = await totalsMonthRef.get();

    if (monthSnapshot.exists) {
      Map snapshotData = monthSnapshot.data;
      if (snapshotData.containsKey(week)) {
        //If theres an entry for this week
        Map<String, dynamic> weekData = snapshotData[week];
        if (weekData.containsKey(transfer.category)) {
          //If theres an entry for this category in this week
          double oldAmount = weekData[transfer.category];
          double newAmount = oldAmount + transfer.amount;
          snapshotData[week][transfer.category] = newAmount;
          await totalsMonthRef.setData(snapshotData);
        } else {
          //If theres no entry for transfer.category in this week
          snapshotData[week][transfer.category] = transfer.amount;
          await totalsMonthRef.setData(snapshotData);
        }
      } else {
        //If theres no entry for this week
        snapshotData[week] = {transfer.category: transfer.amount};
        await totalsMonthRef.setData(snapshotData);
      }
    } else {
      //If theres no entry for this month
      Map<String, Map<String, double>> data = {
        week: {transfer.category: transfer.amount}
      };
      await totalsMonthRef.setData(data);
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

  // transfer list from snapshot
  List<Transfer> _transferListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Transfer(
          date: doc.data['date'],
          name: doc.data['name'],
          amount: doc.data['amount'],
          category: doc.data['category'],
          isExpense: doc.data['isExpense'],
          isRecurring: doc.data['isRecurring']);
    }).toList();
  }

  // get tranfer stream
  Stream<List<Transfer>> get transfers {
    return _transferCollection
        .document(uid)
        .collection('transfers')
        .orderBy('date', descending: true)
        .snapshots()
        .map(_transferListFromSnapshot);
  }
}
