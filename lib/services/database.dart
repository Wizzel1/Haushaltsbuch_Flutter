import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_haushaltsbuch/models/transfer.dart';
import 'package:flutter_haushaltsbuch/utility/dateFormatter.dart';
import 'package:intl/intl.dart';

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

    DocumentReference totalsYearMonthRef =
        _totalsCollection.document(uid).collection(year).document(month);
    DocumentSnapshot snapshot = await totalsYearMonthRef.get();

    if (snapshot.exists) {
      //if this yearcollection with this month exists
      Map snapshotData = snapshot.data;
      if (snapshotData.containsKey(transfer.category)) {
        //if this week already contains an entry for the transfer.category
        double oldAmount = double.parse(snapshotData[transfer.category].toString());
        double newAmount = oldAmount + transfer.amount;
        snapshotData[transfer.category] = newAmount;
        await totalsYearMonthRef.setData(snapshotData);
      } else {
        //if the snapshot does not have an entry for transfer.category
        snapshotData[transfer.category] = transfer.amount;
        await totalsYearMonthRef.setData(snapshotData);
      }
    } else {
      //if snapshot does not exist
      await totalsYearMonthRef.setData({transfer.category: transfer.amount});
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

  ///Runs a query for the selected time or period of time.
  ///
  ///[dateRange] is a connected period of time (01.01.2020 - 01.03.2020)
  ///
  ///[dateList] is a list of non connected months (January 2020, May 2020, December 2020)
  ///which defaults to current month
  Future<Object> getDataBySelectedTime(
      {List<String> categories, List<DateTime> dateRange, List<DateTime> dateList}) async {
    if (dateRange.isEmpty && dateList.length > 1) {
      return await _getIndividualDates(dateList);
    } else if (dateRange.isEmpty && dateList.length == 1) {
      return await _getSingleDate(dateList);
    } else if (dateRange.isNotEmpty && dateList.isEmpty) {
      return await _getTransfersByPeriod(dateRange, categories);
    }
  }

  Future<List<Map>> _getIndividualDates(List<DateTime> dateList) async {
    List<Map> dataList = [];
    try {
      for (DateTime date in dateList) {
        var snapshot = await _totalsCollection
            .document(uid)
            .collection('${date.year}')
            .document(date.month <= 9 ? '0${date.month}' : '${date.month}')
            .get();
        Map snapShotmap = snapshot.data;
        dataList.add(snapShotmap);
      }
      return dataList;
    } catch (e) {
      _handleError(e);
    }
  }

  Future<Map> _getSingleDate(List<DateTime> dateList) async {
    DateTime singleDate = dateList[0];
    try {
      var snapshot = await _totalsCollection
          .document(uid)
          .collection('${singleDate.year}')
          .document(singleDate.month <= 9 ? '0${singleDate.month}' : '${singleDate.month}')
          .get();
      Map snapShotmap = snapshot.data;
      return snapShotmap;
    } catch (e) {
      _handleError(e);
    }
  }

  Future<List<Transfer>> _getTransfersByPeriod(
      List<DateTime> dateRange, List<String> categories) async {
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
      _handleError(e);
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

  // get transfer stream
  Stream<List<Transfer>> get transfers {
    return _transferCollection
        .document(uid)
        .collection('transfers')
        .orderBy('date', descending: true)
        .snapshots()
        .map(_transferListFromSnapshot);
  }

  void _handleError(dynamic error) {
    print(error);
  }
}
