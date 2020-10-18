import 'package:equatable/equatable.dart';
import 'package:etherwallet/model/wallet_setup.dart';

abstract class WalletSetupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GenerateMnemonicMnemonic extends WalletSetupEvent {}

class WalletSetupConfirmMnemonic extends WalletSetupEvent {
  WalletSetupConfirmMnemonic(this.mnemonic);
  final String mnemonic;
}

class WalletSetupImportFromMnemonic extends WalletSetupEvent {
  WalletSetupImportFromMnemonic(this.mnemonic);
  final String mnemonic;
}

class WalletSetupImportFromPrivateKey extends WalletSetupEvent {
  WalletSetupImportFromPrivateKey(this.privateKey);
  final String privateKey;
}

class WalletSetupChangeStep extends WalletSetupEvent {
  WalletSetupChangeStep(this.step);
  final WalletCreateSteps step;
}

class WalletSetupChangeMethod extends WalletSetupEvent {
  WalletSetupChangeMethod(this.method);
  final WalletSetupMethod method;
}
