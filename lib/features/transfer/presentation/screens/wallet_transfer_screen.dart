import 'package:etherwallet/features/transfer/domain/bloc/transfer_bloc.dart';
import 'package:etherwallet/features/transfer/domain/bloc/transfer_state.dart';
import 'package:etherwallet/features/transfer/presentation/widgets/transfer_form.dart';
import 'package:etherwallet/features/wallet/domain/bloc/wallet_bloc.dart';
import 'package:etherwallet/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/loading.dart';

class WalletTransferScreen extends StatefulWidget {
  WalletTransferScreen({@required this.title});

  final String title;

  @override
  _WalletTransferScreenState createState() => _WalletTransferScreenState();
}

class _WalletTransferScreenState extends State<WalletTransferScreen> {
  String qrcodeAddress = "";

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    var transferBloc = BlocProvider.of<TransferBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            BlocBuilder<TransferBloc, TransferCoinState>(
                builder: (context, state) {
              var isLoading = (state is TransferStateUpdated) &&
                  state.walletTransfer.loading;
              return IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: !isLoading
                    ? () {
                        Navigator.of(context).pushNamed(
                          Routes.QRCodeReaderScreen,
                          arguments: (scannedAddress) async {
                            setState(() {
                              qrcodeAddress = scannedAddress.toString();
                            });
                          },
                        );
                      }
                    : null,
              );
            }),
          ],
        ),
        body: BlocBuilder<TransferBloc, TransferCoinState>(
            builder: (context, state) {
          var isLoading =
              (state is TransferStateUpdated) && state.walletTransfer.loading;
          return isLoading
              ? Loading()
              : TransferForm(
                  address: qrcodeAddress,
                  onSubmit: (address, amount) async {
                    var success = await transferBloc.transfer(address, amount);

                    if (success) {
                      BlocProvider.of<WalletBloc>(context).refreshBalance();
                      Navigator.popUntil(context,
                          ModalRoute.withName(Routes.WalletMainScreen));
                    }
                  },
                );
        }));
  }
}
