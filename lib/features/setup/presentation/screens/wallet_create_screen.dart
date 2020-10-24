import 'package:etherwallet/features/setup/data/models/wallet_setup.dart';
import 'package:etherwallet/features/setup/domain/bloc/setup_bloc.dart';
import 'package:etherwallet/features/setup/domain/bloc/setup_state.dart';
import 'package:etherwallet/features/setup/presentation/widgets/confirm_mnemonic.dart';
import 'package:etherwallet/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/display_mnemonic.dart';

class WalletCreateScreen extends StatelessWidget {
  WalletCreateScreen(this.title);

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
          if (state.isSetupSuccessfully) {
            Future.delayed(
                Duration(milliseconds: 500),
                () => Navigator.of(context)
                    .popAndPushNamed(Routes.WalletMainScreen));
          }

          return state.walletSetup.step == WalletCreateSteps.display
              ? DisplayMnemonic(
                  mnemonic: state.walletSetup.mnemonic ?? '',
                  onNext: () async {
                    walletSetupBloc.goto(WalletCreateSteps.confirm);
                  },
                )
              : ConfirmMnemonic(
                  mnemonic: state.walletSetup.mnemonic,
                  errors: state.walletSetup.errors.toList(),
                  onConfirm: !state.walletSetup.loading
                      ? (confirmedMnemonic) =>
                          walletSetupBloc.confirmMnemonic(confirmedMnemonic)
                      : null,
                  onGenerateNew: !state.walletSetup.loading
                      ? () async {
                          walletSetupBloc.generateMnemonic();
                          walletSetupBloc.goto(WalletCreateSteps.display);
                        }
                      : null,
                );
        }
        return Container();
      }),
    );
  }
}
