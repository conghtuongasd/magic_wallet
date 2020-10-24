import 'dart:async';
import 'package:etherwallet/features/setup/data/models/wallet_setup.dart';
import 'package:etherwallet/features/setup/domain/bloc/setup_event.dart';
import 'package:etherwallet/features/setup/domain/bloc/setup_state.dart';
import 'package:etherwallet/services/address_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletSetupBloc extends Bloc<WalletSetupEvent, WalletSetupState> {
  StreamSubscription _notificationSubscription;

  final AddressService _addressService;

  WalletSetupBloc(this._addressService)
      : super(WalletSetupUpdated(
            walletSetup: WalletSetup(), isSetupSuccessfully: false));

  void generateMnemonic() {
    add(GenerateMnemonicMnemonic());
  }

  Future<void> confirmMnemonic(String mnemonic) async {
    add(WalletSetupConfirmMnemonic(mnemonic));
  }

  void goto(WalletCreateSteps step) {
    add(WalletSetupChangeStep(step));
  }

  Future<void> importFromMnemonic(String mnemonic) async {
    add(WalletSetupImportFromMnemonic(mnemonic));
  }

  Future<void> importFromPrivateKey(String privateKey) async {
    add(WalletSetupImportFromPrivateKey(privateKey));
  }

  String _mnemonicNormalise(String mnemonic) {
    return _mnemonicWords(mnemonic).join(" ");
  }

  List<String> _mnemonicWords(String mnemonic) {
    return mnemonic
        .split(" ")
        .where((item) => item != null && item.trim().isNotEmpty)
        .map((item) => item.trim())
        .toList();
  }

  bool _validateMnemonic(String mnemonic) {
    return _mnemonicWords(mnemonic).length == 12;
  }

  WalletSetup _changeToErrorState(WalletSetup state, String errorMsg) {
    return state.rebuild((b) => b
      ..loading = false
      ..errors.clear()
      ..errors.add(errorMsg));
  }

  WalletSetup _setupStart(WalletSetup state) {
    return state.rebuild((b) => b
      ..errors.clear()
      ..loading = true);
  }

  @override
  Stream<WalletSetupState> mapEventToState(WalletSetupEvent event) async* {
    final currentState = state;

    if (event is GenerateMnemonicMnemonic) {
      if (currentState is WalletSetupUpdated) {
        var mnemonic = _addressService.generateMnemonic();
        yield currentState.copyWith(
            walletSetup: currentState.walletSetup.rebuild((b) => b
              ..mnemonic = mnemonic
              ..loading = false
              ..errors.clear()));
      }
    } else if (event is WalletSetupConfirmMnemonic) {
      if (currentState is WalletSetupUpdated) {
        var walletSetupState = currentState.walletSetup;
        if (walletSetupState.mnemonic != event.mnemonic) {
          yield currentState.copyWith(
              walletSetup: _changeToErrorState(
                  walletSetupState, "Invalid mnemonic, please try again."));
          return;
        }
        await _addressService.setupFromMnemonic(event.mnemonic);
        yield currentState.copyWith(isSetupSuccessfully: true);
      }
    } else if (event is WalletSetupImportFromMnemonic) {
      if (currentState is WalletSetupUpdated) {
        var walletSetupState = currentState.walletSetup;
        try {
          yield currentState.copyWith(
              walletSetup: _setupStart(walletSetupState));

          if (_validateMnemonic(event.mnemonic)) {
            final normalisedMnemonic = _mnemonicNormalise(event.mnemonic);
            await _addressService.setupFromMnemonic(normalisedMnemonic);
            yield currentState.copyWith(isSetupSuccessfully: true);
          } else
            yield currentState.copyWith(
                walletSetup: _changeToErrorState(walletSetupState,
                    "Invalid mnemonic, it requires 12 words."));
        } catch (e) {
          yield currentState.copyWith(
              walletSetup: _changeToErrorState(
                  walletSetupState, "Invalid mnemonic, please try again."));
        }
      }
    } else if (event is WalletSetupImportFromPrivateKey) {
      if (currentState is WalletSetupUpdated) {
        var walletSetupState = currentState.walletSetup;

        try {
          yield currentState.copyWith(
              walletSetup: _setupStart(walletSetupState));
          await _addressService.setupFromPrivateKey(event.privateKey);
          yield currentState.copyWith(isSetupSuccessfully: true);
        } catch (e) {
          yield currentState.copyWith(
              walletSetup: _changeToErrorState(walletSetupState, e.toString()));
        }
      }
    } else if (event is WalletSetupChangeStep) {
      if (currentState is WalletSetupUpdated) {
        var walletSetupState = currentState.walletSetup;
        yield currentState.copyWith(
            walletSetup: walletSetupState.rebuild((b) => b
              ..step = event.step
              ..loading = false
              ..errors.clear()));
      }
    } else if (event is WalletSetupChangeMethod) {
      if (currentState is WalletSetupUpdated) {
        var walletSetupState = currentState.walletSetup;
        yield currentState.copyWith(
            walletSetup: walletSetupState
              ..rebuild((b) => b
                ..method = event.method
                ..loading = false
                ..errors.clear()));
      }
    }
  }
}
