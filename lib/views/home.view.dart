import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stock_market/components/see_all_button.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stock_market/components/stock_card.dart';
import 'package:stock_market/components/stock_list.dart';
import 'package:stock_market/components/wallet_summary_card.dart';
import 'package:stock_market/providers/account_provider.dart';

final String? token = dotenv.env['FINNHUB_TOKEN'];

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          firebaseUser != null ? 'Hi, ${firebaseUser.email!}' : '',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            const WalletSummaryCard(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SeeAllButton(),
              ],
            ),
            Expanded(
              child: ChangeNotifierProvider(
                create: (context) => AccountProvider(),
                child: Consumer<AccountProvider>(builder: (context, model, _) {
                  final stocksMap =
                      model.isLoading ? fakeStockMap : model.userStocksMap;

                  return Skeletonizer(
                    enabled: model.isLoading,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final stock = stocksMap.entries.elementAt(index).value;

                        return StockCard(stock: stock);
                      },
                      separatorBuilder: (_, index) => const SizedBox(
                        width: 20,
                      ),
                      itemCount: stocksMap.length,
                    ),
                  );
                }),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SeeAllButton(),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Expanded(child: StockListView()),
          ],
        ),
      ),
    );
  }
}
