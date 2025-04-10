import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:get/get.dart';
import 'dart:io';

class NetworkConnectivity extends GetxController {
  final Rx<bool> _connected = true.obs;
  final Connectivity _connectivity = Connectivity();

  static NetworkConnectivity get instance => Get.find<NetworkConnectivity>();

  StreamController connectionChangeController = StreamController.broadcast();

  bool get connected => _connected.value;

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  void initialize() {
    _connectivity.onConnectivityChanged.listen(
      _connectionChange as void Function(List<ConnectivityResult> event)?,
    );
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  @override
  void dispose() {
    connectionChangeController.close();
    super.dispose();
  }

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  Future<bool> checkConnection() async {
    bool previousConnection = connected;
    try {
      final result = await InternetAddress.lookup('google.com')
          .catchError(
            (error) {
              _connected.value = false;
              return <InternetAddress>[];
            },
            test: (error) {
              return false;
            },
          )
          .onError((error, stackTrace) {
            _connected.value = false;
            return [];
          });
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _connected.value = true;
      } else {
        _connected.value = false;
      }
    } catch (e) {
      _connected.value = false;
      Logger.info(e.toString());
    }

    _connected.refresh();

    if (previousConnection != connected) {
      connectionChangeController.add(connected);
    }

    return connected;
  }
}
