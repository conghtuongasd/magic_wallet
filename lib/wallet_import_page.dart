import 'package:etherwallet/blocs/setup/setup_state.dart';
import 'package:etherwallet/components/wallet/import_wallet_form.dart';
import 'package:etherwallet/model/wallet_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/setup/setup_bloc.dart';

class WalletImportPage extends StatelessWidget {
  WalletImportPage(this.title);

  final String title;

  Widget build(BuildContext context) {
    //ignore: close_sinks
    var walletSetupBloc = BlocProvider.of<WalletSetupBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: BlocBuilder<WalletSetupBloc, WalletSetupState>(
          builder: (context, state) {
            if (state is WalletSetupUpdated) {
              if (state.isSetupSuccessfully)
                Navigator.of(context).popAndPushNamed("/");
              return ImportWalletForm(
                errors: state.walletSetup.errors.toList(),
                onImport: !state.walletSetup.loading
                    ? (type, value) async {
                        switch (type) {
                          case WalletImportType.mnemonic:
                            walletSetupBloc.importFromMnemonic(value);
                            break;
                          case WalletImportType.privateKey:
                            walletSetupBloc.importFromPrivateKey(value);
                            break;
                          default:
                            break;
                        }
                      }
                    : null,
              );
            }
            return Container();
          },
        ));
  }
}
