import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final isConnected =
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;

    print('ConnectivityService: Connection status: $connectivityResult');
    print('ConnectivityService: Is connected: $isConnected');

    return isConnected;
  }
}
