import 'package:etherwallet/blocs/wallet/wallet_state.dart';
import 'package:etherwallet/components/wallet/balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/wallet/wallet_bloc.dart';
import 'components/dialog/alert.dart';
import 'components/menu/main_menu.dart';

class WalletMainPage extends StatelessWidget {
  WalletMainPage(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    //ignore: close_sinks
    var walletBloc = BlocProvider.of<WalletBloc>(context);
    return Scaffold(
      drawer: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state is WalletStateUpdated) {
            return MainMenu(
              address: state.wallet.address,
              onReset: () async {
                Alert(
                    title: "Warning",
                    text:
                        "Without your seed phrase or private key you cannot restore your wallet balance",
                    actions: [
                      FlatButton(
                        child: Text("cancel"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      FlatButton(
                        child: Text("reset"),
                        onPressed: () async {
                          await walletBloc.resetWallet();
                          Navigator.popAndPushNamed(context, "/");
                        },
                      )
                    ]).show(context);
              },
            );
          }
          return Container();
        },
      ),
      appBar: AppBar(
        title: Text(title),
        actions: [
          Builder(
              builder: (context) => BlocBuilder<WalletBloc, WalletState>(
                      builder: (context, state) {
                    if (state is WalletStateUpdated) {
                      return IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: !state.wallet.loading
                            ? () async {
                                if (await walletBloc.refreshBalance())
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Balance updated"),
                                    duration: Duration(milliseconds: 800),
                                  ));
                              }
                            : null,
                      );
                    }
                    return Container();
                  })),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              Navigator.of(context).pushNamed("/transfer");
            },
          ),
        ],
      ),
      body: BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
        if (state is WalletStateUpdated) {
          return Balance(
            address: state.wallet.address,
            ethBalance: state.wallet.ethBalance,
            tokenBalance: state.wallet.tokenBalance,
          );
        }
        return Container();
      }),
    );
  }
}
