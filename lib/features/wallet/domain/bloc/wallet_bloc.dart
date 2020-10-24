import 'dart:async';
import 'package:etherwallet/features/wallet/data/models/wallet.dart';
import 'package:etherwallet/features/wallet/domain/bloc/wallet_event.dart';
import 'package:etherwallet/features/wallet/domain/bloc/wallet_state.dart';
import 'package:etherwallet/services/address_service.dart';
import 'package:etherwallet/services/configuration_service.dart';
import 'package:etherwallet/services/contract_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart' as web3;

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final AddressService _addressService;
  final ConfigurationService _configurationService;
  final ContractService _contractService;

  Completer<bool> balanceUpdateComplete = Completer<bool>();

  WalletBloc(
      this._addressService, this._configurationService, this._contractService)
      : super(WalletStateUpdated(wallet: Wallet()));

  Future<void> initialise() async {
    final entropyMnemonic = _configurationService.getMnemonic();
    final privateKey = _configurationService.getPrivateKey();

    if (entropyMnemonic != null && entropyMnemonic.isNotEmpty) {
      _initialiseFromMnemonic(entropyMnemonic);
      return;
    }

    _initialiseFromPrivateKey(privateKey);
  }

  Future<void> _initialiseFromMnemonic(String entropyMnemonic) async {
    final mnemonic = _addressService.entropyToMnemonic(entropyMnemonic);
    final privateKey = _addressService.getPrivateKey(mnemonic);
    final address = await _addressService.getPublicAddress(privateKey);

    add(InitialiseWallet(address.toString(), privateKey));
  }

  Future<void> _initialiseFromPrivateKey(String privateKey) async {
    final address = await _addressService.getPublicAddress(privateKey);

    add(InitialiseWallet(address.toString(), privateKey));
  }

  Future<void> _registerUpdatingBalanceEvent(String address) async {
    add(UpdateBalance(address));

    _contractService.listenTransfer((from, to, value) async {
      var fromMe = from.toString() == address;
      var toMe = to.toString() == address;

      if (!fromMe && !toMe) {
        return;
      }

      print('======= balance updated =======');

      add(UpdateBalance(address));
    });
  }

  Future<bool> refreshBalance() async {
    balanceUpdateComplete = Completer<bool>();
    add(UpdateBalance(''));
    return balanceUpdateComplete.future;
  }

  Future<void> resetWallet() async {
    await _configurationService.setMnemonic(null);
    await _configurationService.setupDone(false);
  }

  @override
  Stream<WalletState> mapEventToState(WalletEvent event) async* {
    final currentState = state;
    if (event is InitialiseWallet) {
      if (currentState is WalletStateUpdated) {
        yield currentState.copyWith(
            wallet: currentState.wallet.rebuild((b) => b
              ..address = event.address
              ..privateKey = event.privateKey));
        await _registerUpdatingBalanceEvent(currentState.wallet.address);
        add(UpdateBalance(event.address));
      }
    } else if (event is UpdateBalance) {
      if (currentState is WalletStateUpdated) {
        var address =
            event.address != '' ? event.address : currentState.wallet.address;
        if (address == null) return;
        var tokenBalance = await _contractService
            .getTokenBalance(web3.EthereumAddress.fromHex(address));

        var ethBalance = await _contractService
            .getEthBalance(web3.EthereumAddress.fromHex(address));

        yield currentState.copyWith(
            wallet: currentState.wallet.rebuild((b) => b
              ..loading = false
              ..ethBalance = ethBalance.getInWei
              ..tokenBalance = tokenBalance));

        balanceUpdateComplete.complete(true);
      }
    }
  }
}
