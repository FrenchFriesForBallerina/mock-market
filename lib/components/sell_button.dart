import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:stock_market/providers/stock_data_provider.dart';
import 'package:stock_market/services/database.dart';
import 'package:stock_market/utils/utils.dart';
import 'package:stock_market/components/numpad.dart';

class SellButton extends StatefulWidget {
  final String stockSymbol;

  const SellButton({
    Key? key,
    required this.stockSymbol,
  }) : super(key: key);

  @override
  State<SellButton> createState() => _SellButtonState();
}

class _SellButtonState extends State<SellButton> {
  late int amount;

  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    final stockDataProvider = context.watch<StockDataProviderV2>();
    final stock = stockDataProvider.stocksMap[widget.stockSymbol];
    final String company = getCompanyName(widget.stockSymbol);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: MaterialButton(
        onPressed: () {
          final currentContext = context;
          showModalBottomSheet(
            context: currentContext,
            builder: (context) => NumberInputView(
              onNumberSubmitted: (number) async {
                amount = int.parse(number);
                if (firebaseUser != null && stock != null) {
                  bool success = await _databaseService.sell(
                    firebaseUser,
                    amount,
                    stock.price,
                    stock.symbol,
                  );
                  if (success) {
                    if (currentContext.mounted) {
                      _showSuccessAlert(currentContext);
                    }
                  } else {
                    log('failure');
                    if (currentContext.mounted) {
                      _showFailureAlert(currentContext);
                    }
                  }
                }
              },
            ),
          );
        },
        color: const Color(0xFF22CC9E),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Text(
          'Sell $company',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void _showSuccessAlert(BuildContext context) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Sold $amount ${widget.stockSymbol}!',
        autoCloseDuration: const Duration(seconds: 3),
        confirmBtnText: 'Go to Portfolio',
        onConfirmBtnTap: () async {
          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) Navigator.pushNamed(context, '/wallet');
        });
  }

  void _showFailureAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Oops...',
      text: 'Transaction failed',
    );
  }
}