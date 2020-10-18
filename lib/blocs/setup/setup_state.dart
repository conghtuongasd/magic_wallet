import 'package:equatable/equatable.dart';
import 'package:etherwallet/model/wallet_setup.dart';

abstract class WalletSetupState extends Equatable {
  const WalletSetupState();

  @override
  List<Object> get props => [];
}

class WalletSetupInitialized extends WalletSetupState {
  final WalletSetup walletSetup = WalletSetup();
}

class WalletSetupUpdated extends WalletSetupState {
  final WalletSetup walletSetup;
  final bool isSetupSuccessfully;

  WalletSetupUpdated({this.walletSetup, this.isSetupSuccessfully});

  WalletSetupUpdated copyWith(
      {WalletSetup walletSetup, bool isSetupSuccessfully}) {
    return WalletSetupUpdated(
        walletSetup: walletSetup ?? this.walletSetup,
        isSetupSuccessfully: isSetupSuccessfully ?? this.isSetupSuccessfully);
  }

  @override
  List<Object> get props => [walletSetup, isSetupSuccessfully];
}
