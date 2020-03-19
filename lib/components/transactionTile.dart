import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/components/modalBottomSheet.dart';
import 'package:flutter_haushaltsbuch/utility/constants.dart';
import 'package:flutter_haushaltsbuch/utility/dateFormatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_haushaltsbuch/models/transfer.dart';

class TransactionTile extends StatefulWidget {
  TransactionTile({this.transfer});

  final Transfer transfer;

  @override
  _TransactionTileState createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  bool tileTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          tileTapped = !tileTapped;
        });
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        switchInCurve: Curves.easeInQuint,
        switchOutCurve: Curves.easeOutQuint,
        child: tileTapped ? _buildTileEdit(widget.transfer) : _buildTileDisplay(widget.transfer),
      ),
    );
  }

  Widget _buildTileEdit(Transfer transferData) {
    return Container(
      key: UniqueKey(),
      height: 70,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                //TODO: Implement database service function for deletion
//                data.dayRemove(
//                    dayIndex: widget.dayIndex, transactionIndex: widget.transactionIndex);
//                tileTapped = false;
              });
            },
          ),
          SizedBox(width: 100),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                tileTapped = false;
                CustomBottomSheet().showBottomSheet(
                  context,
                  widget.transfer,
                );
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildTileDisplay(Transfer transferData) {
    return Container(
      key: UniqueKey(),
      height: 70,
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kButtonRadius), color: kBackgroundColor),
          child: Center(
            child: widget.transfer.icon,
          ),
        ),
        title: Text(
          widget.transfer.category,
          style: GoogleFonts.muli(
            textStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: kTextColorHeading),
          ),
        ),
        subtitle: Text(
          widget.transfer.name,
          style: GoogleFonts.muli(
            textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey),
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.transfer.isExpense
                  ? '- ' + '${widget.transfer.amount} €'
                  : '+ ' + '${widget.transfer.amount} €',
              style: GoogleFonts.muli(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: widget.transfer.isExpense ? kTextColorHeading : Colors.green),
              ),
            ),
            Text(
              DateFormatter().formatDate(widget.transfer.date),
              style: GoogleFonts.muli(
                textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
