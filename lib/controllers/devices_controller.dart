import 'dart:async';

import 'package:app/models/device_overview_model.dart';
import 'package:app/models/user_activity_entry_model.dart';
import 'package:app/models/user_activity_model.dart';
import 'package:app/repositories/devices_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevicesController extends StateNotifier<UserActivityModel> {
  final BaseDevicesRepository repo;
  StreamSubscription<UserActivityModel>? _subscription;
  DevicesController(this.repo) : super(defaultUserActivity) {
    _initializeState();
  }
  void _initializeState() async {
    _subscription = repo.getUserDeviceActivityStream().listen((
      userDeviceActivity,
    ) {
      state = userDeviceActivity;
    });
  }

  Future<List<DeviceOverviewModel>> getDevices(
    DeviceType type, [
    List<String>? ids,
  ]) async {
    if (ids?.isNotEmpty ?? false) return repo.getDevices(ids!);
    List<String> deviceIds = [];
    switch (type) {
      case DeviceType.wishlist:
        if (state.wishlist?.isEmpty ?? true) {
          return List<DeviceOverviewModel>.from([]);
        }
        deviceIds = state.wishlist!.map((d) => d.id).toList();
      case DeviceType.comparedDevices:
        if (state.comparedDevices?.isEmpty ?? true) {
          return List<DeviceOverviewModel>.from([]);
        }
        deviceIds = state.comparedDevices!.map((d) => d.id).toList();
      case DeviceType.history:
        if (state.history?.isEmpty ?? true) {
          return List<DeviceOverviewModel>.from([]);
        }
        deviceIds = state.history!.map((d) => d.id).toList();
    }
    // final deviceIds = state.map((d) => d.id).toList();
    return repo.getDevices(deviceIds);
  }

  Stream<Future<List<DeviceOverviewModel>>> getDevicesStream(DeviceType type) {
    return repo.getDevicesStream(type);
  }

  Future<void> addDevice(DeviceType type, DeviceOverviewModel device) async {
    late bool deviceExists;
    switch (type) {
      case DeviceType.wishlist:
        deviceExists =
            state.wishlist?.any((entry) => entry.id == device.id) ?? false;
      case DeviceType.comparedDevices:
        deviceExists =
            state.comparedDevices?.any((entry) => entry.id == device.id) ??
            false;
      case DeviceType.history:
        deviceExists =
            state.history?.any((entry) => entry.id == device.id) ?? false;
    }
    if (deviceExists) return;

    final currTimestamp = DateTime.now().millisecondsSinceEpoch;
    final deviceEntry = UserActivityEntryModel(
      id: device.id,
      timestamp: currTimestamp,
    );
    return repo.addDevice(type, deviceEntry, device);
  }

  Future<void> removeDevice(DeviceType type, String deviceId) async {
    late UserActivityEntryModel deviceEntry;
    switch (type) {
      case DeviceType.wishlist:
        final deviceEntryIndex =
            state.wishlist?.indexWhere((d) => d.id == deviceId) ?? -1;
        final deviceExists = deviceEntryIndex != -1;
        if (!deviceExists) return;
        deviceEntry = state.wishlist![deviceEntryIndex];
      case DeviceType.comparedDevices:
        final deviceEntryIndex =
            state.comparedDevices?.indexWhere((d) => d.id == deviceId) ?? -1;
        final deviceExists = deviceEntryIndex != -1;
        if (!deviceExists) return;
        deviceEntry = state.comparedDevices![deviceEntryIndex];
      case DeviceType.history:
        final deviceEntryIndex =
            state.history?.indexWhere((d) => d.id == deviceId) ?? -1;
        final deviceExists = deviceEntryIndex != -1;
        if (!deviceExists) return;
        deviceEntry = state.history![deviceEntryIndex];
    }
    return repo.removeDevice(type, deviceEntry);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
