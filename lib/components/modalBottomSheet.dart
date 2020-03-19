import 'package:flutter/material.dart';
import 'package:flutter_haushaltsbuch/models/transfer.dart';
import 'package:flutter_haushaltsbuch/utility/constants.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class CustomBottomSheet {
  bool tappedPaytype = false;
  int categoryStage = 0;
  double amount;
  String name;
  bool isExpense;
  bool isRecurring = false;

  //TODO: - Simplify nullcheck
  void nullcheckTransaction(Transfer transaction) {
    // Nullcheck transaction if Edit
    if (transaction != null) {
      amount = transaction.amount;
      name = transaction.name;
      tappedPaytype = true;
      isRecurring = transaction.isRecurring;
      isExpense = transaction.isExpense;
    }
  }

  void showBottomSheet(BuildContext context, [Transfer transaction]) {
    nullcheckTransaction(transaction);
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kButtonRadius),
            topRight: Radius.circular(kButtonRadius),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Add new position',
                    style: kTabbarTextStyle.copyWith(fontSize: 30),
                  ),
                  SizedBox(height: 30),
                  _buildPaymentTypeAmountContainer(context, setModalState),
                  SizedBox(height: 30),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 80,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: kTabbarTextStyle.copyWith(fontSize: 20),
                      decoration: InputDecoration(hintText: 'Type category'),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 80,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: kTabbarTextStyle.copyWith(fontSize: 20),
                      decoration: InputDecoration(hintText: 'Type name'),
                    ),
                  ),
                  //isrecurring?
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Is this a recurring expense ?',
                        style: kTabbarTextStyle.copyWith(fontSize: 20),
                      ),
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          activeColor: kTextColorHeading,
                          value: isRecurring,
                          onChanged: (value) => setModalState(() => isRecurring = value),
                        ),
                      ),
                    ],
                  ),
                  //tag/calendar
                  //Save button
                  SizedBox(height: 100),
                  _buildSaveButton(context),
                ],
              ),
            );
          });
        });
  }

  Widget _buildPaymentTypeAmountContainer(BuildContext context, StateSetter setModalState) {
    return Container(
      height: 60,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        switchInCurve: Curves.easeInQuint,
        switchOutCurve: Curves.easeOutQuint,
        child: tappedPaytype
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    child: TextField(
                      style: isExpense
                          ? kTabbarTextStyle.copyWith(fontSize: 20, color: Colors.red)
                          : kTabbarTextStyle.copyWith(fontSize: 20, color: Colors.green),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: amount ?? 'Type your amount',
                      ),
                    ),
                  ),
                  //TODO: - Add option to change  paymenttype
                ],
              )
            : Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => setModalState(() {
                        tappedPaytype = true;
                        isExpense = false;
                      }),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          boxShadow: [kCardShadow],
                          borderRadius: BorderRadius.circular(kButtonRadius),
                        ),
                        child: Icon(
                          Icons.add,
                          color: kBackgroundColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setModalState(() {
                        tappedPaytype = true;
                        isExpense = true;
                      }),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          boxShadow: [kCardShadow],
                          borderRadius: BorderRadius.circular(kButtonRadius),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: kBackgroundColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO: - Implement save functionality
        Navigator.pop(context);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: kTextColorHeading,
          boxShadow: [kCardShadow],
          borderRadius: BorderRadius.circular(kButtonRadius),
        ),
        child: Icon(
          Icons.save,
          color: kBackgroundColor,
        ),
      ),
    );
  }
}
