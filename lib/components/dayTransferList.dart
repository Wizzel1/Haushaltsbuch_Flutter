import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/components/transactionTile.dart';
import 'package:flutter_haushaltsbuch/models/transfer.dart';
import 'package:flutter_haushaltsbuch/services/database.dart';
import 'package:flutter_haushaltsbuch/utility/constants.dart';
import 'package:flutter_haushaltsbuch/utility/dateFormatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_haushaltsbuch/models/user.dart';

class TransferList extends StatefulWidget {
  @override
  _TransferListState createState() => _TransferListState();
}

class _TransferListState extends State<TransferList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder(
      stream: DatabaseService(uid: user.uid).transfers,
      builder: (BuildContext context, AsyncSnapshot builderSnapshot) {
        switch (builderSnapshot.connectionState) {
          case ConnectionState.waiting:
            //TODO: Edit placing of spinner
            return SpinKitChasingDots(
              color: kTextColorHeading,
              size: 50,
            );
          default:
            if (builderSnapshot.hasError) {
              return Text('haserror');
            } else {
              var _dateMap = _getTransferList(builderSnapshot.data);
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _dateMap.length,
                itemBuilder: (
                  BuildContext context,
                  int dayindex,
                ) {
                  return Column(
                    children: <Widget>[
                      //Headercontainer
                      Container(
                        color: kBackgroundColor,
                        height: 40,
                        alignment: Alignment.topLeft,
                        child: Text(
                          DateFormatter().getDayNameString(_dateMap.keys.toList()[dayindex]),
                          style: GoogleFonts.muli(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ),
                      //Tilecontainer
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(kButtonRadius),
                        ),
                        child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _dateMap[_dateMap.keys.toList()[dayindex]].length,
                          itemBuilder: (BuildContext context, int index) {
                            return TransactionTile(
                              transfer: _dateMap[_dateMap.keys.toList()[dayindex]][index],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20)
                    ],
                  );
                },
              );
            }
        }
      },
    );
  }

  Map<int, List<Transfer>> _getTransferList(List<Transfer> transfers) {
    Map<int, List<Transfer>> _data = {};
    transfers.forEach((transfer) {
      if (!_data.containsKey(transfer.date)) {
        _data[transfer.date] = [transfer];
      } else {
        _data[transfer.date].add(transfer);
      }
    });
    return _data;
  }
}
