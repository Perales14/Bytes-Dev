import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityHelper extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnectedStatus = false.obs;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityHelper() {
    _initConnectivity();
    _subscribeToConnectivityChanges();
  }

  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      print('Error initializing connectivity: $e');
    }
  }

  void _subscribeToConnectivityChanges() {
    _subscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // If there's at least one connection type that's not "none", we're connected
    isConnectedStatus.value =
        results.any((result) => result != ConnectivityResult.none);
  }

  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
