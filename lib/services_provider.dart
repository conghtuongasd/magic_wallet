import 'package:etherwallet/app_config.dart';
import 'package:etherwallet/service/address_service.dart';
import 'package:etherwallet/service/configuration_service.dart';
import 'package:etherwallet/service/contract_service.dart';
import 'package:etherwallet/utils/contract_parser.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

Future<void> initializeServices(AppConfigParams params) async {
  final client = Web3Client(params.web3HttpUrl, Client(), socketConnector: () {
    return IOWebSocketChannel.connect(params.web3RdpUrl).cast<String>();
  });

  final sharedPrefs = await SharedPreferences.getInstance();

  final configurationService = ConfigurationService(sharedPrefs);
  final addressService = AddressService(configurationService);
  final contract = await ContractParser.fromAssets(
      'TargaryenCoin.json', params.contractAddress);

  final contractService = ContractService(client, contract);

  final getIt = GetIt.instance;

  getIt.allowReassignment = true;

  getIt.registerSingleton<ConfigurationService>(configurationService);

  getIt.registerSingleton<AddressService>(addressService);

  getIt.registerSingleton<ContractService>(contractService);
}
