import 'package:etherwallet/context_old/setup/wallet_setup_handler.dart';
import 'package:etherwallet/context_old/setup/wallet_setup_state.dart';
import 'package:etherwallet/features/setup/data/models/wallet_setup.dart';
import 'package:etherwallet/services/address_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import '../hook_provider.dart';

class WalletSetupProvider extends ContextProviderWidget<WalletSetupHandler> {
  WalletSetupProvider(
      {Widget child, HookWidgetBuilder<WalletSetupHandler> builder})
      : super(child: child, builder: builder);

  @override
  Widget build(BuildContext context) {
    final store = useReducer<WalletSetup, WalletSetupAction>(reducer,
        initialState: WalletSetup());

    final addressService = GetIt.instance<AddressService>();
    final handler = useMemoized(
      () => WalletSetupHandler(store, addressService),
      [addressService, store],
    );

    return provide(context, handler);
  }
}

WalletSetupHandler useWalletSetup(BuildContext context) {
  var handler = GetIt.instance<WalletSetupHandler>();

  return handler;
}
