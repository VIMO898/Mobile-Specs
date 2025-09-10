import 'package:app/controllers/devices_controller.dart';
import 'package:app/providers/repositories/devices_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_activity_model.dart';

final devicesControllerProvider =
    StateNotifierProvider<DevicesController, UserActivityModel>((ref) {
      final repo = ref.watch(devicesRepositoryProvider);
      return DevicesController(repo);
    });
