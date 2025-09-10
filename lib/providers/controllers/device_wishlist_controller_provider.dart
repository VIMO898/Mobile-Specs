import 'package:app/controllers/device_wishlist_controller.dart';
import 'package:app/models/device_overview_model.dart';
import 'package:app/providers/repositories/devices_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceWishlistControllerProvider =
    StateNotifierProvider<DeviceWishlistController, List<DeviceOverviewModel>>((
      ref,
    ) {
      final repo = ref.watch(devicesRepositoryProvider);
      return DeviceWishlistController(repo);
    });
