import 'package:etherwallet/features/wallet/data/models/wallet.dart';
import 'package:etherwallet/services/address_service.dart';
import 'package:etherwallet/services/configuration_service.dart';
import 'package:etherwallet/services/contract_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import '../hook_provider.dart';
import 'wallet_state.dart';
import 'wallet_handler.dart';

class WalletProvider extends ContextProviderWidget<WalletHandler> {
  WalletProvider({Widget child, HookWidgetBuilder<WalletHandler> builder})
      : super(child: child, builder: builder);

  @override
  Widget build(BuildContext context) {
    final store =
        useReducer<Wallet, WalletAction>(reducer, initialState: Wallet());
    var getIt = GetIt.instance;

    final addressService = getIt<AddressService>();
    final contractService = getIt<ContractService>();
    final configurationService = getIt<ConfigurationService>();
    final handler = useMemoized(
      () => WalletHandler(
        store,
        addressService,
        contractService,
        configurationService,
      ),
      [addressService, store],
    );

    return provide(context, handler);
  }
}

WalletHandler useWallet(BuildContext context) {
  var handler = GetIt.instance<WalletHandler>();

  return handler;
}
