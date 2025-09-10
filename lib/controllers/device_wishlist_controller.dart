import 'package:app/exceptions/custom_exception.dart';
import 'package:app/models/device_overview_model.dart';
import 'package:app/repositories/devices_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_activity_entry_model.dart';

// This state notifier is only to display updated list of wishlisted devices on home screen.

class DeviceWishlistController
    extends StateNotifier<List<DeviceOverviewModel>> {
  final BaseDevicesRepository repo;
  DeviceWishlistController(this.repo) : super([]) {
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    try {
      final wishlist = await repo.getDevicesStream(DeviceType.wishlist).first;
      final wishlistedDevices = await wishlist;
      state = wishlistedDevices;
    } on CustomException catch (_) {
      rethrow;
    } catch (e) {
      throw CustomException(
        code: '503',
        message: 'Failed to fetch the wishlist due to a network error',
      );
    }
  }

  Future<void> addDevice(DeviceOverviewModel device) async {
    final deviceAlreadyExists = state.contains(device);
    if (deviceAlreadyExists) return;
    final currTimestamp = DateTime.now().millisecondsSinceEpoch;
    final deviceEntry = UserActivityEntryModel(
      id: device.id,
      timestamp: currTimestamp,
    );
    await repo.addDevice(DeviceType.wishlist, deviceEntry, device);
    state = [device, ...state];
  }

  Future<void> removeDevice(UserActivityEntryModel deviceEntry) async {
    final deviceExists = state.any((d) => d.id == deviceEntry.id);
    if (!deviceExists) return;
    await repo.removeDevice(DeviceType.wishlist, deviceEntry);
    state = state.where((d) => d.id != deviceEntry.id).toList();
  }
}
