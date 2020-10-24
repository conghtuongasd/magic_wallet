import 'package:etherwallet/features/setup/data/models/wallet_setup.dart';
import 'package:etherwallet/features/setup/domain/bloc/setup_state.dart';
import 'package:etherwallet/features/setup/presentation/widgets/import_wallet_form.dart';
import 'package:etherwallet/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/bloc/setup_bloc.dart';

class WalletImportScreen extends StatelessWidget {
  WalletImportScreen(this.title);

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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context)
                      .popAndPushNamed(Routes.WalletMainScreen);
                });

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
