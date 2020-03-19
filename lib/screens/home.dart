import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/components/dayTransferList.dart';
import 'package:flutter_haushaltsbuch/services/auth.dart';
import 'package:flutter_haushaltsbuch/services/database.dart';
import 'package:flutter_haushaltsbuch/utility/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_haushaltsbuch/models/transfer.dart';
import 'package:flutter_haushaltsbuch/components/bottomBar.dart';
import 'package:flutter_haushaltsbuch/components/quickActionIcon.dart';
import 'package:provider/provider.dart';
import 'package:flutter_haushaltsbuch/models/user.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _testDay = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<Transfer>>.value(
      value: DatabaseService(uid: user.uid).transfers,
      child: Scaffold(
        backgroundColor: kTextColorHeading,
        bottomNavigationBar: BottomBar(),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  color: kTextColorHeading,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //Balancerow
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '480€',
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  'Monthly Balance',
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 80,
                              width: 80,
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://scontent.fhaj2-1.fna.fbcdn.net/v/t1.0-9/1545548_704821819589709_1849648359467064000_n.jpg?_nc_cat=108&_nc_ohc=vYauhAlgLGoAX_DrTz8&_nc_ht=scontent.fhaj2-1.fna&oh=4c95c75db9b789d56e810c963f0f0e94&oe=5E8F598D'),
                                      ),
                                      boxShadow: [
                                        kCardShadow,
                                      ],
                                      borderRadius: BorderRadius.circular(kButtonRadius),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    left: 5,
                                    child: Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                        SizedBox(height: 20),
                        //Buttonrow
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            QuickActionIcon(
                              icon: Icon(Icons.account_balance),
                              text: 'logout',
                              onTap: () => _auth.signOut(),
                            ),
                            QuickActionIcon(
                              icon: Icon(Icons.account_balance_wallet),
                              text: 'create entrys',
                              onTap: () async {
                                await _createTestData(user.uid);
                              },
                            ),
                            QuickActionIcon(
                                icon: Icon(Icons.monetization_on),
                                text: 'printsnapshot',
                                onTap: () async {}),
                            QuickActionIcon(
                              icon: Icon(Icons.account_balance),
                              text: 'Send',
                              onTap: () => print('Send2 tapped'),
                            ),
                          ],
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(19),
                        topRight: Radius.circular(19),
                      ),
                    ),
                    child: TransferList(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future _createTestData(String userID) async {
    DateTime now = DateTime.now();
    String day = now.add(Duration(days: _testDay)).day <= 9
        ? '0${now.add(Duration(days: _testDay)).day}'
        : '${now.add(Duration(days: _testDay)).day}';
    String month = now.month <= 9 ? '0${now.month}' : '${now.month}';
    int date = int.parse('${now.year}$month$day');
    Random random = Random();
    Transfer transfer = Transfer(
        amount: random.nextInt(500).toDouble(),
        isExpense: true,
        name: 'testtransfer1',
        isRecurring: false,
        category: 'Food',
        date: date);
    Transfer transfer2 = Transfer(
        amount: random.nextInt(500).toDouble(),
        isExpense: true,
        name: 'testtransfer2',
        isRecurring: true,
        category: 'Payment',
        date: date);
    await DatabaseService(uid: userID).createTransfer(transfer);
    await DatabaseService(uid: userID).createTransfer(transfer2);
    _testDay += 1;
  }
}
