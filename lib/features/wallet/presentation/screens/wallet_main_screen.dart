import 'package:etherwallet/features/wallet/domain/bloc/wallet_state.dart';
import 'package:etherwallet/features/wallet/presentation/widgets/balance.dart';
import 'package:etherwallet/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/bloc/wallet_bloc.dart';
import '../widgets/alert.dart';
import '../widgets/main_menu.dart';

class WalletMainScreen extends StatefulWidget {
  WalletMainScreen(this.title);

  final String title;

  @override
  _WalletMainScreenState createState() => _WalletMainScreenState();
}

class _WalletMainScreenState extends State<WalletMainScreen> {
  @override
  void initState() {
    BlocProvider.of<WalletBloc>(context).initialise();
    super.initState();
  }

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
                          Navigator.popAndPushNamed(
                              context, Routes.WalletMainScreen);
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
        title: Text(widget.title),
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
              Navigator.of(context).pushNamed(Routes.WalletTransferScreen);
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
